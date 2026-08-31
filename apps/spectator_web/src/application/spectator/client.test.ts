import { afterEach, describe, expect, it, vi } from "vitest";
import { SpectatorClient } from "./client.ts";
import { projectionFixture } from "./testFixture.ts";

class FakeSocket extends EventTarget {
  readonly sent: string[] = [];

  send(value: string): void {
    this.sent.push(value);
  }

  close(): void {
    this.dispatchEvent(new CloseEvent("close"));
  }

  open(): void {
    this.dispatchEvent(new Event("open"));
  }

  message(value: unknown): void {
    this.dispatchEvent(
      new MessageEvent("message", { data: JSON.stringify(value) }),
    );
  }
}

function deferred<T>() {
  let resolve!: (value: T) => void;
  const promise = new Promise<T>((complete) => {
    resolve = complete;
  });
  return { promise, resolve };
}

afterEach(() => {
  vi.restoreAllMocks();
  vi.unstubAllGlobals();
});

describe("Spectator client", () => {
  it("сохраняет waiting, пока первый snapshot ещё загружается", async () => {
    const snapshot = deferred<Response>();
    const states: string[] = [];
    const client = new SpectatorClient({
      fetcher: vi.fn(() => snapshot.promise),
      socketFactory: () => new FakeSocket() as unknown as WebSocket,
      location: {
        origin: "http://host.test:8080",
        protocol: "http:",
        host: "host.test:8080",
      },
      retryDelayMs: 60_000,
    });
    client.subscribe((state) => states.push(state.connection));

    client.start();
    await Promise.resolve();

    expect(client.current.connection).toBe("waiting");
    expect(states).toEqual(["waiting"]);

    snapshot.resolve(new Response(null, { status: 503 }));
    await vi.waitFor(() => expect(client.current.connection).toBe("waiting"));
    expect(client.current.projection).toBeUndefined();
    client.stop();
  });

  it("вызывает browser fetch с корректным global receiver", async () => {
    vi.stubGlobal("fetch", function (this: unknown) {
      expect(this).toBe(globalThis);
      return Promise.resolve(new Response(null, { status: 503 }));
    });
    const client = new SpectatorClient({
      socketFactory: () => new FakeSocket() as unknown as WebSocket,
      location: {
        origin: "http://host.test:8080",
        protocol: "http:",
        host: "host.test:8080",
      },
      retryDelayMs: 60_000,
    });

    client.start();
    await vi.waitFor(() => expect(client.current.connection).toBe("waiting"));
    client.stop();
  });

  it("получает snapshot, отправляет handshake и применяет live event", async () => {
    const socket = new FakeSocket();
    const client = new SpectatorClient({
      fetcher: vi.fn(async () => Response.json(projectionFixture)),
      socketFactory: () => socket as unknown as WebSocket,
      location: {
        origin: "http://host.test:8080",
        protocol: "http:",
        host: "host.test:8080",
      },
      retryDelayMs: 60_000,
    });
    client.start();
    await vi.waitFor(() => expect(client.current.lastSequence).toBe(7));

    socket.open();
    expect(JSON.parse(socket.sent[0]!)).toMatchObject({
      category: "handshake",
      payload: {
        clientType: "spectator",
        tournamentId: "t-1",
        lastSequence: 7,
      },
    });
    socket.message({
      category: "control",
      type: "sync.completed",
      protocolVersion: 1,
      payload: { mode: "events", sequence: 7 },
    });
    expect(client.current.connection).toBe("live");
    socket.message({
      category: "event",
      type: "spectator.projection.replaced",
      protocolVersion: 1,
      eventVersion: 1,
      eventId: "e-8",
      tournamentId: "t-1",
      sequence: 8,
      timestamp: "2026-08-30T12:00:00Z",
      payload: {
        projection: { ...projectionFixture, revision: 8, sequence: 8 },
      },
    });
    expect(client.current.lastSequence).toBe(8);
    client.stop();
  });

  it("503 остаётся waiting и не теряет control над retry", async () => {
    vi.useFakeTimers();
    const client = new SpectatorClient({
      fetcher: vi.fn(async () => new Response(null, { status: 503 })),
      socketFactory: () => new FakeSocket() as unknown as WebSocket,
      location: {
        origin: "http://host.test:8080",
        protocol: "http:",
        host: "host.test:8080",
      },
      retryDelayMs: 1_000,
    });
    client.start();
    await vi.advanceTimersByTimeAsync(0);
    expect(client.current.connection).toBe("waiting");
    client.stop();
    vi.useRealTimers();
  });

  it("после очистки terminal projection возвращается в waiting", async () => {
    vi.useFakeTimers();
    const clearedSnapshot = deferred<Response>();
    const fetcher = vi
      .fn<typeof fetch>()
      .mockResolvedValueOnce(
        Response.json({
          ...projectionFixture,
          tournament: {
            ...projectionFixture.tournament,
            lifecycle: "finished",
          },
        }),
      )
      .mockImplementation(() => clearedSnapshot.promise);
    const client = new SpectatorClient({
      fetcher,
      socketFactory: () => new FakeSocket() as unknown as WebSocket,
      location: {
        origin: "http://host.test:8080",
        protocol: "http:",
        host: "host.test:8080",
      },
      retryDelayMs: 1,
    });

    client.start();
    await vi.advanceTimersByTimeAsync(0);
    expect(client.current.projection?.tournament.lifecycle).toBe("finished");
    await vi.advanceTimersByTimeAsync(1);
    expect(fetcher).toHaveBeenCalledTimes(2);
    expect(client.current.projection?.tournament.lifecycle).toBe("finished");

    clearedSnapshot.resolve(new Response(null, { status: 503 }));
    await vi.advanceTimersByTimeAsync(0);

    expect(client.current.connection).toBe("waiting");
    expect(client.current.projection).toBeUndefined();
    expect(client.current.lastSequence).toBe(0);
    client.stop();
    vi.useRealTimers();
  });

  it("не удаляет running projection во время штатного reconnect", async () => {
    const reconnectSnapshot = deferred<Response>();
    const fetcher = vi
      .fn<typeof fetch>()
      .mockResolvedValueOnce(Response.json(projectionFixture))
      .mockImplementationOnce(() => reconnectSnapshot.promise);
    const client = new SpectatorClient({
      fetcher,
      socketFactory: () => new FakeSocket() as unknown as WebSocket,
      location: {
        origin: "http://host.test:8080",
        protocol: "http:",
        host: "host.test:8080",
      },
      retryDelayMs: 60_000,
    });

    client.start();
    await vi.waitFor(() => expect(client.current.projection).toBeDefined());
    const runningProjection = client.current.projection;

    client.retry();

    expect(client.current.connection).toBe("reconnecting");
    expect(client.current.projection).toBe(runningProjection);

    reconnectSnapshot.resolve(Response.json(projectionFixture));
    await vi.waitFor(() =>
      expect(client.current.connection).toBe("synchronizing"),
    );
    expect(client.current.projection).toBeDefined();
    client.stop();
  });

  it("не возвращает stale матч из запоздавшего snapshot после waiting", async () => {
    const obsoleteSnapshot = deferred<Response>();
    const fetcher = vi
      .fn<typeof fetch>()
      .mockImplementationOnce(() => obsoleteSnapshot.promise)
      .mockResolvedValueOnce(new Response(null, { status: 503 }));
    const client = new SpectatorClient({
      fetcher,
      socketFactory: () => new FakeSocket() as unknown as WebSocket,
      location: {
        origin: "http://host.test:8080",
        protocol: "http:",
        host: "host.test:8080",
      },
      retryDelayMs: 60_000,
    });

    client.start();
    client.retry();
    await vi.waitFor(() => expect(fetcher).toHaveBeenCalledTimes(2));
    expect(client.current.connection).toBe("waiting");

    obsoleteSnapshot.resolve(
      Response.json({
        ...projectionFixture,
        tournament: {
          ...projectionFixture.tournament,
          lifecycle: "finished",
        },
      }),
    );
    await Promise.resolve();
    await Promise.resolve();

    expect(client.current.connection).toBe("waiting");
    expect(client.current.projection).toBeUndefined();
    client.stop();
  });
});
