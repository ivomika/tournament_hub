import { describe, expect, it } from "vitest";
import { spectatorReducer, type SpectatorClientState } from "./reducer.ts";
import type { ProjectionReplacedEvent } from "./protocol.ts";
import { projectionFixture } from "./testFixture.ts";

const live: SpectatorClientState = {
  connection: "live",
  projection: projectionFixture,
  lastSequence: 7,
};

function event(sequence: number): ProjectionReplacedEvent {
  return {
    category: "event",
    type: "spectator.projection.replaced",
    protocolVersion: 1,
    eventVersion: 1,
    eventId: `e-${sequence}`,
    tournamentId: "t-1",
    sequence,
    timestamp: "2026-08-30T12:00:00Z",
    payload: {
      projection: { ...projectionFixture, revision: sequence, sequence },
    },
  };
}

describe("Spectator reducer", () => {
  it("игнорирует duplicate/old events", () => {
    expect(spectatorReducer(live, { type: "event", event: event(7) })).toBe(
      live,
    );
  });

  it("применяет только contiguous replacement", () => {
    const next = spectatorReducer(live, { type: "event", event: event(8) });
    expect(next.lastSequence).toBe(8);
    expect(next.connection).toBe("live");
  });

  it("gap переводит last-known projection в stale", () => {
    const next = spectatorReducer(live, { type: "event", event: event(9) });
    expect(next.connection).toBe("stale");
    expect(next.projection).toBe(projectionFixture);
    expect(next.errorCode).toBe("SEQUENCE_GAP");
  });

  it("full snapshot детерминированно восстанавливает sequence", () => {
    const stale = spectatorReducer(live, { type: "event", event: event(9) });
    const restored = spectatorReducer(stale, {
      type: "snapshot",
      projection: { ...projectionFixture, revision: 10, sequence: 10 },
    });
    expect(restored.lastSequence).toBe(10);
    expect(restored.connection).toBe("synchronizing");
  });
});
