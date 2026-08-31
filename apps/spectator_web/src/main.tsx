import { StrictMode, useMemo, useState } from "react";
import { createRoot } from "react-dom/client";
import { toPresentationProjection } from "./application/spectator/presentationMapper.ts";
import { useSpectatorClient } from "./application/spectator/useSpectatorClient.ts";
import { ConnectionStatePanel } from "./presentation/components/connection-state-panel/ConnectionStatePanel.tsx";
import { SpectatorShell } from "./presentation/components/spectator-shell/SpectatorShell.tsx";
import { ChampionScreen } from "./presentation/screens/ChampionScreen.tsx";
import { DashboardScreen } from "./presentation/screens/DashboardScreen.tsx";
import { TournamentScreen } from "./presentation/screens/TournamentScreen.tsx";
import type { SpectatorView } from "./presentation/types.ts";
import "./presentation/design-system/tokens.css";
import "./presentation/design-system/theme.css";

export function SpectatorApp() {
  const [view, setView] = useState<SpectatorView>("dashboard");
  const { state, retry } = useSpectatorClient();
  const projection = useMemo(() => toPresentationProjection(state), [state]);

  if (projection === undefined) {
    return (
      <div className="shell">
        <main className="shell__content shell__content--centered">
          <ConnectionStatePanel state={state.connection} onRetry={retry} />
        </main>
      </div>
    );
  }
  const activeView: SpectatorView =
    projection.tournament.lifecycle === "finished"
      ? "champion"
      : view === "champion"
        ? "dashboard"
        : view;

  return (
    <SpectatorShell
      connection={projection.connection}
      tournament={projection.tournament}
      view={activeView}
      onViewChange={setView}
    >
      {activeView === "dashboard" && (
        <DashboardScreen projection={projection} />
      )}
      {activeView === "tournament" && (
        <TournamentScreen projection={projection} />
      )}
      {activeView === "champion" && <ChampionScreen projection={projection} />}
    </SpectatorShell>
  );
}

const root = document.getElementById("root");

if (root === null) {
  throw new Error("Root element is missing");
}

createRoot(root).render(
  <StrictMode>
    <SpectatorApp />
  </StrictMode>,
);
