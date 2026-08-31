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

afterEach(() => {
  vi.restoreAllMocks();
  vi.unstubAllGlobals();
});

describe("Spectator client", () => {
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
    const socket = new FakeSocket();
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
      .mockResolvedValue(new Response(null, { status: 503 }));
    const client = new SpectatorClient({
      fetcher,
      socketFactory: () => socket as unknown as WebSocket,
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
    socket.close();
    await vi.advanceTimersByTimeAsync(1);

    expect(client.current.connection).toBe("waiting");
    expect(client.current.projection).toBeUndefined();
    expect(client.current.lastSequence).toBe(0);
    client.stop();
    vi.useRealTimers();
  });
});
