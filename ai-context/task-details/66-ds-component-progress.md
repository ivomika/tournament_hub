# Задача 66. ProgressIndicator — добавить исходный индикатор загрузки

## Статус и этап

✅ Выполнена

- Mode: CODE; будущая реализация — CODE в этом же номере.
- TestGate: NOT_REQUIRED для заявленного visual/theme/layout scope. App state/controllers, вычисления, валидация, сериализация, данные и app routing исключены; при расширении scope классификация пересматривается до кода.
- Stage: DONE.
- Specification:3; plan:0 (черновая последовательность ниже); test scenarios:1, NOT_RUN.
- Реализация не начата; отдельного разрешения на логический gate этой постановкой не получено.

## Цель и контекст

Один результат задачи: **AppProgressIndicator**, scope `components/progress_indicator`. Добавление/расширение именно одного элемента вместе с его темой, scoped Widgetbook и проверками; не набор новых компонентов экранов.

Текущий HTML waveform признан пользователем неверным эталоном. В приложении использовать штатный Material3 ProgressIndicator с оформлением из FlutterTheme/ProgressIndicatorThemeData. Кастомную геометрию/анимацию HTML не переносить. Это уточнение отменяет предыдущее решение о кастомном AppProgressIndicator. AppProgressIndicator может оставаться тонким тематизированным facade, но не собственным painter.

