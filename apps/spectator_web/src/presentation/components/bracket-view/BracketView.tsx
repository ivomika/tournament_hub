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
  const stages = [...new Set(matches.map((match) => match.stage))];
  return (
    <div className="bracket" aria-label="Структура турнира">
      {stages.map((stage) => (
        <section className="bracket__column" key={stage}>
          <h3 className="bracket__title">{stage}</h3>
          {matches
            .filter((match) => match.stage === stage)
            .map((match) => (
              <BracketMatch key={match.id} match={match} />
            ))}
        </section>
      ))}
    </div>
  );
}
