import {
  decodeSpectatorEnvelope,
  SpectatorProtocolError,
  type SpectatorEnvelope,
} from "./spectatorProtocol";

export type ConnectionStatus =
  "connecting" | "connected" | "reconnecting" | "disconnected" | "incompatible";

interface SocketLike {
  onopen: (() => void) | null;
  onmessage: ((event: MessageEvent<string>) => void) | null;
  onclose: (() => void) | null;
  onerror: (() => void) | null;
  send(data: string): void;
  close(): void;
}

type SocketFactory = (url: string) => SocketLike;

interface SpectatorTransportOptions {
  url: string;
  onEnvelope: (envelope: SpectatorEnvelope) => void;
  onStatus: (status: ConnectionStatus, message?: string) => void;
  socketFactory?: SocketFactory;
  reconnectDelayMs?: number;
}

export class SpectatorTransport {
  constructor(private readonly options: SpectatorTransportOptions) {}

  private socket: SocketLike | null = null;
  private reconnectTimer: number | null = null;
  private stopped = true;
  private incompatible = false;

  start(): void {
    if (!this.stopped) return;
    this.stopped = false;
    this.incompatible = false;
    this.connect("connecting");
  }

  retry(): void {
    this.stop();
    this.start();
  }

  stop(): void {
    this.stopped = true;
    if (this.reconnectTimer !== null) {
      window.clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }
    const socket = this.socket;
    this.socket = null;
    socket?.close();
  }

  private connect(status: ConnectionStatus): void {
    this.options.onStatus(status);
    const factory =
      this.options.socketFactory ??
      ((url: string) => new WebSocket(url) as SocketLike);
    const socket = factory(this.options.url);
    this.socket = socket;
    socket.onopen = () => {
      this.options.onStatus("connected");
      socket.send('{"messageType":"sync"}');
    };
    socket.onmessage = (event) => {
      try {
        const envelope = decodeSpectatorEnvelope(JSON.parse(event.data));
        this.options.onEnvelope(envelope);
      } catch (error) {
        this.incompatible = error instanceof SpectatorProtocolError;
        this.options.onStatus(
          "incompatible",
          error instanceof Error ? error.message : "Некорректный snapshot.",
        );
        socket.close();
      }
    };
    socket.onerror = () => {
      if (!this.incompatible) {
        this.options.onStatus("disconnected", "Host недоступен.");
      }
    };
    socket.onclose = () => {
      if (this.socket === socket) this.socket = null;
      if (this.stopped || this.incompatible) return;
      this.options.onStatus("reconnecting", "Переподключаемся к Host…");
      this.reconnectTimer = window.setTimeout(
        () => this.connect("reconnecting"),
        this.options.reconnectDelayMs ?? 1500,
      );
    };
  }
}

export function currentSpectatorWebSocketUrl(): string {
  const protocol = window.location.protocol === "https:" ? "wss:" : "ws:";
  return `${protocol}//${window.location.host}/ws`;
}
