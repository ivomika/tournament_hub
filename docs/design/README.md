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

### Action placement

`ActionDock` — единый action contract для Host lifecycle: закреплённый region на mobile и компактный toolbar у заголовка на desktop. Он не является универсальной нижней панелью для остальных ролей и не владеет lifecycle или navigation logic. На длинном operational screen допускается одно компактное contextual action для возврата к текущему semantic region; оно не дублирует primary и не создаёт второй fixed-слой. Подробные решения зафиксированы в [ADR-0007](../adr/0007-unified-host-action-contract.md) и [ADR-0009](../adr/0009-flow-layout-and-context-jumps.md).

На desktop toolbar прижат к правому краю общего `AppShell` content frame, а не к краю окна: header и body имеют одинаковые левую и правую границы даже на viewport шире `contentMaxWidth`. Primary action является крайним правым control внутри этого контура; overflow и contextual actions располагаются слева от него. Порядок не меняет keyboard/focus semantics и не создаёт второе primary действие.

| Экран | Primary placement | Secondary/destructive placement |
|---|---|---|
| Host Draft | `ActionDock`: «Открыть лобби» | Удаление черновика — destructive overflow с confirmation |
| Host Open | `ActionDock`: «Начать раздачу» | Spectator access, guest management и cancel — overflow |
| Host Distribution | `ActionDock`: «Создать сетку и начать», только при валидном составе | Reroll/back/cancel — overflow |
| Host Running | `ActionDock`: «Ввести результат» | Technical/correction/withdrawal — overflow по permissions |
| Host Result Entry | `ActionDock`: «Подтвердить победителя» | Back без изменений — overflow |
| Host Finished | `ActionDock`: «На главную» | История — overflow; mutation actions отсутствуют |
| Host Cancelled | `ActionDock`: «На главную» | История — overflow; mutation actions отсутствуют |
| Main | Header или inline рядом с объектом | Overflow либо отдельная danger zone |
| History, History Detail, Profile, Settings, Registration, Join | Header или inline | Overflow; sticky actions запрещены |
| Participant и Spectator | Inline/read-only controls | Host mutation actions запрещены |
| Recoverable Error | Inline recovery action рядом с причиной | Дополнительные способы восстановления — ниже основного |

- Mobile dock показывает одно primary action; secondary скрываются в доступный overflow.
- Dock учитывает SafeArea, keyboard `viewInsets` и добавляет body bottom inset по фактической высоте.
- Action region вместе с navigation не перекрывает content; ориентир dock — 15–18% viewport, жёсткий предел — 25%, в landscape — 20%.
- При 200% text scale label переносится или action переходит в overflow без clipping.
- Desktop не использует bottom dock: тот же Host action contract выравнивается с title/context как toolbar, secondary уходят в тот же overflow.
- Закрытие overflow/confirmation возвращает focus инициатору; loading/error/success объявляются semantics live region.

### Action verification matrix

| Область | Обязательная проверка |
|---|---|
| Layout | 320×720, compact/medium/expanded, portrait/landscape, SafeArea и keyboard |
| Content | body не перекрыт, primary доступно, одинаковое действие не дублируется inline |
| Accessibility | 200% text scale, semantics label/state, keyboard order и focus restoration |
| Motion | reduced-motion режим не использует обязательную анимацию появления/скрытия |
| Architecture | callback-only API, отсутствие domain/application/data imports |

## Visual hierarchy patterns

- Canvas остаётся глубоким и спокойным; elevated surfaces создают глубину, но не превращают каждый блок в одинаковую карточку.
- Gold accent используется как дефицитный сигнал: dominant action, live/current state, active boundary и champion culmination. Вторичные данные не конкурируют с ним.
- Каждый экран имеет один dominant object. На Main это active tournament summary, в Running — current matchup, в Result Entry — выбор победителя, в Finished — champion identity.
- Tournament-specific compositions предпочтительнее generic card stacking: matchup строится вокруг двух fighter identities и `VS`, result — вокруг однозначных outcome actions, champion — вокруг hero artwork и tournament context.
- Compact layout меняет порядок и группировку элементов. Expanded layout использует независимые панели и split composition; растягивание одной мобильной колонки на desktop не считается адаптацией.
- Typography разделяет stage label, screen heading, object title и supporting copy. Uppercase допустим для коротких tournament/stage labels, но не для длинного body-текста.
- Cinematic treatment создаётся semantic surface hierarchy, artwork scale и композицией. Декоративный шум, градиент или motion не могут ухудшать читаемость и не являются носителем состояния.

### Density и surface hierarchy

`DsDensity` описывает назначение content, а не размер экрана. Роль меняет только token-driven padding/gap и не уменьшает touch target, fighter identity или обязательный текст:

