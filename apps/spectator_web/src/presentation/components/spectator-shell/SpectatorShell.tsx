import type { PropsWithChildren } from "react";
import type {
  ConnectionState,
  SpectatorProjection,
  SpectatorView,
} from "../../types.ts";

interface SpectatorShellProps extends PropsWithChildren {
  connection: { state: ConnectionState; label: string; sequence: number };
  tournament: SpectatorProjection["tournament"];
  view: SpectatorView;
  onViewChange: (view: SpectatorView) => void;
}

const views: readonly { id: SpectatorView; label: string }[] = [
  { id: "dashboard", label: "Эфир" },
  { id: "tournament", label: "Турнир" },
  { id: "champion", label: "Итоги" },
];

export function SpectatorShell({
  connection,
  tournament,
  view,
  onViewChange,
  children,
}: SpectatorShellProps) {
  return (
    <div className="shell">
      <header className="shell__header">
        <div className="brand">
          <p className="brand__eyebrow">Tournament Hub</p>
          <h1 className="brand__title">{tournament.title}</h1>
        </div>
        <nav className="view-nav" aria-label="Разделы трансляции">
          {views.map((item) => (
            <button
              className="view-nav__item"
              type="button"
              key={item.id}
              aria-current={view === item.id ? "page" : undefined}
              onClick={() => onViewChange(item.id)}
            >
              {item.label}
            </button>
          ))}
        </nav>
        <div
          className="connection"
          data-state={connection.state}
          role="status"
          aria-label={`Статус: ${connection.label}`}
        >
          <span className="connection__dot" aria-hidden="true" />
          <span>
            {connection.label} · #{connection.sequence}
          </span>
        </div>
      </header>
      <main className="shell__content">{children}</main>
    </div>
  );
}
