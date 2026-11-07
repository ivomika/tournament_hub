# Задача 68. BracketNode — добавить узел турнирной сетки

## Статус и этап

✅ Выполнена

- Mode: CODE; будущая реализация — CODE в этом же номере.
- TestGate: NOT_REQUIRED для заявленного visual/theme/layout scope. App state/controllers, вычисления, валидация, сериализация, данные и app routing исключены; при расширении scope классификация пересматривается до кода.
- Stage: DONE.
- Specification:1; plan:0 (черновая последовательность ниже); test scenarios:1, NOT_RUN.
- Реализация не начата; отдельного разрешения на логический gate этой постановкой не получено.

## Цель и контекст

Один результат задачи: **AppBracketNode**, scope `widgets/bracket_node`. Добавление/расширение именно одного элемента вместе с его темой, scoped Widgetbook и проверками; не набор новых компонентов экранов.

Ready/current/pending узлы; connectors, камера и граф относятся к BracketMap layout.

Эталон: [UI kit](../../docs/design/prototype/ui-kit.html#c-bracket), [описание и ограничения](../../docs/design/ui-kit.md), [mapping источников](../../docs/design/prototype/ui-kit-mapping.json). Уже реализованная основа: [foundation](../../docs/design/foundation.md), [manifest](../../docs/design/tokens-manifest.md). Рабочий порядок: [добавление DS-компонента](../../docs/development/design-system-component-workflow.md), [visual workflow](../../docs/development/visual-workflow.md).

## Scope и non-goals

- Входит: Один узел с типизированным visual state, label и двумя participant/placeholder slots. Получает готовые display data и callback; тема содержит compact node styling.
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

- Depends on: [40](40-ds-foundation-colors.md), [41](41-ds-foundation-typography.md), [42](42-ds-foundation-spacing.md), [43](43-ds-foundation-shape.md), [44](44-ds-foundation-borders.md), [47](47-ds-foundation-responsive.md), [50](50-ds-component-button.md), [57](57-ds-component-avatar.md), [58](58-ds-widget-identity.md).
- Product: `lib/presentation/design_system/widgets/bracket_node/`; собственная тема рядом с визуальным элементом. Чистые tokens не требуют PNG сами по себе.
- Widgetbook: `lib/presentation/widgetbook/widgets/bracket_node/<named_use_case>/`; каждый именованный use case в своей папке, registry только агрегирует регистрации.
- Tests: `test/presentation/design_system/widgets/bracket_node/`; PNG — `golden/<native-os>/` рядом с визуальным элементом/showcase в lib. Harness/matcher/flutter_test — только test.
- Никакой независимой копии компонента в showcase/golden. Использовать текущую оболочку/registry и existing FoundationScenarioHost там, где он подходит; не создавать новый entrypoint.

## Уточнения и решения

- Пользователь1 ноября2026 запросил постановку: одна задача — один компонент, начиная с foundation.
- Имена Dart API выше — ориентир для постановки; финальный узкий контракт фиксируется по задаче без добавления несвязанных сущностей.
- Статус source/CSS/restored/proposed из UI kit сохраняется. Отметка «предложено» не превращается в утверждённое product state автоматически.
- Смысловые варианты общие для Desktop/Mobile; менять только подтверждённые constraints/density/layout через theme. Текст и выбор конкретной иконки — данные, не новый компонент.

## Acceptance Criteria

- [x] AC-68.1: AppBracketNode реализован/расширен в указанном scope; нет параллельной копии уже существующей сущности, ссылку на HTML-эталон можно проследить.
- [x] AC-68.2: все визуальные параметры приходят из собственной темы и общих токенов, API типизирован; raw styling/строковые discriminators/бизнес-правила отсутствуют.
- [x] AC-68.3: именованные Widgetbook use cases показывают реальный элемент: Ready; current; pending; длинные участники; focus/keyboard; disabled action если предусмотрен контрактом.
- [x] AC-68.4: Widgetbook и golden используют одинаковые fixtures/именованные builders/темы; native baselines созданы/сверены, diffs просмотрены, comparison после update выполнен без update.
- [x] AC-68.5: проверены constraints, значимые states, локализованные labels/semantics и content limits; совпадение visual identity Desktop/Mobile подтверждено, отклонения записаны.
- [x] AC-68.6: manifest/owning docs/scenario registrations актуальны; analyze/tests/architecture checks по impact PASS либо честный blocker с NOT_RUN. Результат показан пользователю.

## Ошибки и крайние случаи

Не строить граф и не вычислять победителей/раунды. Не добавлять finished/technical как будто они уже представлены: сначала отдельный design state. Pan/zoom и карта не входят.

Для любой интерактивности отдельно проверить доступный/недоступный callback, pointer/keyboard и focus; требования применяются только к реально поддерживаемому контракту. Не создавать декартов продукт всех props/knobs.

## Test Scenarios

| Сценарий | Критерии | Уровень | Ожидаемый результат |
| --- | --- | --- | --- |
| TS-68.1 Основной вид и перечисленные варианты | AC-68.1, AC-68.2, AC-68.3, AC-68.4 | Реальный Widgetbook + shared golden | Source-анатомия/тема сохранена; собственная папка use case; нет UI-копии |
| TS-68.2 Значимые states и делегирование | AC-68.2, AC-68.3, AC-68.5 | Widget/semantics по контракту | Именованные callbacks и ожидаемая доступность; без domain/infrastructure |
| TS-68.3 Длинный контент/ограничения | AC-68.3, AC-68.5 | Render390×844,1440×900 и обоснованные boundary widths | Нет неожиданных overflow/clipping; прокрутка там, где она часть контракта |
| TS-68.4 Изменение темы/общего токена | AC-68.2, AC-68.4 | Golden затронутых потребителей | Оформление обновляется через theme; source/proposed различия задокументированы |
| TS-68.5 Native comparison | AC-68.4, AC-68.6 | Flutter comparison текущей ОС | Bundled fonts, DPR1, ru/direction/text scale/animation phase фиксированы; missing baseline — ошибка |

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

Постановка создана; 🟣. Реализация и выполнение Flutter-проверок не начаты.

### Новая очередь переноса после RosterRow

Prompt пользователя (дословно):

> выглядит хорошо. Обнови задачи по реализации компонентов, посмотри что уже выполнено, а что еще требует реализации и реализуй каждый компонент по новому flow делая коммит для каждого компонента без push

Обязательный flow текущей итерации: сверить существующий runtime и итоговый CSS UI kit → определить реальные состояния/адаптацию и контрольные узлы → typed runtime WidgetTheme без primitives в consumers → scoped Widgetbook/shared fixture → декларация общего comparison pipeline → source/native/overlay/diff и native goldens → осмотр и исправление внутренних различий → повтор без update, tests/analyzer/architecture → отдельный локальный коммит компонента без push. Существующая реализация не дублируется. Наличие tokens в72 не равно выполнению всех старых AC foundation.
Факт сверки: отдельного production компонента и comparison declaration пока нет; задача остаётся в очереди реализации.

### План68

Typed ready/current/pending node, готовые label/two participant-or-placeholder slots, nullable onPressed. Width220/min116/padding12/border1 current2, compact Identity+Avatar28 через runtime override. Source labels/styles measured, native pointer/keyboard/disabled/theme/scaled. Без bracket graph/расчётов. Visual NOT_REQUIRED.

### Реализация68 —7 ноября2026

Prompt пользователя (дословно):

> продолжи

BracketNode ready/current/pending с2 typed slots и nullable action. Identity/Avatar переиспользованы с компактной runtime темой. Source6/6 PASS после update и обычного comparison; controls включают surface/label/avatar/initials/primary/secondary/placeholders. Дополнительные контроли нашли накопленный baseline сдвиг: вместо увеличения допусков сохранены fractional CSS line boxes через runtime fontSize×height×textScaler; геометрия вернулась к.5px. Baseline estimate1.25px указан явно. Overlay просмотрены. Native Bracket+Identity+Table5 tests PASS без update; analyzer no issues, architecture288 files PASS. MacOS hot restart выполнен, другие ОС NOT_RUN. Итог текущей итерации: выполнено.