| Density | Назначение | Типичные consumers |
|---|---|---|
| `compact` | Повторяющиеся read-only rows и metadata с высокой информационной плотностью | History list, archived winner summary |
| `comfortable` | Обычная рабочая поверхность и формы; default | Draft, Settings, roster management |
| `presentation` | Единственный крупный identity/result object, читаемый с первого взгляда | назначенный fighter, champion/current presentation |

Surface tone выражает роль, а не вложенность: `base` — supporting/read-only, `elevated` — текущая рабочая группа или важный контекст, `accent` — единственный кульминационный/current boundary. Соседние containers не получают `accent` одновременно. Archive использует `compact` + `base` и не имитирует live climax; Participant может использовать `presentation` scale для fighter identity, но без Host mutation styling. Profile использует `focused` rationale как короткая identity-задача, Settings — `split` между обычными параметрами и отделённой danger zone; whitespace не заполняется декоративными cards.

## Core components

Каждый component имеет необходимые default, hover/focus/pressed, disabled, loading и error states.

- `ParticipantIdentity`: до assignment — nickname/status; после — artwork, fighter name, nickname и badge «Гость».
- `ParticipantAssignmentGrid`: сохраняет порядок участников и полную fighter identity; использует 1/2/3 колонки на compact/medium/expanded ширине без `Wrap`, а высота строки адаптируется к длинному тексту.
- `FighterAvatar`: stable crop variants, semantic label, fallback/placeholder.
- `MatchCard/CurrentMatch`: stage, identities, score/result type, Current emphasis и разрешённые actions. В dominant `MatchupHero` обе identity сохраняют вертикальную ось и отдельные grid tracks; `reverse` меняет порядок только у horizontal compact variant и не может направить copy/artwork в центральный track `VS`. Длинные fighter/nickname переносятся внутри собственной identity.
- `StandingsTable`: готовые place/result/tie-break labels, optional authoritative RR points и fighter identity; table на desktop, compact rows на mobile. Колонка place имеет отдельный semantic minimum и показывает точное место/диапазон одной строкой. Колонка/label «Очки» появляется только при наличии RR points в application projection; widget не вычисляет очки, победы или места.
- `Bracket`: связи первичны, затем identity/result/metadata; предусмотрены pan/zoom/keyboard alternatives.
- Spectator `BracketView` выбирает композицию по authoritative `formatId`: DE разделяет winners/losers и финальную lane с Grand Final/Reset, SE показывает только последовательность elimination rounds, RR — rounds/pairings рядом с standings. Mapper переносит `stageId/round/order` без вычисления progression. В elimination lanes соседние match groups соединяются token-driven горизонтальными branches и вертикальными merge lines; на large/xlarge применяется emphasis border для чтения с расстояния, на меньших viewport — base border. Это presentation направления потока, а не вычисление dependency graph. RR не получает ложных elimination connectors. Canvas поддерживает drag/touch pan, wheel/buttons/keyboard zoom, fit/reset и fullscreen с постоянно доступным выходом. Fullscreen отдаёт полотну всё пространство под toolbar и после смены layout автоматически выполняет fit. Compact использует тот же семантический список rounds/matches внутри прокручиваемого viewport.
- `StatusBadge`: text плюс icon/shape; значение не передаётся только цветом.
- `ConnectionBanner`: live/reconnecting/stale/incompatible и recovery.
- `QrCode`: готовый opaque value, semantic label, scan state и size preset; renderer, minimum module pitch и безопасный fallback скрыты внутри primitive.
- `QrQuietZone`: скруглённая непрозрачная светлая подложка и quiet zone не менее четырёх модулей, вычисленная из фактической QR dimension; внешний радиус не пересекает матрицу.
- `ConnectionQrCard`: scenario wrapper над `QrCode`; безопасный ручной адрес, typed connection state и copy/share/retry callbacks. Generation URI и Host lifecycle остаются вне presentation.
- `ParticipantInviteCard`: постоянное приглашение в открытом лобби с participant-specific label, QR, кодом и тем же ручным endpoint.
- `ParticipantJoinPanel`: scanner/code-first поверхность входа с отдельными idle/scanning/connecting/accepted/denied/notFound/error состояниями.
- `SpectatorAccessDialog`: полноэкранная on-demand поверхность для телевизора; композирует `ConnectionQrCard`, сохраняет read-only role label и не блокирует Host flow.
- `HostOpenConnectionSummary`: компактная Host/Open-диагностика из готовой typed view projection; endpoint/state не вычисляются экраном, QR остаётся внутри on-demand spectator dialog.
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

