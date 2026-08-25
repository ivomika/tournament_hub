import type { ParticipantView } from "../transport/spectatorProtocol";

interface ParticipantCardProps {
  participant: ParticipantView;
  compact?: boolean;
  highlighted?: boolean;
}

export function ParticipantCard({
  participant,
  compact = false,
  highlighted = false,
}: ParticipantCardProps) {
  return (
    <article
      className={`participant-card ${compact ? "participant-card--compact" : ""} ${highlighted ? "participant-card--highlighted" : ""}`}
    >
      <img
        className="participant-card__avatar"
        src={participant.fighter.avatarUrl}
        alt={participant.fighter.displayName}
      />
      <div className="participant-card__copy">
        <strong>{participant.nickname}</strong>
        <span>{participant.fighter.displayName}</span>
      </div>
    </article>
  );
}
