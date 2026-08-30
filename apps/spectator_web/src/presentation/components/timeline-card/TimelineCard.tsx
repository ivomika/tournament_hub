import type { MatchModel } from "../../types.ts";
import { FighterIdentity } from "../fighter-identity/FighterIdentity.tsx";

const stateLabel = {
  previous: "Завершён",
  current: "Сейчас",
  next: "Следующий",
} as const;

export function TimelineCard({ match }: { match: MatchModel }) {
  return (
    <article className="timeline-card surface">
      <header className="timeline-card__header">
        <div>
          <p className="stage-label">{match.stage}</p>
          <strong>{match.label}</strong>
        </div>
        <span className="timeline-card__state">{stateLabel[match.state]}</span>
      </header>
      <div className="timeline-card__row">
        <FighterIdentity identity={match.first} />
        <span className="timeline-card__score">{match.score?.[0] ?? "—"}</span>
      </div>
      <div className="timeline-card__row">
        <FighterIdentity identity={match.second} />
        <span className="timeline-card__score">{match.score?.[1] ?? "—"}</span>
      </div>
    </article>
  );
}
