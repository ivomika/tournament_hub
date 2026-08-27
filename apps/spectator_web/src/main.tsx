import { StrictMode } from "react";
import { createRoot } from "react-dom/client";

export function SpectatorApp() {
  return (
    <main>
      <h1>Tournament Hub</h1>
      <p>Экран зрителя готов к подключению турнира.</p>
    </main>
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
