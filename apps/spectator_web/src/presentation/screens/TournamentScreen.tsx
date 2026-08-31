import type { SpectatorProjection } from "../types.ts";
import { BracketView } from "../components/bracket-view/BracketView.tsx";
import { StandingsTable } from "../components/standings-table/StandingsTable.tsx";

export function TournamentScreen({
  projection,
}: {
  projection: SpectatorProjection;
}) {
  return (
    <>
      <header className="screen-heading">
        <div>
          <p className="stage-label">Структура турнира</p>
          <h2>{projection.tournament.format}</h2>
        </div>
        <p className="screen-heading__context">
          {projection.tournament.progress}
        </p>
      </header>
      <section aria-labelledby="bracket-heading">
        <h3 className="section__title" id="bracket-heading">
          Сетка
        </h3>
        <BracketView
          formatId={projection.tournament.formatId}
          matches={projection.bracket}
        />
      </section>
      <section className="section" aria-labelledby="standings-heading">
        <h3 className="section__title" id="standings-heading">
          Текущая таблица
        </h3>
        <StandingsTable standings={projection.standings} />
      </section>
    </>
  );
}
