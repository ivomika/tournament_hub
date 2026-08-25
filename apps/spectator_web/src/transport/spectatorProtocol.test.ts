import { describe, expect, it } from "vitest";

import roundRobinFixture from "../../../../docs/protocol/fixtures/spectator-round-robin-active-v1.json";
import doubleEliminationFixture from "../../../../docs/protocol/fixtures/spectator-double-elimination-active-v1.json";
import {
  decodeSpectatorEnvelope,
  SpectatorProtocolError,
} from "./spectatorProtocol";

describe("Spectator protocol", () => {
  it("читает общую Round Robin fixture", () => {
    const envelope = decodeSpectatorEnvelope(roundRobinFixture);

    expect(envelope.tournamentId).toBe("fixture-round-robin");
    expect(envelope.payload.format).toBe("roundRobin");
  });

  it("читает общую Double Elimination fixture", () => {
    const envelope = decodeSpectatorEnvelope(doubleEliminationFixture);

    expect(envelope.payload.format).toBe("doubleElimination");
  });

  it("отклоняет несовместимую версию", () => {
    expect(() =>
      decodeSpectatorEnvelope({ ...roundRobinFixture, protocolVersion: 2 }),
    ).toThrow(SpectatorProtocolError);
  });
});
