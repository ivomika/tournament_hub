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

## Flutter component architecture

- `presentation/design_system/tokens` содержит generated primitives и не является публичным runtime API.
- `presentation/design_system/theme` — единственное место, где primitive tokens преобразуются в общую `ThemeData` и typed component themes.
- Каждый component находится в `components/<name>/`, имеет widget и собственный `ThemeExtension`; component читает только этот extension.
- `design_system.dart` экспортирует widgets/models, но не generated tokens и не internal theme mappings.
- Каждый screen находится в отдельном файле и только компонует публичные DS components. Material visual controls, raw values и private themes в screens запрещены.
- Соблюдение структуры проверяется автоматически согласно [ADR-0003](../adr/0003-flutter-design-system-boundaries.md).

## Interaction

- Интерактивная область использует token минимального target; видимый control может быть компактнее только при сохранении target.
- В visual region одна dominant Primary action.
- Destructive action отделена, описывает последствие и требует confirmation.
- Disabled action по возможности сопровождается причиной.
- Keyboard order совпадает с visual/logical order; visible focus обязателен.
- Hover не является единственным способом открыть информацию или действие.

## Visual hierarchy patterns

- Canvas остаётся глубоким и спокойным; elevated surfaces создают глубину, но не превращают каждый блок в одинаковую карточку.
- Gold accent используется как дефицитный сигнал: dominant action, live/current state, active boundary и champion culmination. Вторичные данные не конкурируют с ним.
- Каждый экран имеет один dominant object. На Main это active tournament summary, в Running — current matchup, в Result Entry — выбор победителя, в Finished — champion identity.
- Tournament-specific compositions предпочтительнее generic card stacking: matchup строится вокруг двух fighter identities и `VS`, result — вокруг однозначных outcome actions, champion — вокруг hero artwork и tournament context.
- Compact layout меняет порядок и группировку элементов. Expanded layout использует независимые панели и split composition; растягивание одной мобильной колонки на desktop не считается адаптацией.
- Typography разделяет stage label, screen heading, object title и supporting copy. Uppercase допустим для коротких tournament/stage labels, но не для длинного body-текста.
- Cinematic treatment создаётся semantic surface hierarchy, artwork scale и композицией. Декоративный шум, градиент или motion не могут ухудшать читаемость и не являются носителем состояния.

## Core components

Каждый component имеет необходимые default, hover/focus/pressed, disabled, loading и error states.

- `ParticipantIdentity`: до assignment — nickname/status; после — artwork, fighter name, nickname и badge «Гость».
- `FighterAvatar`: stable crop variants, semantic label, fallback/placeholder.
- `MatchCard/CurrentMatch`: stage, identities, score/result type, Current emphasis и разрешённые actions.
- `StandingsTable`: готовые place/result/tie-break labels и fighter identity; table на desktop, compact rows на mobile. Widget не вычисляет очки, победы или места.
- `Bracket`: связи первичны, затем identity/result/metadata; предусмотрены pan/zoom/keyboard alternatives.
- `StatusBadge`: text плюс icon/shape; значение не передаётся только цветом.
- `ConnectionBanner`: live/reconnecting/stale/incompatible и recovery.
- `QrCode`: готовый opaque value, semantic label, scan state и size preset; renderer, minimum module pitch и безопасный fallback скрыты внутри primitive.
- `QrQuietZone`: скруглённая непрозрачная светлая подложка и quiet zone не менее четырёх модулей, вычисленная из фактической QR dimension; внешний радиус не пересекает матрицу.
- `ConnectionQrCard`: scenario wrapper над `QrCode`; безопасный ручной адрес, typed connection state и copy/share/retry callbacks. Generation URI и Host lifecycle остаются вне presentation.
- `ParticipantInviteCard`: постоянное приглашение в открытом лобби с participant-specific label, QR, кодом и тем же ручным endpoint.
- `ParticipantJoinPanel`: scanner/code-first поверхность входа с отдельными idle/scanning/connecting/accepted/denied/notFound/error состояниями.
- `SpectatorAccessDialog`: полноэкранная on-demand поверхность для телевизора; композирует `ConnectionQrCard`, сохраняет read-only role label и не блокирует Host flow.
- `Empty/ErrorState`: конкретная причина и одно recovery action.
- `ConfirmationDialog`: объект, необратимое последствие и safe default focus.
- `ChampionHero`: fighter identity, champion participant и tournament context; complete ranking остаётся доступным.

