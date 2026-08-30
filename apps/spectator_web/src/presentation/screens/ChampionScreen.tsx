import type { SpectatorProjection } from "../types.ts";
import { FighterIdentity } from "../components/fighter-identity/FighterIdentity.tsx";
import { StandingsTable } from "../components/standings-table/StandingsTable.tsx";

export function ChampionScreen({
  projection,
}: {
  projection: SpectatorProjection;
}) {
  return (
    <>
      <section className="champion surface" aria-labelledby="champion-title">
        <div>
          <p className="stage-label">Турнир завершён</p>
          <h2 className="champion__title" id="champion-title">
            Чемпион
          </h2>
          <FighterIdentity identity={projection.champion} variant="hero" />
          <p className="champion__summary">
            {projection.tournament.title} · {projection.tournament.format}
          </p>
        </div>
      </section>
      <section className="section" aria-labelledby="final-ranking">
        <h3 className="section__title" id="final-ranking">
          Итоговая таблица
        </h3>
        <StandingsTable standings={projection.standings} />
      </section>
    </>
  );
}