- `MatchList` — единственное operational-представление `TournamentBracketPreview` на всех viewport и для всех поддерживаемых форматов. Width и format меняют данные и семантические labels, но не renderer, порядок чтения или interaction model.
- Список организован по рабочему времени турнира: `Сейчас` → `Далее` → `Завершённые`. В каждой строке явно сохраняются stage/lane, готовое состояние матча и полные fighter/participant identities.
- На длинной completed-группе последние три матча остаются видимыми, более старые раскрываются через явное `Показать ещё (N)`. `Сейчас` и `Далее` не сворачиваются; disclosure не зависит от viewport или tournament format.
- Renderer получает готовые matches, states и links из presentation projection и не рассчитывает progression, Bye, Reset, места или correction.
- `DoubleEliminationBracket` остаётся отдельным reference/catalog component для исследования связей DE, но не подменяет operational Structure на desktop и не используется screen-level `TournamentBracketPreview`.

### Fighter artwork hierarchy

Character artwork — главный визуальный якорь post-assignment identity, а не маленькая декоративная иконка. Semantic variants из `artwork.size.*` применяются по роли representation:

- `compact` — вторичная tournament structure: standings и bracket;
- `standard` — roster/distribution и обычная participant identity;
- `matchup` — Current Match и ввод результата;
- `hero` — champion и экран собственного назначенного персонажа.

Более крупный variant нельзя заменять nickname-only или уменьшать до generic control icon. Character name и participant nickname всегда остаются рядом как text/accessibility carriers. На compact width `matchup`/`hero` меняют композицию, а не уменьшают artwork до вторичного уровня.

## Screen composition contract

Канонический список экранов и переходов находится в [screen map](../product/screen-map.md). Визуальные обязательства:

Page-level adaptive composition задаётся public `PageLayout` и semantic presets из [ADR-0008](../adr/0008-semantic-page-layout-presets.md) и [ADR-0009](../adr/0009-flow-layout-and-context-jumps.md). `focused` предназначен для одной readable задачи, `split` — для dominant object и компактного контекста, `workspace` — для рабочей области с полноценным secondary rail, `archive` — для списка/snapshot с metadata, `hero` — для champion/current identity с ranking/context, `flow` — для короткой верхней hybrid-композиции и длинного полноширинного operational continuation. На compact/medium regions следуют единым порядком `primary → secondary → supporting`; на expanded preset меняет композицию без дублирования content. Локальные `Row`/`Expanded`, screen-specific breakpoints, runtime-эвристики высоты и декоративное заполнение whitespace не заменяют semantic preset.

### Dominant-object matrix

Header называет экран и роль, но не конкурирует с его рабочим объектом. Повторный stage context на operational/terminal screens использует компактный `TournamentStageVariant.strip`: label, текстовый status и detail без второго крупного title/divider. `panel` допустим только когда stage summary сам является dominant object. В первом viewport допускаются одна accent surface и одна primary action.

| Состояние | Dominant object | Dominant action | Supporting objects |
|---|---|---|---|
| Main | active tournament summary либо create/join choice | продолжить active flow либо создать турнир | история и профиль |
| Host Draft | параметры и validation формы | открыть лобби | summary черновика |
| Host Open | roster/readiness | начать раздачу | participant invite, connection status |
| Host Distribution | fighter assignments | создать сетку и начать | compact assignment status |
| Host Running | current matchup | ввести результат | bracket/progress; для RR — текущие authoritative points |
| Host Result Entry | winner selection | подтвердить победителя | match metadata |
| Host Finished | champion identity | на главную | ranking, structure, read-only status |
| Host Cancelled | factual cancellation reason | на главную | immutable status, history link |
| Participant Lobby | собственная identity и readiness | отсутствует | next step, connection freshness |
| Participant Distribution | собственная fighter identity | отсутствует | connection и seeding status |
| Participant Running | current matchup | отсутствует | standings, connection freshness |
| Participant Finished | champion identity | переход на главную | ranking и final snapshot status |
| History | snapshot list | открыть snapshot inline | read-only metadata |
| History Detail | champion/result snapshot | отсутствует | ranking и structure |

- Main показывает active state и next action до вторичных действий.
- Draft сохраняет видимый summary и показывает validation рядом с field.
- Open отделяет roster, connection и management actions.
- Distribution показывает полную identity каждого участника и confirmation перед стартом.
- Running делает Current match визуально сильнейшим элементом.
- Result entry показывает две однозначные identities, outcome и отдельно correction path.
- Finished показывает champion и полную ranking с выходом в Main/History.
- History явно read-only и адаптивно раскрывает snapshot detail.
- Spectator показывает previous/current/next, connection state и не имитирует mutation controls.
- Spectator Running Dashboard размещает completed/current/upcoming в трёх временных lanes слева направо; current lane доминирует по ширине. На compact lanes идут тем же вертикальным read order, а completed card резервирует отдельные области для полной fighter identity, score и result label.

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
