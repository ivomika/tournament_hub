import {
  parseProjection,
  parseProjectionEvent,
  protocolVersion,
  type SpectatorProjectionDto,
} from "./protocol.ts";
import {
  initialSpectatorState,
  spectatorReducer,
  type SpectatorClientAction,
  type SpectatorClientState,
} from "./reducer.ts";

type Listener = (state: SpectatorClientState) => void;
type SocketFactory = (url: string) => WebSocket;

export interface SpectatorClientOptions {
  fetcher?: typeof fetch;
  socketFactory?: SocketFactory;
  location?: Pick<Location, "origin" | "protocol" | "host">;
  retryDelayMs?: number;
}

export class SpectatorClient {
  private state: SpectatorClientState = initialSpectatorState;
  private readonly listeners = new Set<Listener>();
  private readonly fetcher: typeof fetch;
  private readonly socketFactory: SocketFactory;
  private readonly clientLocation: Pick<
    Location,
    "origin" | "protocol" | "host"
  >;
  private readonly retryDelayMs: number;
  private socket?: WebSocket;
  private retryTimer?: ReturnType<typeof setTimeout>;
  private stopped = true;

  constructor(options: SpectatorClientOptions = {}) {
    this.fetcher = options.fetcher ?? fetch;
    this.socketFactory = options.socketFactory ?? ((url) => new WebSocket(url));
    this.clientLocation = options.location ?? window.location;
    this.retryDelayMs = options.retryDelayMs ?? 1_500;
  }

  get current(): SpectatorClientState {
    return this.state;
  }

  subscribe(listener: Listener): () => void {
    this.listeners.add(listener);
    listener(this.state);
    return () => this.listeners.delete(listener);
  }

  start(): void {
    if (!this.stopped) return;
    this.stopped = false;
    void this.loadSnapshotAndConnect();
  }

  stop(): void {
    this.stopped = true;
    if (this.retryTimer !== undefined) clearTimeout(this.retryTimer);
    this.retryTimer = undefined;
    this.socket?.close(1000, "NORMAL");
    this.socket = undefined;
  }

  retry(): void {
    if (this.stopped) return;
    if (this.retryTimer !== undefined) clearTimeout(this.retryTimer);
    this.retryTimer = undefined;
    this.socket?.close(1000, "NORMAL");
    this.socket = undefined;
    void this.loadSnapshotAndConnect();
  }

  private async loadSnapshotAndConnect(): Promise<void> {
    if (this.stopped) return;
    this.dispatch({
      type: "connection",
      connection: this.state.projection ? "reconnecting" : "connecting",
    });
    try {
      const response = await this.fetcher(
        `${this.clientLocation.origin}/api/spectator/v1/snapshot`,
        { method: "GET", headers: { accept: "application/json" } },
      );
      if (response.status === 503 || response.status === 404) {
        this.dispatch({ type: "connection", connection: "waiting" });
        this.scheduleRetry();
        return;
      }
      if (!response.ok) throw new Error("SNAPSHOT_HTTP_ERROR");
      const parsed = parseProjection(await response.json());
      if (!parsed.ok) {
        this.dispatch({
          type: "failure",
          code: parsed.code,
          incompatible: parsed.code === "INCOMPATIBLE_VERSION",
        });
        return;
      }
      this.dispatch({ type: "snapshot", projection: parsed.value });
      if (parsed.value.tournament.lifecycle === "finished") return;
      this.connect(parsed.value);
    } catch {
      this.dispatch({
        type: "connection",
        connection: this.state.projection ? "stale" : "error",
      });
      this.scheduleRetry();
    }
  }

  private connect(projection: SpectatorProjectionDto): void {
    if (this.stopped) return;
    const scheme = this.clientLocation.protocol === "https:" ? "wss" : "ws";
    const socket = this.socketFactory(
      `${scheme}://${this.clientLocation.host}/ws`,
    );
    this.socket = socket;
    socket.addEventListener("open", () => {
      socket.send(
        JSON.stringify({
          category: "handshake",
          type: "handshake.client",
          protocolVersion,
          payload: {
            clientType: "spectator",
            tournamentId: projection.tournamentId,
            lastSequence: this.state.lastSequence,
          },
        }),
      );
    });
    socket.addEventListener("message", (event) => this.onMessage(event.data));
    socket.addEventListener("close", () => {
      if (this.socket !== socket) return;
      this.socket = undefined;
      if (
        this.stopped ||
        this.state.connection === "incompatible" ||
        this.state.projection?.tournament.lifecycle === "finished"
      )
        return;
      this.dispatch({
        type: "connection",
        connection: this.state.projection ? "stale" : "error",
      });
      this.scheduleRetry();
    });
    socket.addEventListener("error", () => socket.close());
  }

  private onMessage(raw: unknown): void {
    if (typeof raw !== "string") {
      this.failPayload("INVALID_PAYLOAD");
      return;
    }
    let message: unknown;
    try {
      message = JSON.parse(raw);
    } catch {
      this.failPayload("INVALID_PAYLOAD");
      return;
    }
    if (!isRecord(message)) {
      this.failPayload("INVALID_PAYLOAD");
      return;
    }
    if (message.protocolVersion !== protocolVersion) {
      this.failPayload("INCOMPATIBLE_VERSION", true);
      return;
    }
    if (message.category === "event") {
      const event = parseProjectionEvent(message);
      if (!event.ok) {
        this.failPayload(event.code, event.code === "INCOMPATIBLE_VERSION");
        return;
      }
      this.dispatch({ type: "event", event: event.value });
      if (this.state.connection === "stale") this.socket?.close();
      return;
    }
    if (message.category === "error") {
      const code =
        typeof message.code === "string" ? message.code : "PROTOCOL_ERROR";
      this.failPayload(code, code === "PROTOCOL_UNSUPPORTED");
      return;
    }
    if (message.category !== "control" || typeof message.type !== "string")
      return;
    if (message.type === "sync.started") {
      this.dispatch({ type: "connection", connection: "synchronizing" });
      return;
    }
    if (message.type === "sync.snapshot") {
      const payload = isRecord(message.payload) ? message.payload : undefined;
      const projection = parseProjection(payload?.snapshot);
      if (!projection.ok) {
        this.failPayload(
          projection.code,
          projection.code === "INCOMPATIBLE_VERSION",
        );
        return;
      }
      this.dispatch({ type: "snapshot", projection: projection.value });
      return;
    }
    if (message.type === "sync.completed") {
      this.dispatch({ type: "connection", connection: "live" });
    }
  }

  private failPayload(code: string, incompatible = false): void {
    this.dispatch({ type: "failure", code, incompatible });
    this.socket?.close();
  }

  private scheduleRetry(): void {
    if (this.stopped || this.state.connection === "incompatible") return;
    if (this.retryTimer !== undefined) clearTimeout(this.retryTimer);
    this.retryTimer = setTimeout(() => {
      this.retryTimer = undefined;
      void this.loadSnapshotAndConnect();
    }, this.retryDelayMs);
  }

  private dispatch(action: SpectatorClientAction): void {
    this.state = spectatorReducer(this.state, action);
    for (const listener of this.listeners) listener(this.state);
  }
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}