Эталон: [UI kit](../../docs/design/prototype/ui-kit.html#c-progress), [описание и ограничения](../../docs/design/ui-kit.md), [mapping источников](../../docs/design/prototype/ui-kit-mapping.json). Уже реализованная основа: [foundation](../../docs/design/foundation.md), [manifest](../../docs/design/tokens-manifest.md). Рабочий порядок: [добавление DS-компонента](../../docs/development/design-system-component-workflow.md), [visual workflow](../../docs/development/visual-workflow.md).

## Scope и non-goals

- Входит: Штатный Material3 progress indicator; параметры через FlutterTheme/ProgressIndicatorThemeData, локализованный semantics label и deterministic capture. Собственный waveform/painter не реализовывать.
- Входит: собственная типизированная тема, trace к foundation tokens и обновление manifest/docs по затронутым решениям.
- Входит: реальные use cases в Widgetbook, shared deterministic scenarios и executable native golden visual samples; meaningful interaction/semantics tests по риску.
- Не входит: перенос экранов, изменение HTML UI kit/прототипов, бизнес-правила, use cases, DI/сеть/БД, новая локаль, новая светлая тема, Widgetbook Cloud/generator или обновление SDK.
- Не создавать будущие runtime/Widgetbook-папки сейчас; эта карточка — постановка.

## Применимые правила

- Core: R-001 — одна ответственность и композиция; R-002 — русские owning docs; R-004 — enum/sealed/value objects для вариантов/состояний, без строковых lookup; R-007 — соразмерные фактические проверки, честный NOT_RUN.
- Flutter: R-003.a/b — presentation boundaries и делегирование без use cases в widget; R-003.c — внешние механики/пакеты изолированы и обоснованы; R-003.d — отдельная папка и типизированная тема, всё оформление (включая0) из токенов; R-003.e — только package/dart directives.
- R-003.f — screen не реализуется, но DS не импортирует screens/controllers/Widgetbook; будущие screens используют этот элемент.
- R-005 — UI/semantics/formatted text через intl; пользовательские данные не переводятся; metadata Widgetbook не подменяют локализацию.
- R-006.a/b — private widgets вместо Widget helpers; именованные callbacks, недоступный callback=null.
- R-006.c/d — scoped use cases, общие fixtures/builders, свой comparison golden текущей native ОС; knobs не заменяют fixed scenarios.
- Conditional scan: иных conditional rules в router нет. Перед будущей реализацией перечитать актуальные правила и зависимости.

## Зависимости и архитектурные границы

- Depends on: [40](40-ds-foundation-colors.md), [42](42-ds-foundation-spacing.md), [46](46-ds-foundation-motion.md), [47](47-ds-foundation-responsive.md).
- Product: `lib/presentation/design_system/components/progress_indicator/`; собственная тема рядом с визуальным элементом. Чистые tokens не требуют PNG сами по себе.
- Widgetbook: `lib/presentation/widgetbook/components/progress_indicator/<named_use_case>/`; каждый именованный use case в своей папке, registry только агрегирует регистрации.
- Tests: `test/presentation/design_system/components/progress_indicator/`; PNG — `golden/<native-os>/` рядом с визуальным элементом/showcase в lib. Harness/matcher/flutter_test — только test.
- Никакой независимой копии компонента в showcase/golden. Использовать текущую оболочку/registry и existing FoundationScenarioHost там, где он подходит; не создавать новый entrypoint.

## Уточнения и решения

- Пользователь1 ноября2026 запросил постановку: одна задача — один компонент, начиная с foundation.
- Имена Dart API выше — ориентир для постановки; финальный узкий контракт фиксируется по задаче без добавления несвязанных сущностей.
- Статус source/CSS/restored/proposed из UI kit сохраняется. Отметка «предложено» не превращается в утверждённое product state автоматически.
- Смысловые варианты общие для Desktop/Mobile; менять только подтверждённые constraints/density/layout через theme. Текст и выбор конкретной иконки — данные, не новый компонент.

## Acceptance Criteria

- [x] AC-66.1: AppProgressIndicator реализован/расширен в указанном scope; нет параллельной копии уже существующей сущности, ссылку на HTML-эталон можно проследить.
- [x] AC-66.2: все визуальные параметры приходят из собственной темы и общих токенов, API типизирован; raw styling/строковые discriminators/бизнес-правила отсутствуют.
- [x] AC-66.3: именованные Widgetbook use cases показывают реальный элемент: Indeterminate fixed phase start/mid; reduced motion; разные доступные constraints и label.
- [x] AC-66.4: Widgetbook и golden используют одинаковые fixtures/именованные builders/темы; native baselines созданы/сверены, diffs просмотрены, comparison после update выполнен без update.
- [x] AC-66.5: проверены constraints, значимые states, локализованные labels/semantics и content limits; совпадение visual identity Desktop/Mobile подтверждено, отклонения записаны.
- [x] AC-66.6: manifest/owning docs/scenario registrations актуальны; analyze/tests/architecture checks по impact PASS либо честный blocker с NOT_RUN. Результат показан пользователю.

## Ошибки и крайние случаи

Не выдумывать процент и не ждать сеть/таймер в golden. Не выполнять загрузку/раздачу. Определённая длительность business operation не является motion token.

Для любой интерактивности отдельно проверить доступный/недоступный callback, pointer/keyboard и focus; требования применяются только к реально поддерживаемому контракту. Не создавать декартов продукт всех props/knobs.

## Test Scenarios

| Сценарий | Критерии | Уровень | Ожидаемый результат |
| --- | --- | --- | --- |
| TS-66.1 Основной вид и перечисленные варианты | AC-66.1, AC-66.2, AC-66.3, AC-66.4 | Реальный Widgetbook + shared golden | Source-анатомия/тема сохранена; собственная папка use case; нет UI-копии |
| TS-66.2 Значимые states и делегирование | AC-66.2, AC-66.3, AC-66.5 | Widget/semantics по контракту | Именованные callbacks и ожидаемая доступность; без domain/infrastructure |
| TS-66.3 Длинный контент/ограничения | AC-66.3, AC-66.5 | Render390×844,1440×900 и обоснованные boundary widths | Нет неожиданных overflow/clipping; прокрутка там, где она часть контракта |
| TS-66.4 Изменение темы/общего токена | AC-66.2, AC-66.4 | Golden затронутых потребителей | Оформление обновляется через theme; source/proposed различия задокументированы |
| TS-66.5 Native comparison | AC-66.4, AC-66.6 | Flutter comparison текущей ОС | Bundled fonts, DPR1, ru/direction/text scale/animation phase фиксированы; missing baseline — ошибка |

## Предварительная последовательность

Это набросок постановки, а не начатый implementation plan.

1. Перечитать текущие rules/зависимости, сверить UI kit с Flutter baseline; разрешить отмеченные неоднозначности и зафиксировать узкий контракт/сценарии.
2. Дополнить существующий foundation либо собственную theme; реализовать один элемент из согласованных частей, без screen/business wiring.
3. Подключить scoped Widgetbook use cases и shared scenarios; добавить соответствующие comparison tests и native PNG.
4. Выполнить релевантные checks, посмотреть рендер/diff, повторить comparison без update; обновить manifest/docs и карточку.

## Проверки при реализации

Из `apps/tournament_app`: `flutter analyze --no-pub`, targeted `flutter test --no-pub` для затронутого элемента/потребителей. `--update-goldens` — только намеренное обновление затронутого native set с последующим обычным comparison. Из корня: `make architecture-check` / `make architecture-test` при новых Dart-directives/структуре. Bundled Inter/RobotoCondensed и существующие VisualViewport — baseline.

Невизуальным token/value objects не создавать фиктивный golden: сравниваются реальные visual showcase/потребители. Наборы windows/linux/macos не копировать друг в друга; фиксировать фактическую среду и NOT_RUN других ОС. Новые SDK/packages/генератор не подразумеваются этой задачей.

## Test Evidence и Approval

- NOT_RUN: runtime-код, tests и baselines не изменялись; задача только поставлена.
- Для visual scope TestGate approval не требуется; запуск реализации — отдельный запрос. Если появится логическая часть, пройти workflow REQUIRED для неё до production изменения.
- Обязательная golden-проверка R-006.c сохраняется независимо от отсутствия логического gate.

## Открытые решения

Финальные имена API и способы передачи темы уточняются при реализации. Если обнаружится неоднозначность поведения, не угадывать её: записать вопрос и остановить только зависимую часть по workflow.

## Changelog

### Итерация1 — постановка,1 ноября2026

**Prompt пользователя (дословно)**

> выглядит лучше. Добавь задачи на добавление каждого копонента в дизайн систему приложения. Перед добавлением прочитай правила проекта и как правильно добовлять компоненты в дизайн систему и widgetbook. Одна задача - один компонент начиная с foundation

**Изменения и проверки**

- Прочитаны core/Flutter rules, canonical workflow, проектные документы о DS/Widgetbook/golden, существующие AppFoundation/AppColors/AppTypography/FoundationLayout/registry/fixtures; изучены официальные Widgetbook Use-cases/Knobs/Golden и Flutter theming.
- Создана отдельная карточка одного элемента; отмечены зависимости, source anchor, significant states, границы и условия приёмки. Только metadata/docs; runtime-папки не созданы, Flutter tests не запускались.
- Проверка постановки: сквозной реестр1–71 без повторов;32 карточки покрывают9 foundation scopes и все23 семейства UI kit; зависимости без циклов;412 локальных ссылок существуют; обязательные секции и AC refs присутствуют. `node tools/check_rules.cjs` и `git diff --check` — PASS. Это проверки metadata, а не запуск будущих Flutter tests.

## Final Verification

- [x] Все AC подтверждены при реализации; тесты фактически запущены.
- [x] Theme/scenarios/goldens/docs согласованы, визуальный результат показан.
- [x] Нет бизнес-логики/запрещённых dependencies/raw styling.

## Итог

Текущий результат: линейный волнистый M3 Expressive progress с runtime темой, accessibility и проверенными native эталонами. Подробности — в завершающей итерации.


### Уточнение7 ноября2026 — кастомный индикатор

Prompt пользователя (дословно):

> прогресс индикатор не копирует material 3 после переноса это будет кастомный индикатор

Spec v2: сохранить собственную waveform-анимацию/геометрию прототипа и normal/reduced-motion states как кастомный компонент. Material3 не является источником обязательной геометрии/таймингов и не требуется pixel-match с его индикаторами. Реализация Flutter не возобновлялась; статус остаётся planning-only. Проверка: согласованность с текущим SVG/CSS fixture и owning docs, rules/diff.


### Уточнение7 ноября2026 — отмена кастомного индикатора

Prompt пользователя (дословно):

> еще одно уточнение. ProgressIndicator в html не верный и кастомный. А в приложении должен использоваться material3 прогресс индикатор.
Второе давай закомитим изменения ui kit и перенесем foundation в flutter проект. Главное условие переноса foundation, будущие виджеты не должны использовать константы, а должны использовать стандартную тему или свою тему. Использовать в виджетах заготовленные константы тупиковая ветвь. Все должно реагировать на изменения основной темы. Поэтому флоу такой: promitive const -> FlutterTheme -> WidgetTheme -> Widget. я запрещаю использовать константные TextStyle или Colors внутри итоговых виджетах (Text( style: const bodySmall)). Это решение необходимо занести в тему и необходимо добавить проверку чтобы примитивы не попадали в production код

Spec v3: для приложения штатный Material3 ProgressIndicator, HTML waveform неверен и не является источником геометрии/анимации. Тема следует primitive const → FlutterTheme → WidgetTheme → Widget. Предыдущее custom-решение отменено пользователем. Flutter-реализация не начата.

### Новая очередь переноса после RosterRow

Prompt пользователя (дословно):

> выглядит хорошо. Обнови задачи по реализации компонентов, посмотри что уже выполнено, а что еще требует реализации и реализуй каждый компонент по новому flow делая коммит для каждого компонента без push

Обязательный flow текущей итерации: сверить существующий runtime и итоговый CSS UI kit → определить реальные состояния/адаптацию и контрольные узлы → typed runtime WidgetTheme без primitives в consumers → scoped Widgetbook/shared fixture → декларация общего comparison pipeline → source/native/overlay/diff и native goldens → осмотр и исправление внутренних различий → повтор без update, tests/analyzer/architecture → отдельный локальный коммит компонента без push. Существующая реализация не дублируется. Наличие tokens в72 не равно выполнению всех старых AC foundation.
Факт сверки: отдельного production компонента и comparison declaration пока нет; задача остаётся в очереди реализации.
Уточнение источника: переносится штатный Material3 ProgressIndicator из основной темы. Ошибочная HTML waveform не является эталоном реализации; сравнивать её как требуемую форму запрещено.

### План66

Тонкий AppProgressIndicator facade над штатным CircularProgressIndicator M3. Все параметры стандартного SDK берутся ProgressIndicatorThemeData текущей темы (year2023:false уже foundation). Нет painter/геометрии HTML. Generic comparison показывает утверждённый mismatch source waveform через expected finding root.rect.width и явную note, а не совпадение. Native deterministic start/mid/reduced+replacement theme, shared fixtures. Visual NOT_REQUIRED.

### Реализация66 —7 ноября2026

Prompt пользователя (дословно):

> продолжи

Прямое требование Material3 имеет приоритет над старым HTML waveform: AppProgressIndicator — стандартный CircularProgressIndicator и semantics. Оформление через текущую ProgressIndicatorThemeData, никакой собственной геометрии. Shared animated/reduced/fixed fixtures. Общий source отчёт2 expected root.width mismatches verified; это утверждённое отличие, не совпадение (явная note). Native baseline собственных start/mid/reduced/replacement phases, test PASS повторно без update; изображения просмотрены. Analyzer no issues, architecture268 files PASS, macOS hot restart выполнен. Другие ОС NOT_RUN. Итог текущей итерации: выполнено.

### Линейный волнистый индикатор
Prompt пользователя (дословно):
> отлично теперь вместо circuler progress должен быть в линию и волнистый

Stage IMPLEMENTING; TestGate NOT_REQUIRED: visual animation adapter, без прикладной логики. Установленный SDK не содержит linear wavy shape; используем isolated presentation adapter к реализации M3 Expressive, тема и geometry из main ThemeData/WidgetTheme. План: подключить пакет, заменить runtime и Motion preview на единый AppProgressIndicator, обновить native phases/theme/source reports, проверить reduced motion и каталог. Push запрещён.

### Завершение linear wavy
Stage DONE. AppProgressIndicator — linear wavy adapter к m3e_progress_indicator0.0.3 (MIT), совместимому с текущим Flutter. Внешние типы не выходят в контракт; собственный painter не добавлялся. Standard SDK year2023:false не даёт волну; это явно отражено в docs/design/progress-indicator.md.

Main ProgressIndicatorThemeData colors + AppProgressMetrics(width240,height10,stroke4,track4,wavelength20,speed20), gap/stop AppSpacing4 → WidgetTheme → adapter. Reduced motion статичен, семантика локализованной загрузки без ложного процента; динамическое включение reduced проверяется без пересоздания внешнего компонента. Foundation/Motion использует тот же компонент.

8 tests PASS без update: progress phase/theme/reduced, Motion и bootstrap (все101 use cases); intentional6 native snapshots обновлены и затем сравнены обычным запуском, reduced snapshot одинаков после1секунды. Analyzer PASS; architecture325 файлов PASS; rules/diff PASS. Source comparison2/2 PASS после update и без update; ожидаемое отличие root.height24/10 записано явно. Финальные mid/reduced PNG просмотрены: реальная волна по заданной ширине, track gap/end stop. Изначально проверенный иной adapter оставлял только80px графики внутри240px; заменён до завершения, artifact того варианта не принят.

Документы: docs/design/progress-indicator.md, manifest, Widgetbook. Native macOS, другие ОС NOT_RUN. Локальный коммит без push.

### Замедление волны
Prompt пользователя (дословно):
> быстро как то

На уточнение «Ты про анимацию индикатора — волна слишком быстро движется?» ответ:
> да

Stage IMPLEMENTING; TestGate NOT_REQUIRED: visual motion tuning. WaveSpeed20→10px/s через primitive/main theme; цикл волны20px теперь2секунды. Проход активного участка1750ms принадлежит библиотеке и отдельно не настраивается её API; глобальный timeDilation не применяется. Проверить затронутые phase goldens и hot restart.

Stage DONE. Скорость волны10px/s (цикл2секунды вместо1). Обновлены только2 mid snapshots, изображение просмотрено; обычный suite4 PASS без update, architecture325 файлов PASS, diff PASS. Source fixed/reduced capture не меняется, повторное обновление report не требуется. Локальный коммит без push.
