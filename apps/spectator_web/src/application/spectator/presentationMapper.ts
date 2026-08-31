import type {
  FighterIdentityModel,
  MatchModel,
  SpectatorProjection,
  StandingModel,
} from "../../presentation/types.ts";
import type {
  SpectatorMatchDto,
  SpectatorParticipantDto,
  SpectatorProjectionDto,
} from "./protocol.ts";
import type { SpectatorClientState } from "./reducer.ts";

export function toPresentationProjection(
  state: SpectatorClientState,
): SpectatorProjection | undefined {
  const source = state.projection;
  if (source === undefined) return undefined;
  const identities = new Map(
    source.participants.map((participant) => [
      participant.participantId,
      toIdentity(participant),
    ]),
  );
  const matches = source.matches.map((match) => toMatch(match, identities));
  const completed = matches.filter((match) => match.state === "previous");
  const current = matches.find((match) => match.state === "current");
  const upcoming = matches.filter((match) => match.state === "next");
  const finishedCount = source.matches.filter(
    (match) => match.status === "finished",
  ).length;
  const standings: StandingModel[] = source.standings.map((standing) => ({
    participantId: standing.participantId,
    placeLabel:
      standing.placeFrom === standing.placeTo
        ? String(standing.placeFrom)
        : `${standing.placeFrom}–${standing.placeTo}`,
    identity: requireIdentity(identities, standing.participantId),
  }));
  return {
    connection: {
      state: state.connection,
      label: connectionLabel(state.connection),
      sequence: state.lastSequence,
    },
    tournament: {
      title: source.tournament.title,
      formatId: source.tournament.formatId,
      format: formatLabel(source.tournament.formatId),
      progress:
        source.matches.length === 0
          ? `${source.participants.length} участников`
          : `Матч ${finishedCount} из ${source.matches.length}`,
      lifecycle: source.tournament.lifecycle,
    },
    participants: [...identities.values()],
    timeline: { completed, current, upcoming },
    bracket: matches,
    standings,
    champion:
      source.championParticipantId === undefined
        ? undefined
        : requireIdentity(identities, source.championParticipantId),
  };
}

function toIdentity(
  participant: SpectatorParticipantDto,
): FighterIdentityModel {
  return {
    participantId: participant.participantId,
    nickname: participant.nickname,
    fighterName: participant.fighter?.displayName ?? "Персонаж не назначен",
    fighterAssetPath:
      participant.fighter === undefined
        ? undefined
        : `/${participant.fighter.assetPath.replace(/^assets\//, "")}`,
    guest: participant.isGuest,
  };
}

function toMatch(
  match: SpectatorMatchDto,
  identities: ReadonlyMap<string, FighterIdentityModel>,
): MatchModel {
  const first = requireIdentity(identities, match.firstParticipantId);
  const second = requireIdentity(identities, match.secondParticipantId);
  const result = match.result;
  const firstWon = result?.winnerParticipantId === match.firstParticipantId;
  const score =
    result?.kind === "normal"
      ? ([
          firstWon ? result.winnerScore! : result.loserScore!,
          firstWon ? result.loserScore! : result.winnerScore!,
        ] as const)
      : undefined;
  return {
    id: match.matchId,
    round: match.round,
    order: match.order,
    stageId: match.stage,
    stage: stageLabel(match.stage),
    label: `Раунд ${match.round} · матч ${match.order + 1} · FT${match.firstTo}`,
    first,
    second,
    score,
    resultLabel:
      result?.kind === "technical"
        ? result.reason === "withdrawal"
          ? "Техническая победа: снятие"
          : "Техническая победа"
        : score === undefined
          ? undefined
          : `${score[0]}:${score[1]}`,
    winnerId: result?.winnerParticipantId,
    state:
      match.status === "finished"
        ? "previous"
        : match.status === "current"
          ? "current"
          : "next",
  };
}

function requireIdentity(
  identities: ReadonlyMap<string, FighterIdentityModel>,
  participantId: string,
): FighterIdentityModel {
  const identity = identities.get(participantId);
  if (identity === undefined) throw new Error("INVALID_PARTICIPANT_REFERENCE");
  return identity;
}

function connectionLabel(state: SpectatorClientState["connection"]): string {
  switch (state) {
    case "waiting":
      return "Ожидание турнира";
    case "connecting":
      return "Подключение";
    case "synchronizing":
      return "Синхронизация";
    case "live":
      return "Прямой эфир";
    case "stale":
      return "Данные устарели";
    case "reconnecting":
      return "Переподключение";
    case "incompatible":
      return "Несовместимая версия";
    case "error":
      return "Ошибка подключения";
  }
}

function formatLabel(
  format: SpectatorProjectionDto["tournament"]["formatId"],
): string {
  switch (format) {
    case "double-elimination":
      return "Double Elimination";
    case "single-elimination":
      return "Single Elimination";
    case "round-robin":
      return "Round Robin";
  }
}

function stageLabel(stage: string): string {
  switch (stage) {
    case "winners":
      return "Верхняя сетка";
    case "losers":
      return "Нижняя сетка";
    case "finalMatch":
      return "Гранд-финал";
    case "bracketReset":
      return "Сброс сетки";
    case "roundRobin":
      return "Круговой этап";
    default:
      return "Основная сетка";
  }
}