### QR connection presentation

`QrCode` и `QrQuietZone` определены [ADR-0005](../adr/0005-reusable-qr-primitives.md). `pretty_qr_code` остаётся внутренним adapter только в `QrCode`; `ConnectionQrCard` композирует public primitive и не владеет renderer-ом. Публичный DS API не экспортирует package types и не генерирует LAN/session URI.

- QR использует однотонный связный smooth shape с контролируемым скруглением, светлый фон, error correction `M` и quiet zone в четыре модуля; разрозненные точки, логотип, градиент и прозрачность внутри матрицы запрещены.
- `QrCode` всегда включает `QrQuietZone`; consumer не может уменьшить quiet zone, сделать подложку прозрачной или изменить renderer knobs.
- Size preset обязан сохранять minimum module pitch для фактического payload; иначе primitive показывает явный non-scannable fallback.
- Логотип, градиент, прозрачность, motion и декоративные overlays внутри матрицы запрещены.
- Mobile композиция ставит QR перед адресом; expanded композиция разделяет QR и address/actions на независимые панели.
- Ручной адрес всегда видим и selectable; copy/share/retry имеют текстовый feedback и доступны с клавиатуры.
- `starting`, `ready`, `reconnecting`, `unavailable`, `expired`, `error`, `stale`, `copied` различаются текстом и semantics, а не только цветом.
- `encodedValue` не включается в semantics, logs и пользовательскую диагностику; безопасный `displayAddress` передаётся отдельно.
- Participant invitation постоянно виден в `Open`, а spectator QR открывается только явным действием и не конкурирует с roster или primary lifecycle action.
- Participant и Spectator используют отдельные typed visual projections и role labels. На mock-only этапе оба могут ссылаться на один synthetic `http://<ip>:<port>`, но не объединяются в один interaction contract.

### Tournament structure representations

- `MatchList` — каноническая compact-representation: один линейный список с семантическими заголовками этапов, полными fighter/participant identities и текстовым состоянием каждого матча.
- `DoubleEliminationBracket` — expanded-representation: отдельные Winners/Losers lanes, Grand Final, условный Bracket Reset и явные connectors. Pan/zoom не заменяет доступное текстовое описание связей.
- Оба renderer получают готовые matches, states и links из presentation projection. Они не рассчитывают progression, Bye, Reset, места или correction.
- Single Elimination и Round Robin используют `MatchList`, пока для них не определён отдельный канонический expanded renderer.

### Fighter artwork hierarchy

Character artwork — главный визуальный якорь post-assignment identity, а не маленькая декоративная иконка. Semantic variants из `artwork.size.*` применяются по роли representation:

- `compact` — вторичная tournament structure: standings и bracket;
- `standard` — roster/distribution и обычная participant identity;
- `matchup` — Current Match и ввод результата;
- `hero` — champion и экран собственного назначенного персонажа.

Более крупный variant нельзя заменять nickname-only или уменьшать до generic control icon. Character name и participant nickname всегда остаются рядом как text/accessibility carriers. На compact width `matchup`/`hero` меняют композицию, а не уменьшают artwork до вторичного уровня.

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

## Accessibility и UI-контент

- Пользовательские labels и announcements пишутся по-русски; английские Domain identifiers допустимы только как технические термины или официальные названия формата.
- Status badge объявляется как «Статус: …» и всегда сочетает текст с icon/shape; цвет не является единственным carrier.
- Составная fighter identity имеет единый semantics label: fighter name, nickname и «Гость», если применимо.
- Confirmation ставит safe action первым в keyboard focus и после закрытия возвращает focus элементу-инициатору.
- При системном reduced motion UI не добавляет декоративную анимацию; critical state change остаётся текстовым и немедленным.

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

## Flutter presentation catalog

Widgetbook запускается отдельным entry point `apps/tournament_app/lib/main_widgetbook.dart`. Каталог показывает generated tokens, reusable components, presentation states и все Flutter screen previews в project viewports Mobile/Desktop. Он является visual development tool и не заменяет production router, Domain behavior или канонические требования этого документа и [screen map](../product/screen-map.md). Решение зафиксировано в [ADR-0002](../adr/0002-widgetbook-presentation-catalog.md).
