import { useMemo, useState } from "react";

import { createBracketLayout } from "../state/bracketLayout";
import type {
  DoubleEliminationView,
  EliminationMatchView,
  ParticipantView,
} from "../transport/spectatorProtocol";

interface DoubleEliminationBracketScreenProps {
  projection: DoubleEliminationView;
  participants: ParticipantView[];
}

export function DoubleEliminationBracketScreen({
  projection,
  participants,
}: DoubleEliminationBracketScreenProps) {
  const [zoom, setZoom] = useState(1);
  const layout = useMemo(
    () => createBracketLayout(projection.matches),
    [projection.matches],
  );
  const participantById = new Map(
    participants.map((participant) => [participant.id, participant]),
  );

  return (
    <section className="dashboard__section bracket-section">
      <div className="section-heading bracket-heading">
        <div>
          <p className="eyebrow">КАНОНИЧНАЯ СЕТКА</p>
          <h2>Double Elimination</h2>
        </div>
        <div className="zoom-controls" aria-label="Масштаб сетки">
          <button
            type="button"
            aria-label="Уменьшить масштаб"
            onClick={() => setZoom((value) => Math.max(0.55, value - 0.15))}
          >
            −
          </button>
          <span>{Math.round(zoom * 100)}%</span>
          <button
            type="button"
            aria-label="Увеличить масштаб"
            onClick={() => setZoom((value) => Math.min(1.5, value + 0.15))}
          >
            +
          </button>
        </div>
      </div>
      <div
        className="bracket-viewport"
        tabIndex={0}
        aria-label="Турнирная сетка"
      >
        <div
          className="bracket-scaled-area"
          style={{ width: layout.width * zoom, height: layout.height * zoom }}
        >
          <div
            className="bracket-canvas"
            style={{
              width: layout.width,
              height: layout.height,
              transform: `scale(${zoom})`,
            }}
          >
            <div className="bracket-region-title bracket-region-title--winners">
              Верхняя сетка · Winners bracket
            </div>
            <div
              className="bracket-region-title bracket-region-title--losers"
              style={{ top: layout.winnersHeight + 70 }}
            >
              Нижняя сетка · Losers bracket
            </div>
            <svg
              className="bracket-connectors"
              width={layout.width}
              height={layout.height}
              aria-hidden="true"
            >
              {layout.links.map((link) => (
                <path
                  key={link.id}
                  d={link.path}
                  className={`bracket-link bracket-link--${link.sourceType}`}
                />
              ))}
            </svg>
            {layout.nodes.map((node) => (
              <BracketMatchCard
                key={node.match.id}
                match={node.match}
                participantById={participantById}
                style={{ left: node.x, top: node.y }}
              />
            ))}
          </div>
        </div>
      </div>
      {projection.placementReplays.length > 0 && (
        <div className="placement-block">
          <p className="eyebrow">ОПРЕДЕЛЕНИЕ МЕСТ</p>
          <h3>Placement replay</h3>
          {projection.placementReplays.map((replay) => (
            <div
              className="placement-card"
              key={`${replay.groupId}-${replay.replayNumber}`}
            >
              <strong>Переигровка {replay.replayNumber}</strong>
              <span>
                {replay.matches.filter((match) => match.winnerId).length}/
                {replay.matches.length} матчей
              </span>
            </div>
          ))}
        </div>
      )}
    </section>
  );
}

interface BracketMatchCardProps {
  match: EliminationMatchView;
  participantById: Map<string, ParticipantView>;
  style: { left: number; top: number };
}

function BracketMatchCard({
  match,
  participantById,
  style,
}: BracketMatchCardProps) {
  return (
    <article
      className={`bracket-match bracket-match--${match.status}`}
      style={style}
      data-match-id={match.id}
    >
      <header>
        <span>{matchLabel(match)}</span>
        <i>{statusLabel(match.status)}</i>
      </header>
      <BracketSlot
        participant={
          match.firstParticipantId
            ? participantById.get(match.firstParticipantId)
            : undefined
        }
        winner={match.winnerId === match.firstParticipantId}
      />
      <BracketSlot
        participant={
          match.secondParticipantId
            ? participantById.get(match.secondParticipantId)
            : undefined
        }
        winner={match.winnerId === match.secondParticipantId}
      />
    </article>
  );
}

function BracketSlot({
  participant,
  winner,
}: {
  participant?: ParticipantView;
  winner: boolean;
}) {
  return (
    <div className={`bracket-slot ${winner ? "bracket-slot--winner" : ""}`}>
      {participant ? (
        <>
          <img src={participant.fighter.avatarUrl} alt="" />
          <span>
            <strong>{participant.nickname}</strong>
            <small>{participant.fighter.displayName}</small>
          </span>
          {winner && <b>W</b>}
        </>
      ) : (
        <span className="bracket-slot__empty">Ожидает участника</span>
      )}
    </div>
  );
}

function matchLabel(match: EliminationMatchView) {
  if (match.stage === "grandFinal") return "Гранд-финал";
  if (match.stage === "grandFinalReset") return "Reset-финал";
  return `R${match.round} · M${match.position + 1}`;
}

function statusLabel(status: EliminationMatchView["status"]) {
  return {
    waiting: "ожидает",
    ready: "готов",
    completed: "завершён",
    automatic: "bye",
    skipped: "не нужен",
  }[status];
}
