import { ParticipantCard } from "../components/ParticipantCard";
import type {
  ParticipantView,
  RoundRobinView,
} from "../transport/spectatorProtocol";

interface RoundRobinScreenProps {
  projection: RoundRobinView;
  participants: ParticipantView[];
}

export function RoundRobinScreen({
  projection,
  participants,
}: RoundRobinScreenProps) {
  const byId = new Map(
    participants.map((participant) => [participant.id, participant]),
  );
  const matches = new Map(projection.matches.map((match) => [match.id, match]));
  return (
    <>
      <section className="dashboard__section">
        <div className="section-heading">
          <p className="eyebrow">ТАБЛИЦА</p>
          <h2>Текущие места</h2>
        </div>
        <div
          className="standings-table"
          role="table"
          aria-label="Турнирная таблица"
        >
          <div className="standings-row standings-row--header" role="row">
            <span>Место</span>
            <span>Участник</span>
            <span>И</span>
            <span>В</span>
            <span>П</span>
            <span>Схватки</span>
            <span>Очки</span>
          </div>
          {projection.standings.map((standing) => {
            const participant = byId.get(standing.participantId)!;
            return (
              <div
                className="standings-row"
                role="row"
                key={standing.participantId}
              >
                <strong>#{standing.position}</strong>
                <ParticipantCard participant={participant} compact />
                <span>{standing.matchesPlayed}</span>
                <span>{standing.wins}</span>
                <span>{standing.losses}</span>
                <span>
                  {standing.gamesWon}:{standing.gamesLost}
                </span>
                <strong className="standings-row__points">
                  {standing.points}
                </strong>
              </div>
            );
          })}
        </div>
      </section>

      <section className="dashboard__section">
        <div className="section-heading">
          <p className="eyebrow">РАСПИСАНИЕ</p>
          <h2>Раунды и матчи</h2>
        </div>
        <div className="round-grid">
          {projection.rounds.map((round) => (
            <article className="round-card" key={round.number}>
              <header>
                <span>РАУНД</span>
                <strong>{round.number}</strong>
              </header>
              {round.matchIds.map((matchId) => {
                const match = matches.get(matchId)!;
                const first = byId.get(match.firstParticipantId)!;
                const second = byId.get(match.secondParticipantId)!;
                return (
                  <div
                    className={`match-line match-line--${match.status}`}
                    key={match.id}
                  >
                    <div>
                      <span>{first.nickname}</span>
                      <small>{first.fighter.displayName}</small>
                    </div>
                    <strong>
                      {match.firstScore}:{match.secondScore}
                    </strong>
                    <div>
                      <span>{second.nickname}</span>
                      <small>{second.fighter.displayName}</small>
                    </div>
                    <i>{statusLabel(match.status)}</i>
                  </div>
                );
              })}
              {round.byeParticipantId && (
                <p className="bye-line">
                  Bye · {byId.get(round.byeParticipantId)?.nickname}
                </p>
              )}
            </article>
          ))}
        </div>
      </section>
    </>
  );
}

function statusLabel(status: "planned" | "inProgress" | "completed") {
  return {
    planned: "Ожидает",
    inProgress: "Идёт сейчас",
    completed: "Завершён",
  }[status];
}
