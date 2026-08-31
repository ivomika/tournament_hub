import type { MatchModel, TournamentFormatId } from "../../types.ts";

export interface BracketRoundModel {
  id: string;
  label: string;
  matches: readonly MatchModel[];
}

export interface BracketLaneModel {
  id: string;
  label: string;
  kind: "winners" | "losers" | "finals" | "main" | "round-robin";
  rounds: readonly BracketRoundModel[];
}

export function buildBracketLanes(
  formatId: TournamentFormatId,
  matches: readonly MatchModel[],
): readonly BracketLaneModel[] {
  switch (formatId) {
    case "double-elimination":
      return [
        lane("winners", "Верхняя сетка", "winners", matches),
        lane("losers", "Нижняя сетка", "losers", matches),
        lane(
          "finals",
          "Гранд-финал и сброс",
          "finals",
          matches.filter(
            (match) =>
              match.stageId === "finalMatch" ||
              match.stageId === "bracketReset",
          ),
        ),
      ].filter((item) => item.rounds.length > 0);
    case "single-elimination":
      return [lane("main", "Раунды Single Elimination", "main", matches)];
    case "round-robin":
      return [
        lane("round-robin", "Раунды Round Robin", "round-robin", matches),
      ];
  }
}

function lane(
  id: string,
  label: string,
  kind: BracketLaneModel["kind"],
  matches: readonly MatchModel[],
): BracketLaneModel {
  const laneMatches =
    kind === "winners" || kind === "losers"
      ? matches.filter((match) => match.stageId === kind)
      : matches;
  const roundNumbers = [...new Set(laneMatches.map((match) => match.round))];
  return {
    id,
    label,
    kind,
    rounds: roundNumbers.map((round) => ({
      id: `${id}-${round}`,
      label: `Раунд ${round}`,
      matches: laneMatches
        .filter((match) => match.round === round)
        .toSorted((first, second) => first.order - second.order),
    })),
  };
}
