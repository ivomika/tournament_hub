import type { EliminationMatchView } from "../transport/spectatorProtocol";

export interface BracketNodeLayout {
  match: EliminationMatchView;
  x: number;
  y: number;
}

export interface BracketLinkLayout {
  id: string;
  sourceType: "winner" | "loser";
  path: string;
}

export interface BracketLayout {
  width: number;
  height: number;
  winnersHeight: number;
  nodes: BracketNodeLayout[];
  links: BracketLinkLayout[];
}

const cardWidth = 240;
const cardHeight = 116;
const columnStep = 328;
const regionGap = 150;

export function createBracketLayout(
  matches: EliminationMatchView[],
): BracketLayout {
  const winners = matches.filter((match) => match.stage === "winners");
  const losers = matches.filter((match) => match.stage === "losers");
  const winnerRounds = groupByRound(winners);
  const loserRounds = groupByRound(losers);
  const winnersHeight = regionHeight(winnerRounds);
  const losersHeight = regionHeight(loserRounds);
  const loserStart = winnersHeight + regionGap;
  const maxMainRound = Math.max(
    1,
    ...winnerRounds.keys(),
    ...loserRounds.keys(),
  );
  const finalX = 48 + maxMainRound * columnStep;
  const nodes: BracketNodeLayout[] = [
    ...layoutRegion(winnerRounds, 48, 72, winnersHeight - 100),
    ...layoutRegion(loserRounds, 48, loserStart + 72, losersHeight - 100),
  ];
  for (const match of matches.filter(
    (item) => item.stage === "grandFinal" || item.stage === "grandFinalReset",
  )) {
    nodes.push({
      match,
      x: finalX + (match.stage === "grandFinalReset" ? columnStep : 0),
      y: Math.max(80, winnersHeight - cardHeight) / 2,
    });
  }
  const nodeById = new Map(nodes.map((node) => [node.match.id, node]));
  const links: BracketLinkLayout[] = [];
  for (const target of nodes) {
    for (const [slotIndex, source] of [
      target.match.firstSource,
      target.match.secondSource,
    ].entries()) {
      if (!source.matchId || source.type === "seed") continue;
      const origin = nodeById.get(source.matchId);
      if (!origin) continue;
      const startX = origin.x + cardWidth;
      const startY = origin.y + cardHeight / 2;
      const endX = target.x;
      const endY = target.y + (slotIndex === 0 ? 38 : 78);
      const middleX = startX + Math.max(28, (endX - startX) / 2);
      links.push({
        id: `${origin.match.id}-${target.match.id}-${slotIndex}`,
        sourceType: source.type,
        path: `M ${startX} ${startY} H ${middleX} V ${endY} H ${endX}`,
      });
    }
  }
  const width = Math.max(900, ...nodes.map((node) => node.x + cardWidth + 72));
  return {
    width,
    height: loserStart + losersHeight + 80,
    winnersHeight,
    nodes,
    links,
  };
}

function groupByRound(matches: EliminationMatchView[]) {
  const rounds = new Map<number, EliminationMatchView[]>();
  for (const match of matches) {
    const items = rounds.get(match.round) ?? [];
    items.push(match);
    rounds.set(match.round, items);
  }
  for (const items of rounds.values()) {
    items.sort((left, right) => left.position - right.position);
  }
  return rounds;
}

function regionHeight(rounds: Map<number, EliminationMatchView[]>) {
  const count = Math.max(
    1,
    ...[...rounds.values()].map((items) => items.length),
  );
  return Math.max(330, count * 164 + 80);
}

function layoutRegion(
  rounds: Map<number, EliminationMatchView[]>,
  startX: number,
  startY: number,
  height: number,
) {
  const nodes: BracketNodeLayout[] = [];
  for (const [round, matches] of rounds) {
    const step = height / Math.max(1, matches.length);
    for (const [index, match] of matches.entries()) {
      nodes.push({
        match,
        x: startX + (round - 1) * columnStep,
        y: startY + step * (index + 0.5) - cardHeight / 2,
      });
    }
  }
  return nodes;
}
