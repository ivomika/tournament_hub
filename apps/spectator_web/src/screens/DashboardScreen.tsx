import { ConnectionBadge } from "../components/ConnectionBadge";
import { ParticipantCard } from "../components/ParticipantCard";
import type { SpectatorViewState } from "../state/useSpectator";
import type { SpectatorEnvelope } from "../transport/spectatorProtocol";
import { RoundRobinScreen } from "./RoundRobinScreen";
import { DoubleEliminationBracketScreen } from "./DoubleEliminationBracketScreen";

interface DashboardScreenProps {
  envelope: SpectatorEnvelope;
  connection: SpectatorViewState;
  formatContent?: React.ReactNode;
}

export function DashboardScreen({
  envelope,
  connection,
  formatContent,
}: DashboardScreenProps) {
  const { payload } = envelope;
  const completed =
    payload.format === "roundRobin"
      ? (payload.roundRobin?.matches.filter(
          (match) => match.status === "completed",
        ).length ?? 0)
      : (payload.doubleElimination?.matches.filter(
          (match) =>
            match.status === "completed" || match.status === "automatic",
        ).length ?? 0);
  const total =
    payload.format === "roundRobin"
      ? (payload.roundRobin?.matches.length ?? 0)
      : (payload.doubleElimination?.matches.filter(
          (match) => match.status !== "skipped",
        ).length ?? 0);
  const progress = total === 0 ? 0 : Math.round((completed / total) * 100);

  return (
    <main className="dashboard">
      <header className="dashboard__header">
        <div>
          <p className="eyebrow">TOURNAMENT HUB · SPECTATOR</p>
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

      <section className="dashboard__metrics" aria-label="Прогресс турнира">
        <div className="metric">
          <strong>{payload.participants.length}</strong>
          <span>участников</span>
        </div>
        <div className="metric">
          <strong>
            {completed}/{total}
          </strong>
          <span>матчей завершено</span>
        </div>
        <div className="metric metric--progress">
          <strong>{progress}%</strong>
          <span>прогресс</span>
          <div className="progress-track" aria-hidden="true">
            <i style={{ width: `${progress}%` }} />
          </div>
        </div>
      </section>

      <section className="dashboard__section">
        <div className="section-heading">
          <p className="eyebrow">СОСТАВ</p>
          <h2>Участники и бойцы</h2>
        </div>
        <div className="participant-grid">
          {payload.participants.map((participant) => (
            <ParticipantCard key={participant.id} participant={participant} />
          ))}
        </div>
      </section>

      {formatContent ??
        (payload.roundRobin ? (
          <RoundRobinScreen
            projection={payload.roundRobin}
            participants={payload.participants}
          />
        ) : payload.doubleElimination ? (
          <DoubleEliminationBracketScreen
            projection={payload.doubleElimination}
            participants={payload.participants}
          />
        ) : null)}
    </main>
  );
}
