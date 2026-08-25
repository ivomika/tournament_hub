import { ConnectionBadge } from "../components/ConnectionBadge";
import { ParticipantCard } from "../components/ParticipantCard";
import type { SpectatorViewState } from "../state/useSpectator";
import type {
  ParticipantView,
  SpectatorEnvelope,
} from "../transport/spectatorProtocol";
import { DoubleEliminationBracketScreen } from "./DoubleEliminationBracketScreen";
import { RoundRobinScreen } from "./RoundRobinScreen";

interface FinalScreenProps {
  envelope: SpectatorEnvelope;
  connection: SpectatorViewState;
}

export function FinalScreen({ envelope, connection }: FinalScreenProps) {
  const { payload } = envelope;
  const participantById = new Map(
    payload.participants.map((participant) => [participant.id, participant]),
  );
  const champion = payload.championId
    ? participantById.get(payload.championId)
    : undefined;

  return (
    <main className="dashboard final-screen">
      <header className="dashboard__header final-screen__header">
        <div>
          <p className="eyebrow">ТУРНИР ЗАВЕРШЁН</p>
          <h1>{payload.name}</h1>
          <p className="dashboard__format">
            {payload.format === "roundRobin"
              ? "Round Robin"
              : "Double Elimination"}
          </p>
        </div>
        <ConnectionBadge
          status={connection.status}
          revision={envelope.revision}
        />
      </header>

      <section className="champion-hero">
        <div className="champion-hero__copy">
          <p className="eyebrow">ЧЕМПИОН</p>
          {champion ? (
            <>
              <h2>{champion.nickname}</h2>
              <p>{champion.fighter.displayName}</p>
            </>
          ) : (
            <h2>Победитель определяется</h2>
          )}
        </div>
        {champion && (
          <img
            className="champion-hero__avatar"
            src={champion.fighter.avatarUrl}
            alt={champion.fighter.displayName}
          />
        )}
      </section>

      <Placements
        placementIds={payload.placements}
        participantById={participantById}
        championId={payload.championId}
      />

      {payload.roundRobin ? (
        <RoundRobinScreen
          projection={payload.roundRobin}
          participants={payload.participants}
        />
      ) : payload.doubleElimination ? (
        <DoubleEliminationBracketScreen
          projection={payload.doubleElimination}
          participants={payload.participants}
        />
      ) : null}
    </main>
  );
}

interface PlacementsProps {
  placementIds: string[];
  participantById: Map<string, ParticipantView>;
  championId: string | null;
}

function Placements({
  placementIds,
  participantById,
  championId,
}: PlacementsProps) {
  return (
    <section className="dashboard__section">
      <div className="section-heading">
        <p className="eyebrow">ИТОГИ</p>
        <h2>Места участников</h2>
      </div>
      <div className="placements-list">
        {placementIds.map((participantId, index) => {
          const participant = participantById.get(participantId);
          if (!participant) return null;
          return (
            <div className="placements-list__row" key={participantId}>
              <strong>#{index + 1}</strong>
              <ParticipantCard
                participant={participant}
                compact
                highlighted={participantId === championId}
              />
            </div>
          );
        })}
      </div>
    </section>
  );
}
