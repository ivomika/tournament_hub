export const protocolVersion = 1 as const;
export const snapshotVersion = 1 as const;
export const eventVersion = 1 as const;

export type TournamentLifecycle = "distribution" | "running" | "finished";

export interface SpectatorFighterDto {
  fighterId: string;
  displayName: string;
  assetPath: string;
}

export interface SpectatorParticipantDto {
  participantId: string;
  nickname: string;
  isGuest: boolean;
  fighter?: SpectatorFighterDto;
}

export interface SpectatorMatchResultDto {
  kind: "normal" | "technical";
  winnerParticipantId: string;
  loserParticipantId: string;
  winnerScore?: number;
  loserScore?: number;
  reason?: "forfeit" | "withdrawal";
}

export interface SpectatorMatchDto {
  matchId: string;
  round: number;
  order: number;
  stage: string;
  firstTo: number;
  firstParticipantId: string;
  secondParticipantId: string;
  status: "upcoming" | "current" | "finished";
  result?: SpectatorMatchResultDto;
}

export interface SpectatorStandingDto {
  participantId: string;
  placeFrom: number;
  placeTo: number;
}

export interface SpectatorProjectionDto {
  tournamentId: string;
  revision: number;
  sequence: number;
  snapshotVersion: typeof snapshotVersion;
  championParticipantId?: string;
  tournament: {
    title: string;
    formatId: "double-elimination" | "single-elimination" | "round-robin";
    rulesetVersion: 1;
    lifecycle: TournamentLifecycle;
  };
  participants: SpectatorParticipantDto[];
  matches: SpectatorMatchDto[];
  standings: SpectatorStandingDto[];
}

export interface ProjectionReplacedEvent {
  category: "event";
  type: "spectator.projection.replaced";
  protocolVersion: typeof protocolVersion;
  eventVersion: typeof eventVersion;
  eventId: string;
  tournamentId: string;
  sequence: number;
  timestamp: string;
  payload: { projection: SpectatorProjectionDto };
}

export type ParseResult<T> =
  | { ok: true; value: T }
  | { ok: false; code: "INVALID_PAYLOAD" | "INCOMPATIBLE_VERSION" };

export function parseProjection(
  value: unknown,
): ParseResult<SpectatorProjectionDto> {
  if (!isRecord(value)) return invalid();
  if (value.snapshotVersion !== snapshotVersion) return incompatible();
  if (
    !hasOnly(value, [
      "tournamentId",
      "revision",
      "sequence",
      "snapshotVersion",
      "championParticipantId",
      "tournament",
      "participants",
      "matches",
      "standings",
    ]) ||
    !isNonEmptyString(value.tournamentId) ||
    !isPositiveInteger(value.revision) ||
    !isNonNegativeInteger(value.sequence) ||
    (value.championParticipantId !== undefined &&
      !isNonEmptyString(value.championParticipantId)) ||
    !isTournament(value.tournament) ||
    !Array.isArray(value.participants) ||
    !value.participants.every(isParticipant) ||
    !Array.isArray(value.matches) ||
    !value.matches.every(isMatch) ||
    !Array.isArray(value.standings) ||
    !value.standings.every(isStanding)
  ) {
    return invalid();
  }
  const projection = value as unknown as SpectatorProjectionDto;
  if (!isCoherentProjection(projection)) return invalid();
  return { ok: true, value: projection };
}

export function parseProjectionEvent(
  value: unknown,
): ParseResult<ProjectionReplacedEvent> {
  if (!isRecord(value)) return invalid();
  if (
    value.protocolVersion !== protocolVersion ||
    value.eventVersion !== eventVersion
  ) {
    return incompatible();
  }
  if (
    !hasOnly(value, [
      "category",
      "type",
      "protocolVersion",
      "eventVersion",
      "eventId",
      "tournamentId",
      "sequence",
      "timestamp",
      "payload",
    ]) ||
    value.category !== "event" ||
    value.type !== "spectator.projection.replaced" ||
    !isNonEmptyString(value.eventId) ||
    !isNonEmptyString(value.tournamentId) ||
    !isPositiveInteger(value.sequence) ||
    !isNonEmptyString(value.timestamp) ||
    Number.isNaN(Date.parse(value.timestamp)) ||
    !isRecord(value.payload) ||
    !hasOnly(value.payload, ["projection"])
  ) {
    return invalid();
  }
  const projection = parseProjection(value.payload.projection);
  if (!projection.ok) return projection;
  if (
    projection.value.tournamentId !== value.tournamentId ||
    projection.value.sequence !== value.sequence
  ) {
    return invalid();
  }
  return {
    ok: true,
    value: {
      ...(value as unknown as Omit<ProjectionReplacedEvent, "payload">),
      payload: { projection: projection.value },
    },
  };
}

