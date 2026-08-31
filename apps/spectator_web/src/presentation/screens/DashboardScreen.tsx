import type { SpectatorProjection } from "../types.ts";
import { MatchupHero } from "../components/matchup-hero/MatchupHero.tsx";
import { TimelineCard } from "../components/timeline-card/TimelineCard.tsx";
import { AssignmentGrid } from "../components/assignment-grid/AssignmentGrid.tsx";

export function DashboardScreen({
  projection,
}: {
  projection: SpectatorProjection;
}) {
  const isLive = projection.connection.state === "live";
  const { completed, current, upcoming } = projection.timeline;
  if (current === undefined) {
    return (
      <>
        <header className="screen-heading">
          <div>
            <p className="stage-label">Раздача персонажей</p>
            <h2>Участники готовы к турниру</h2>
          </div>
          <p className="screen-heading__context">
            {projection.tournament.format}
          </p>
        </header>
        <AssignmentGrid participants={projection.participants} />
      </>
    );
  }
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
      <div className="dashboard-lanes" aria-label="Хронология матчей">
        <section className="match-lane" aria-labelledby="completed-lane-title">
          <h3 className="match-lane__title" id="completed-lane-title">
            Завершённые
          </h3>
          <div className="match-lane__list">
            {completed.length === 0 ? (
              <p className="match-lane__empty">Завершённых матчей пока нет.</p>
            ) : (
              completed.map((match) => (
                <TimelineCard key={match.id} match={match} />
              ))
            )}
          </div>
        </section>
        <section
          className="match-lane match-lane--current"
          aria-labelledby="current-lane-title"
        >
          <h3 className="match-lane__title" id="current-lane-title">
            Сейчас
          </h3>
          <MatchupHero match={current} />
        </section>
        <section className="match-lane" aria-labelledby="upcoming-lane-title">
          <h3 className="match-lane__title" id="upcoming-lane-title">
            Будущие
          </h3>
          <div className="match-lane__list">
            {upcoming.length === 0 ? (
              <p className="match-lane__empty">Будущих матчей пока нет.</p>
            ) : (
              upcoming.map((match) => (
                <TimelineCard key={match.id} match={match} />
              ))
            )}
          </div>
        </section>
      </div>
    </>
  );
}
