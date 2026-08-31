import type { FighterIdentityModel } from "../../types.ts";
import { FighterIdentity } from "../fighter-identity/FighterIdentity.tsx";

export function AssignmentGrid({
  participants,
}: {
  participants: readonly FighterIdentityModel[];
}) {
  return (
    <section className="assignment-grid" aria-label="Распределение персонажей">
      {participants.map((participant) => (
        <article
          className="assignment-card surface"
          key={participant.participantId}
        >
          <FighterIdentity identity={participant} variant="matchup" />
        </article>
      ))}
    </section>
  );
}
