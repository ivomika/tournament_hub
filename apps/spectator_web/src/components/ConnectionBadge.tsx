import type { ConnectionStatus } from "../transport/spectatorTransport";

interface ConnectionBadgeProps {
  status: ConnectionStatus;
  revision?: number;
}

const labels: Record<ConnectionStatus, string> = {
  connecting: "Подключение",
  connected: "В эфире",
  reconnecting: "Переподключение",
  disconnected: "Нет связи",
  incompatible: "Несовместимый протокол",
};

export function ConnectionBadge({ status, revision }: ConnectionBadgeProps) {
  return (
    <span className={`connection-badge connection-badge--${status}`}>
      <i aria-hidden="true" />
      {labels[status]}
      {revision ? ` · rev ${revision}` : ""}
    </span>
  );
}
