import type { SpectatorViewState } from "../state/useSpectator";

export function ConnectionScreen({
  status,
  message,
  retry,
}: SpectatorViewState) {
  const hasError = status === "disconnected" || status === "incompatible";
  return (
    <main className="connection-screen">
      <div className="connection-screen__mark">TH</div>
      <p className="eyebrow">ЛОКАЛЬНЫЙ ЭКРАН ЗРИТЕЛЯ</p>
      <h1>Tournament HUB</h1>
      <p className="connection-screen__status">
        {message ?? "Ожидание состояния турнира от Host…"}
      </p>
      {hasError && (
        <button className="button" type="button" onClick={retry}>
          Подключиться снова
        </button>
      )}
    </main>
  );
}
