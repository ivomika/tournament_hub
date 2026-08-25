import { describe, expect, it } from "vitest";

import fixture from "../../../../docs/protocol/fixtures/spectator-round-robin-active-v1.json";
import { decodeSpectatorEnvelope } from "../transport/spectatorProtocol";
import { SpectatorStore } from "./spectatorStore";

describe("Spectator store", () => {
  it("игнорирует duplicate и stale revision", () => {
    const store = new SpectatorStore();
    const current = decodeSpectatorEnvelope(fixture);

    expect(store.apply(current)).toBe(true);
    expect(store.apply(current)).toBe(false);
    expect(store.apply({ ...current, revision: 2 })).toBe(false);
    expect(store.snapshot?.revision).toBe(3);
  });

  it("заменяет состояние при смене турнира", () => {
    const store = new SpectatorStore();
    const current = decodeSpectatorEnvelope(fixture);
    store.apply(current);

    expect(
      store.apply({ ...current, tournamentId: "new-tournament", revision: 1 }),
    ).toBe(true);
    expect(store.snapshot?.tournamentId).toBe("new-tournament");
  });
});
