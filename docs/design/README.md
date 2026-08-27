# Design system

## Направление

`Competitive / Cinematic / Clean`: информация и следующее действие важнее декора; интерфейс dark-first; artwork бойца является частью identity. Flutter строится mobile-first с адаптивной desktop-композицией, Spectator Web — desktop-first и должен читаться с расстояния.

Числовые и цветовые значения не определяются в этом документе. Единственный machine-readable источник значений — [`tokens.json`](tokens.json), правила его изменения и потребления — [`tokens.md`](tokens.md). Логические экраны, роли и переходы заданы в [карте экранов](../product/screen-map.md).

## Принципы применения tokens

- Компоненты используют semantic tokens, а не raw literals.
- Layout выбирается по доступной ширине, text scale и split-screen, а не по имени ОС.
- Исключение для artwork, платформенной особенности или вычисляемого значения документируется по [политике решений](../governance/decision-policy.md).
- Новый raw value сначала добавляется или сопоставляется в manifest; параллельный источник во Flutter/Web запрещён.
- Изменение manifest требует проверки обеих платформенных тем и затронутых visual regressions.

## Interaction

- Интерактивная область использует token минимального target; видимый control может быть компактнее только при сохранении target.
- В visual region одна dominant Primary action.
- Destructive action отделена, описывает последствие и требует confirmation.
- Disabled action по возможности сопровождается причиной.
- Keyboard order совпадает с visual/logical order; visible focus обязателен.
- Hover не является единственным способом открыть информацию или действие.

## Core components

Каждый component имеет необходимые default, hover/focus/pressed, disabled, loading и error states.

- `ParticipantIdentity`: до assignment — nickname/status; после — artwork, fighter name, nickname и Guest badge.
- `FighterAvatar`: stable crop variants, semantic label, fallback/placeholder.
- `MatchCard/CurrentMatch`: stage, identities, score/result type, Current emphasis и разрешённые actions.
- `StandingsTable`: place, identity, points/tie context; table на desktop, compact rows/scroll на mobile.
- `Bracket`: связи первичны, затем identity/result/metadata; предусмотрены pan/zoom/keyboard alternatives.
- `StatusBadge`: text плюс icon/shape; значение не передаётся только цветом.
- `ConnectionBanner`: live/reconnecting/stale/incompatible и recovery.
- `Empty/ErrorState`: конкретная причина и одно recovery action.
- `ConfirmationDialog`: объект, необратимое последствие и safe default focus.
- `ChampionHero`: fighter identity, champion participant и tournament context; complete ranking остаётся доступным.

## Screen composition contract

Канонический список экранов и переходов находится в [screen map](../product/screen-map.md). Визуальные обязательства:

- Main показывает active state и next action до вторичных действий.
- Draft сохраняет видимый summary и показывает validation рядом с field.
- Open отделяет roster, connection и management actions.
- Distribution показывает полную identity каждого участника и confirmation перед стартом.
- Running делает Current match визуально сильнейшим элементом.
- Result entry показывает две однозначные identities, outcome и отдельно correction path.
- Finished показывает champion и полную ranking с выходом в Main/History.
- History явно read-only и адаптивно раскрывает snapshot detail.
- Spectator показывает previous/current/next, connection state и не имитирует mutation controls.

## Participant identity

После Distribution любое упоминание participant в tournament context включает fighter asset, fighter name и participant nickname. Правило действует для cards, standings, bracket, results, dialogs, notifications с изображениями, history и spectator. Compact variant может уменьшать artwork, но не удалять fighter name.

## Loading, error и stale

- Loading локален; существующий content не исчезает без необходимости.
- Optimistic mutation разрешена только при формализованных rollback и authoritative reconciliation; иначе success показывается после commit.
- Error скрывает exception/stack, сохраняет введённые данные и предлагает retry/correction.
- Offline/stale сохраняет last-known data, блокирует mutation и явно сообщает sync state.
- Empty отличается от loading и permission denied.

## Accessibility gates

- Contrast проверяется по WCAG для текста и interactive boundaries; token pairs проходят автоматическую или документированную ручную проверку.
- Semantic labels содержат fighter, nickname, status и score, когда они представлены визуально.
- Максимальный поддерживаемый text scale не обрезает critical actions/data.
- Keyboard и screen reader проходят основной Host/Participant flow.
- Focus сохраняется после async update; dialog возвращает focus инициатору.
- Touch, color, motion, sound и hover не являются единственным carrier.
- Locale strings не собираются конкатенацией и выдерживают длинный русский текст.

## Visual QA

Проверяются все classes из manifest, поддерживаемые text scales, длинные nickname/title, missing artwork, empty/error/loading/stale, keyboard focus, reduced motion, contrast и screenshot/golden ключевых компонентов. Конкретный набор checks фиксируется в карточке задачи.
