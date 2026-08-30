import { StrictMode, useState } from "react";
import { createRoot } from "react-dom/client";
import { SpectatorShell } from "./presentation/components/spectator-shell/SpectatorShell.tsx";
import { spectatorFixture } from "./presentation/fixtures/spectatorFixture.ts";
import { ChampionScreen } from "./presentation/screens/ChampionScreen.tsx";
import { DashboardScreen } from "./presentation/screens/DashboardScreen.tsx";
import { TournamentScreen } from "./presentation/screens/TournamentScreen.tsx";
import type { SpectatorView } from "./presentation/types.ts";
import "./presentation/design-system/tokens.css";
import "./presentation/design-system/theme.css";

export function SpectatorApp() {
  const [view, setView] = useState<SpectatorView>("dashboard");

  return (
    <SpectatorShell
      connection={spectatorFixture.connection}
      tournament={spectatorFixture.tournament}
      view={view}
      onViewChange={setView}
    >
      {view === "dashboard" && (
        <DashboardScreen projection={spectatorFixture} />
      )}
      {view === "tournament" && (
        <TournamentScreen projection={spectatorFixture} />
      )}
      {view === "champion" && <ChampionScreen projection={spectatorFixture} />}
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
