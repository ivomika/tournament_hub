import { describe, expect, it, vi } from "vitest";

import fixture from "../../../../docs/protocol/fixtures/spectator-round-robin-active-v1.json";
import type { ConnectionStatus } from "./spectatorTransport";
import { SpectatorTransport } from "./spectatorTransport";

describe("Spectator transport", () => {
  it("запрашивает sync и декодирует snapshot", () => {
    const socket = new _FakeSocket();
    const statuses: ConnectionStatus[] = [];
    const onEnvelope = vi.fn();
    const transport = new SpectatorTransport({
      url: "ws://host/ws",
      socketFactory: () => socket,
      onEnvelope,
      onStatus: (status) => statuses.push(status),
    });

    transport.start();
    socket.open();
    socket.message(JSON.stringify(fixture));

    expect(socket.sent).toContain('{"messageType":"sync"}');
    expect(statuses).toEqual(["connecting", "connected"]);
    expect(onEnvelope).toHaveBeenCalledOnce();
    transport.stop();
  });

  it("показывает несовместимую версию без reconnect", () => {
    vi.useFakeTimers();
    const socket = new _FakeSocket();
    const statuses: ConnectionStatus[] = [];
    const transport = new SpectatorTransport({
      url: "ws://host/ws",
      socketFactory: () => socket,
      onEnvelope: vi.fn(),
      onStatus: (status) => statuses.push(status),
      reconnectDelayMs: 1,
    });

    transport.start();
    socket.open();
    socket.message(JSON.stringify({ ...fixture, protocolVersion: 99 }));
    socket.closed();
    vi.runAllTimers();

    expect(statuses.at(-1)).toBe("incompatible");
    transport.stop();
    vi.useRealTimers();
  });
});

class _FakeSocket {
  onopen: (() => void) | null = null;
  onmessage: ((event: MessageEvent<string>) => void) | null = null;
  onclose: (() => void) | null = null;
  onerror: (() => void) | null = null;
  sent: string[] = [];

  send(data: string): void {
    this.sent.push(data);
  }

  close(): void {}

  open(): void {
    this.onopen?.();
  }

  message(data: string): void {
    this.onmessage?.({ data } as MessageEvent<string>);
  }

  closed(): void {
    this.onclose?.();
  }
}
