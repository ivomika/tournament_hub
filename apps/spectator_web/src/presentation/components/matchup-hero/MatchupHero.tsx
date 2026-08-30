import type { MatchModel } from "../../types.ts";
import { FighterIdentity } from "../fighter-identity/FighterIdentity.tsx";

export function MatchupHero({ match }: { match: MatchModel }) {
  return (
    <section
      className="matchup surface"
      aria-label={`Текущий матч: ${match.first.nickname} против ${match.second.nickname}`}
    >
      <header className="matchup__meta">
        <span>
          {match.stage} · {match.label}
        </span>
        <span
          aria-label={`Счёт ${match.score?.[0] ?? 0}:${match.score?.[1] ?? 0}`}
        >
          {match.score?.[0] ?? 0} : {match.score?.[1] ?? 0}
        </span>
      </header>
      <FighterIdentity identity={match.first} variant="matchup" />
      <span className="matchup__versus" aria-hidden="true">
        VS
      </span>
      <FighterIdentity identity={match.second} variant="matchup" reverse />
    </section>
  );
}
