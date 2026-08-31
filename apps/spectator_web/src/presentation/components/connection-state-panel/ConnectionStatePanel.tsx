import type { SpectatorConnectionState } from "../../../application/spectator/reducer.ts";

const content: Record<SpectatorConnectionState, readonly [string, string]> = {
  waiting: [
    "Ожидаем начало турнира",
    "Экран обновится автоматически после раздачи персонажей.",
  ],
  connecting: [
    "Подключаемся к Host",
    "Проверяем доступность актуального состояния турнира.",
  ],
  synchronizing: [
    "Синхронизируем турнир",
    "Получаем подтверждённый снимок и события.",
  ],
  live: ["Прямой эфир", "Данные турнира актуальны."],
  stale: [
    "Данные могут быть устаревшими",
    "Показываем последний подтверждённый снимок и восстанавливаем соединение.",
  ],
  reconnecting: [
    "Восстанавливаем соединение",
    "Последний подтверждённый снимок остаётся на экране.",
  ],
  incompatible: [
    "Версия экрана несовместима",
    "Обновите страницу или приложение Host.",
  ],
  error: [
    "Не удалось подключиться",
    "Проверьте, что устройство находится в одной сети с Host.",
  ],
};

export function ConnectionStatePanel({
  state,
  onRetry,
}: {
  state: SpectatorConnectionState;
  onRetry?: () => void;
}) {
  const [title, detail] = content[state];
  return (
    <section
      className="connection-state surface"
      role="status"
      aria-live="polite"
    >
      <p className="stage-label">Зрительский экран</p>
      <h1>{title}</h1>
      <p>{detail}</p>
      {(state === "error" || state === "incompatible") &&
        onRetry !== undefined && (
          <button
            className="connection-state__action"
            type="button"
            onClick={onRetry}
          >
            Повторить
          </button>
        )}
    </section>
  );
}
