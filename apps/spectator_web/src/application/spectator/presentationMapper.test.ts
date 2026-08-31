import { describe, expect, it } from "vitest";
import { toPresentationProjection } from "./presentationMapper.ts";
import { projectionFixture } from "./testFixture.ts";

describe("spectator presentation mapper", () => {
  it("сохраняет Host order и раскладывает матчи по временным lanes", () => {
    const [current] = projectionFixture.matches;
    const projection = toPresentationProjection({
      connection: "live",
      lastSequence: 12,
      projection: {
        ...projectionFixture,
        sequence: 12,
        matches: [
          {
            ...current!,
            matchId: "completed-1",
            status: "finished",
            result: {
              kind: "normal",
              winnerParticipantId: "participant-1",
              loserParticipantId: "participant-2",
              winnerScore: 2,
              loserScore: 1,
            },
          },
          current!,
          { ...current!, matchId: "upcoming-1", status: "upcoming" },
          { ...current!, matchId: "upcoming-2", status: "upcoming" },
        ],
      },
    })!;

    expect(projection.timeline.completed.map((match) => match.id)).toEqual([
      "completed-1",
    ]);
    expect(projection.timeline.current?.id).toBe(current!.matchId);
    expect(projection.timeline.upcoming.map((match) => match.id)).toEqual([
      "upcoming-1",
      "upcoming-2",
    ]);
    expect(projection.timeline.completed[0]?.score).toEqual([2, 1]);
  });
});
