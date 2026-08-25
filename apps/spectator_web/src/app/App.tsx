import { ConnectionScreen } from "../screens/ConnectionScreen";
import { DashboardScreen } from "../screens/DashboardScreen";
import { FinalScreen } from "../screens/FinalScreen";
import { useSpectator, type SpectatorViewState } from "../state/useSpectator";

interface AppProps {
  state?: SpectatorViewState;
}

export function App({ state }: AppProps) {
  return state ? <AppContent state={state} /> : <ConnectedApp />;
}

function ConnectedApp() {
  const state = useSpectator();
  return <AppContent state={state} />;
}

function AppContent({ state }: { state: SpectatorViewState }) {
  if (!state.envelope) return <ConnectionScreen {...state} />;
  if (state.envelope.payload.state === "finished") {
    return <FinalScreen envelope={state.envelope} connection={state} />;
  }
  return <DashboardScreen envelope={state.envelope} connection={state} />;
}
