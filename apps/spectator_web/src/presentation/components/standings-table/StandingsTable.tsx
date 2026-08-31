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
            <th>Результат</th>
          </tr>
        </thead>
        <tbody>
          {standings.map((standing) => (
            <tr key={standing.participantId}>
              <td className="standings__place">{standing.placeLabel}</td>
              <td>
                <FighterIdentity identity={standing.identity} />
              </td>
              <td>
                <strong>
                  {standing.placeLabel === "1" ? "Чемпион" : "Итоговое место"}
                </strong>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
