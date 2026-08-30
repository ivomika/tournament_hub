import type { SpectatorProjection } from "../types.ts";
import { MatchupHero } from "../components/matchup-hero/MatchupHero.tsx";
import { TimelineCard } from "../components/timeline-card/TimelineCard.tsx";

export function DashboardScreen({
  projection,
}: {
  projection: SpectatorProjection;
}) {
  const isLive = projection.connection.state === "live";
  return (
    <>
      {!isLive && (
        <aside className="connection-banner" role="status">
          <strong>Соединение восстанавливается.</strong>
          <span>Показаны последние подтверждённые данные.</span>
        </aside>
      )}
      <header className="screen-heading">
        <div>
          <p className="stage-label">Сейчас в турнире</p>
          <h2>Главный матч</h2>
        </div>
        <p className="screen-heading__context">
          {projection.tournament.format}
          <br />
          {projection.tournament.progress}
        </p>
      </header>
      <div className="dashboard-grid">
        <MatchupHero match={projection.current} />
        <aside className="timeline" aria-label="Предыдущий и следующий матчи">
          <TimelineCard match={projection.previous} />
          <TimelineCard match={projection.next} />
        </aside>
      </div>
    </>
  );
}
