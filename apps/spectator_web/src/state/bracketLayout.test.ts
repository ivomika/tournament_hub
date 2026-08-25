import { describe, expect, it } from "vitest";

import type { EliminationMatchView } from "../transport/spectatorProtocol";
import { createBracketLayout } from "./bracketLayout";

describe("Canonical Double Elimination layout", () => {
  it("размещает winners сверху, losers снизу и финал справа", () => {
    const matches = [
      match("w1", "winners", 1, 0),
      match("w2", "winners", 1, 1),
      match("w3", "winners", 2, 0, "w1", "w2"),
      match("l1", "losers", 1, 0, "w1", "w2", "loser"),
      match("gf", "grandFinal", 1, 0, "w3", "l1"),
      match("reset", "grandFinalReset", 1, 0, "gf", "gf"),
    ];

    const layout = createBracketLayout(matches);
    const winnersY = layout.nodes.find((node) => node.match.id === "w1")!.y;
    const losersY = layout.nodes.find((node) => node.match.id === "l1")!.y;
    const winnerFinalX = layout.nodes.find((node) => node.match.id === "w3")!.x;
    const grandFinalX = layout.nodes.find((node) => node.match.id === "gf")!.x;

    expect(winnersY).toBeLessThan(layout.winnersHeight);
    expect(losersY).toBeGreaterThan(layout.winnersHeight);
    expect(grandFinalX).toBeGreaterThan(winnerFinalX);
    expect(layout.links.length).toBeGreaterThanOrEqual(4);
  });
});

function match(
  id: string,
  stage: EliminationMatchView["stage"],
  round: number,
  position: number,
  firstMatchId: string | null = null,
  secondMatchId: string | null = null,
  sourceType: "winner" | "loser" = "winner",
): EliminationMatchView {
  return {
    id,
    stage,
    round,
    position,
    firstSource: {
      type: firstMatchId ? sourceType : "seed",
      seedIndex: firstMatchId ? null : position * 2,
      matchId: firstMatchId,
    },
    secondSource: {
      type: secondMatchId ? sourceType : "seed",
      seedIndex: secondMatchId ? null : position * 2 + 1,
      matchId: secondMatchId,
    },
    firstParticipantId: null,
    secondParticipantId: null,
    status: "waiting",
    winnerId: null,
  };
}
