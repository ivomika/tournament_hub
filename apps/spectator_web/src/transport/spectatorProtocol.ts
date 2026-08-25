export const SPECTATOR_PROTOCOL_VERSION = 1 as const;

export type TournamentFormat = "roundRobin" | "doubleElimination";
export type TournamentState = "active" | "finished";

export interface FighterView {
  id: string;
  displayName: string;
  avatarUrl: string;
}

export interface ParticipantView {
  id: string;
  nickname: string;
  fighter: FighterView;
}

export interface StandingView {
  participantId: string;
  position: number;
  matchesPlayed: number;
  wins: number;
  losses: number;
  gamesWon: number;
  gamesLost: number;
  points: number;
}

export interface RoundRobinMatchView {
  id: string;
  round: number;
  firstParticipantId: string;
  secondParticipantId: string;
  status: "planned" | "inProgress" | "completed";
  firstScore: number;
  secondScore: number;
  winnerId: string | null;
}

export interface RoundView {
  number: number;
  byeParticipantId: string | null;
  matchIds: string[];
}

export interface RoundRobinView {
  rounds: RoundView[];
  matches: RoundRobinMatchView[];
  standings: StandingView[];
}

export interface BracketSourceView {
  type: "seed" | "winner" | "loser";
  seedIndex: number | null;
  matchId: string | null;
}

export interface EliminationMatchView {
  id: string;
  stage: "winners" | "losers" | "grandFinal" | "grandFinalReset";
  round: number;
  position: number;
  firstSource: BracketSourceView;
  secondSource: BracketSourceView;
  firstParticipantId: string | null;
  secondParticipantId: string | null;
  status: "waiting" | "ready" | "completed" | "automatic" | "skipped";
  winnerId: string | null;
}

export interface PlacementMatchView {
  id: string;
  firstParticipantId: string;
  secondParticipantId: string;
  winnerId: string | null;
}

export interface PlacementReplayView {
  groupId: string;
  replayNumber: number;
  participantIds: string[];
  matches: PlacementMatchView[];
}

export interface DoubleEliminationView {
  seededSlots: Array<string | null>;
  matches: EliminationMatchView[];
  placementReplays: PlacementReplayView[];
}

export interface SpectatorPayload {
  state: TournamentState;
  format: TournamentFormat;
  name: string;
  participants: ParticipantView[];
  roundRobin?: RoundRobinView;
  doubleElimination?: DoubleEliminationView;
  championId: string | null;
  placements: string[];
}

export interface SpectatorEnvelope {
  protocolVersion: typeof SPECTATOR_PROTOCOL_VERSION;
  messageType: "snapshot";
  tournamentId: string;
  revision: number;
  payload: SpectatorPayload;
}

export class SpectatorProtocolError extends Error {}

export function decodeSpectatorEnvelope(value: unknown): SpectatorEnvelope {
  if (!isRecord(value)) {
    throw new SpectatorProtocolError(
      "Spectator envelope должен быть объектом.",
    );
  }
  if (value.protocolVersion !== SPECTATOR_PROTOCOL_VERSION) {
    throw new SpectatorProtocolError("Версия spectator protocol несовместима.");
  }
  if (
    value.messageType !== "snapshot" ||
    typeof value.tournamentId !== "string" ||
    !Number.isInteger(value.revision) ||
    (value.revision as number) < 1 ||
    !isRecord(value.payload)
  ) {
    throw new SpectatorProtocolError("Spectator envelope повреждён.");
  }
  const payload = value.payload;
  const format = payload.format;
  if (
    (payload.state !== "active" && payload.state !== "finished") ||
    (format !== "roundRobin" && format !== "doubleElimination") ||
    typeof payload.name !== "string" ||
    !Array.isArray(payload.participants) ||
    (format === "roundRobin" && !isRecord(payload.roundRobin)) ||
    (format === "doubleElimination" && !isRecord(payload.doubleElimination))
  ) {
    throw new SpectatorProtocolError("Spectator payload повреждён.");
  }
  return value as unknown as SpectatorEnvelope;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}