function isTournament(value: unknown): boolean {
  return (
    isRecord(value) &&
    hasOnly(value, ["title", "formatId", "rulesetVersion", "lifecycle"]) &&
    isNonEmptyString(value.title) &&
    includes(
      ["double-elimination", "single-elimination", "round-robin"],
      value.formatId,
    ) &&
    value.rulesetVersion === 1 &&
    includes(["distribution", "running", "finished"], value.lifecycle)
  );
}

function isParticipant(value: unknown): boolean {
  return (
    isRecord(value) &&
    hasOnly(value, ["participantId", "nickname", "isGuest", "fighter"]) &&
    isNonEmptyString(value.participantId) &&
    isNonEmptyString(value.nickname) &&
    typeof value.isGuest === "boolean" &&
    (value.fighter === undefined || isFighter(value.fighter))
  );
}

function isFighter(value: unknown): boolean {
  return (
    isRecord(value) &&
    hasOnly(value, ["fighterId", "displayName", "assetPath"]) &&
    isNonEmptyString(value.fighterId) &&
    isNonEmptyString(value.displayName) &&
    /^assets\/fighters\/[a-z0-9-]+\.png$/.test(String(value.assetPath))
  );
}

function isMatch(value: unknown): boolean {
  return (
    isRecord(value) &&
    hasOnly(value, [
      "matchId",
      "round",
      "order",
      "stage",
      "firstTo",
      "firstParticipantId",
      "secondParticipantId",
      "status",
      "result",
    ]) &&
    isNonEmptyString(value.matchId) &&
    isPositiveInteger(value.round) &&
    isNonNegativeInteger(value.order) &&
    isNonEmptyString(value.stage) &&
    isPositiveInteger(value.firstTo) &&
    isNonEmptyString(value.firstParticipantId) &&
    isNonEmptyString(value.secondParticipantId) &&
    includes(["upcoming", "current", "finished"], value.status) &&
    (value.result === undefined || isResult(value.result))
  );
}

function isResult(value: unknown): boolean {
  if (
    !isRecord(value) ||
    !hasOnly(value, [
      "kind",
      "winnerParticipantId",
      "loserParticipantId",
      "winnerScore",
      "loserScore",
      "reason",
    ]) ||
    !includes(["normal", "technical"], value.kind) ||
    !isNonEmptyString(value.winnerParticipantId) ||
    !isNonEmptyString(value.loserParticipantId)
  ) {
    return false;
  }
  if (value.kind === "normal") {
    return (
      isPositiveInteger(value.winnerScore) &&
      isNonNegativeInteger(value.loserScore) &&
      value.reason === undefined
    );
  }
  return (
    value.winnerScore === undefined &&
    value.loserScore === undefined &&
    includes(["forfeit", "withdrawal"], value.reason)
  );
}

function isStanding(value: unknown): boolean {
  return (
    isRecord(value) &&
    hasOnly(value, ["participantId", "placeFrom", "placeTo"]) &&
    isNonEmptyString(value.participantId) &&
    isPositiveInteger(value.placeFrom) &&
    isPositiveInteger(value.placeTo) &&
    Number(value.placeFrom) <= Number(value.placeTo)
  );
}

function isCoherentProjection(value: SpectatorProjectionDto): boolean {
  const participantIds = value.participants.map(
    (participant) => participant.participantId,
  );
  const knownParticipants = new Set(participantIds);
  if (knownParticipants.size !== participantIds.length) return false;
  const matchIds = value.matches.map((match) => match.matchId);
  if (new Set(matchIds).size !== matchIds.length) return false;
  if (
    value.matches.some(
      (match) =>
        match.firstParticipantId === match.secondParticipantId ||
        !knownParticipants.has(match.firstParticipantId) ||
        !knownParticipants.has(match.secondParticipantId) ||
        (match.result !== undefined &&
          (!knownParticipants.has(match.result.winnerParticipantId) ||
            !knownParticipants.has(match.result.loserParticipantId))),
    ) ||
    value.standings.some(
      (standing) => !knownParticipants.has(standing.participantId),
    ) ||
    (value.championParticipantId !== undefined &&
      !knownParticipants.has(value.championParticipantId))
  ) {
    return false;
  }
  return true;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function hasOnly(
  value: Record<string, unknown>,
  allowed: readonly string[],
): boolean {
  return Object.keys(value).every((key) => allowed.includes(key));
}

function isNonEmptyString(value: unknown): value is string {
  return typeof value === "string" && value.length > 0;
}

function isPositiveInteger(value: unknown): value is number {
  return Number.isInteger(value) && Number(value) > 0;
}

function isNonNegativeInteger(value: unknown): value is number {
  return Number.isInteger(value) && Number(value) >= 0;
}

function includes(values: readonly unknown[], value: unknown): boolean {
  return values.includes(value);
}

function invalid<T>(): ParseResult<T> {
  return { ok: false, code: "INVALID_PAYLOAD" };
}

function incompatible<T>(): ParseResult<T> {
  return { ok: false, code: "INCOMPATIBLE_VERSION" };
}
