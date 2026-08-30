import type { StandingModel } from "../../types.ts";
import { FighterIdentity } from "../fighter-identity/FighterIdentity.tsx";

export function StandingsTable({
  standings,
}: {
  standings: readonly StandingModel[];
}) {
  return (
    <div className="surface">
      <table className="standings">
        <thead>
          <tr>
            <th>Место</th>
            <th>Участник</th>
            <th>Матчи</th>
            <th>Победы</th>
            <th>Очки</th>
          </tr>
        </thead>
        <tbody>
          {standings.map((standing) => (
            <tr key={standing.identity.nickname}>
              <td className="standings__place">{standing.place}</td>
              <td>
                <FighterIdentity identity={standing.identity} />
              </td>
              <td>{standing.played}</td>
              <td>{standing.wins}</td>
              <td>
                <strong>{standing.points}</strong>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
