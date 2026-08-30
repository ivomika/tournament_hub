import type { MatchModel } from "../../types.ts";
import { FighterIdentity } from "../fighter-identity/FighterIdentity.tsx";

function BracketMatch({ match }: { match: MatchModel }) {
  return (
    <article
      className="bracket-match surface"
      data-state={match.state}
      aria-label={`${match.label}: ${match.first.fighterName}, ${match.first.nickname}, против ${match.second.fighterName}, ${match.second.nickname}`}
    >
      <p className="stage-label">{match.label}</p>
      <div className="bracket-match__row">
        <FighterIdentity identity={match.first} />
        <strong>{match.score?.[0] ?? "—"}</strong>
      </div>
      <div className="bracket-match__row">
        <FighterIdentity identity={match.second} />
        <strong>{match.score?.[1] ?? "—"}</strong>
      </div>
    </article>
  );
}

export function BracketView({ matches }: { matches: readonly MatchModel[] }) {
  const upper = matches.filter((match) => match.stage === "Верхняя сетка");
  const lower = matches.filter((match) => match.stage === "Нижняя сетка");
  return (
    <div className="bracket" aria-label="Турнирная сетка Double Elimination">
      <section className="bracket__column">
        <h3 className="bracket__title">Верхняя сетка</h3>
        {upper.slice(0, 2).map((match) => (
          <BracketMatch key={match.id} match={match} />
        ))}
      </section>
      <section className="bracket__column">
        <h3 className="bracket__title">Финалы</h3>
        {upper.slice(2).map((match) => (
          <BracketMatch key={match.id} match={match} />
        ))}
        {lower.slice(1).map((match) => (
          <BracketMatch key={match.id} match={match} />
        ))}
      </section>
      <section className="bracket__column">
        <h3 className="bracket__title">Нижняя сетка</h3>
        {lower.slice(0, 1).map((match) => (
          <BracketMatch key={match.id} match={match} />
        ))}
      </section>
    </div>
  );
}
