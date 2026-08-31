import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { ConnectionStatePanel } from "./presentation/components/connection-state-panel/ConnectionStatePanel.tsx";
import { SpectatorShell } from "./presentation/components/spectator-shell/SpectatorShell.tsx";
import "./presentation/design-system/tokens.css";
import "./presentation/design-system/theme.css";
import { spectatorFixture } from "./presentation/fixtures/spectatorFixture.ts";
import { ChampionScreen } from "./presentation/screens/ChampionScreen.tsx";
import { DashboardScreen } from "./presentation/screens/DashboardScreen.tsx";
import { TournamentScreen } from "./presentation/screens/TournamentScreen.tsx";
import type {
  ConnectionState,
  SpectatorProjection,
  SpectatorView,
} from "./presentation/types.ts";

const parameters = new URLSearchParams(window.location.search);
const requestedScenario = parameters.get("scenario") ?? "dashboard";

export function VisualEvidenceApp() {
  if (requestedScenario === "waiting") {
    return (
      <div className="shell">
        <main className="shell__content shell__content--centered">
          <ConnectionStatePanel state="waiting" />
        </main>
      </div>
    );
  }

  const projection = projectionFor(requestedScenario);
  const view = viewFor(requestedScenario);
  return (
    <SpectatorShell
      connection={projection.connection}
      tournament={projection.tournament}
      view={view}
      onViewChange={() => undefined}
    >
      {view === "dashboard" && <DashboardScreen projection={projection} />}
      {view === "tournament" && <TournamentScreen projection={projection} />}
      {view === "champion" && <ChampionScreen projection={projection} />}
    </SpectatorShell>
  );
}

function projectionFor(scenario: string): SpectatorProjection {
  const connection: ConnectionState = scenario === "stale" ? "stale" : "live";
  if (scenario !== "champion") {
    return {
      ...spectatorFixture,
      connection: {
        ...spectatorFixture.connection,
        state: connection,
        label: connection === "stale" ? "Данные устарели" : "Прямой эфир",
      },
    };
  }
  return {
    ...spectatorFixture,
    tournament: {
      ...spectatorFixture.tournament,
      lifecycle: "finished",
      progress: "Турнир завершён",
    },
  };
}

function viewFor(scenario: string): SpectatorView {
  if (scenario === "tournament") return "tournament";
  if (scenario === "champion") return "champion";
  return "dashboard";
}

const root = document.getElementById("root");
if (root === null) throw new Error("Root element is missing");

createRoot(root).render(
  <StrictMode>
    <VisualEvidenceApp />
  </StrictMode>,
);
