# Задача 54. NumberStepper — добавить числовой контрол

## Статус и этап

✅ Выполнена

- Mode: CODE; будущая реализация — CODE в этом же номере.
- TestGate: NOT_REQUIRED для заявленного visual/theme/layout scope. App state/controllers, вычисления, валидация, сериализация, данные и app routing исключены; при расширении scope классификация пересматривается до кода.
- Stage: DONE.
- Specification:1; plan:0 (черновая последовательность ниже); test scenarios:1, NOT_RUN.
- Реализация не начата; отдельного разрешения на логический gate этой постановкой не получено.

## Цель и контекст

Один результат задачи: **AppNumberStepper**, scope `components/number_stepper`. Добавление/расширение именно одного элемента вместе с его темой, scoped Widgetbook и проверками; не набор новых компонентов экранов.

UI kit содержит mobile pill/desktop canvas, min state и явно восстановленные intermediate/max примеры.

Эталон: [UI kit](../../docs/design/prototype/ui-kit.html#c-stepper), [описание и ограничения](../../docs/design/ui-kit.md), [mapping источников](../../docs/design/prototype/ui-kit-mapping.json). Уже реализованная основа: [foundation](../../docs/design/foundation.md), [manifest](../../docs/design/tokens-manifest.md). Рабочий порядок: [добавление DS-компонента](../../docs/development/design-system-component-workflow.md), [visual workflow](../../docs/development/visual-workflow.md).

## Scope и non-goals

- Входит: Реализовать внешний value/output либо numeric input slot и именованные onDecrease/onIncrease; возможность действия задаётся доступностью callbacks. Типизированная тема содержит плотность, контуры и размеры. Числовые ограничения предоставляет приложение.
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

- Depends on: [40](40-ds-foundation-colors.md), [41](41-ds-foundation-typography.md), [42](42-ds-foundation-spacing.md), [43](43-ds-foundation-shape.md), [44](44-ds-foundation-borders.md), [47](47-ds-foundation-responsive.md), [50](50-ds-component-button.md).
- Product: `lib/presentation/design_system/components/number_stepper/`; собственная тема рядом с визуальным элементом. Чистые tokens не требуют PNG сами по себе.
- Widgetbook: `lib/presentation/widgetbook/components/number_stepper/<named_use_case>/`; каждый именованный use case в своей папке, registry только агрегирует регистрации.
- Tests: `test/presentation/design_system/components/number_stepper/`; PNG — `golden/<native-os>/` рядом с визуальным элементом/showcase в lib. Harness/matcher/flutter_test — только test.
- Никакой независимой копии компонента в showcase/golden. Использовать текущую оболочку/registry и existing FoundationScenarioHost там, где он подходит; не создавать новый entrypoint.

## Уточнения и решения

- Пользователь1 ноября2026 запросил постановку: одна задача — один компонент, начиная с foundation.
- Имена Dart API выше — ориентир для постановки; финальный узкий контракт фиксируется по задаче без добавления несвязанных сущностей.
- Статус source/CSS/restored/proposed из UI kit сохраняется. Отметка «предложено» не превращается в утверждённое product state автоматически.
- Смысловые варианты общие для Desktop/Mobile; менять только подтверждённые constraints/density/layout через theme. Текст и выбор конкретной иконки — данные, не новый компонент.

## Acceptance Criteria

- [x] AC-54.1: AppNumberStepper реализован/расширен в указанном scope; нет параллельной копии уже существующей сущности, ссылку на HTML-эталон можно проследить.
- [x] AC-54.2: все визуальные параметры приходят из собственной темы и общих токенов, API типизирован; raw styling/строковые discriminators/бизнес-правила отсутствуют.
- [x] AC-54.3: именованные Widgetbook use cases показывают реальный элемент: Минимум (decrease=null); середина; максимум (increase=null); обе стороны disabled; multi-digit value; keyboard/focus; mobile/desktop.
- [x] AC-54.4: Widgetbook и golden используют одинаковые fixtures/именованные builders/темы; native baselines созданы/сверены, diffs просмотрены, comparison после update выполнен без update.
- [x] AC-54.5: проверены constraints, значимые states, локализованные labels/semantics и content limits; совпадение visual identity Desktop/Mobile подтверждено, отклонения записаны.
- [x] AC-54.6: manifest/owning docs/scenario registrations актуальны; analyze/tests/architecture checks по impact PASS либо честный blocker с NOT_RUN. Результат показан пользователю.

## Ошибки и крайние случаи

Не выполнять FT validation, clamp, расчёт победителя или value+1 в DS. Не утверждать FT10 как новый предел продукта. Если scope расширится на вычисления/валидацию, пересмотреть TestGate до реализации логики.

Для любой интерактивности отдельно проверить доступный/недоступный callback, pointer/keyboard и focus; требования применяются только к реально поддерживаемому контракту. Не создавать декартов продукт всех props/knobs.

## Test Scenarios

| Сценарий | Критерии | Уровень | Ожидаемый результат |
| --- | --- | --- | --- |
| TS-54.1 Основной вид и перечисленные варианты | AC-54.1, AC-54.2, AC-54.3, AC-54.4 | Реальный Widgetbook + shared golden | Source-анатомия/тема сохранена; собственная папка use case; нет UI-копии |
| TS-54.2 Значимые states и делегирование | AC-54.2, AC-54.3, AC-54.5 | Widget/semantics по контракту | Именованные callbacks и ожидаемая доступность; без domain/infrastructure |
| TS-54.3 Длинный контент/ограничения | AC-54.3, AC-54.5 | Render390×844,1440×900 и обоснованные boundary widths | Нет неожиданных overflow/clipping; прокрутка там, где она часть контракта |
| TS-54.4 Изменение темы/общего токена | AC-54.2, AC-54.4 | Golden затронутых потребителей | Оформление обновляется через theme; source/proposed различия задокументированы |
| TS-54.5 Native comparison | AC-54.4, AC-54.6 | Flutter comparison текущей ОС | Bundled fonts, DPR1, ru/direction/text scale/animation phase фиксированы; missing baseline — ошибка |

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

### План54

Актуальный source отменяет старую desktop canvas: controls одинаковые56/48 FT или56/32 input. AppNumberStepper.output/input принимает внешний output/controller, callbacks доступности и localized action labels. Никаких numeric limits/calculations/validation. Label может переноситься по local constraint330 как в source, сам stepper не меняется от viewport. Native callbacks/typing/null/keyboard/theme/scaled и source min/mid/max+adaptation обоих видов. Visual NOT_REQUIRED.

### Реализация54 —7 ноября2026

Prompt пользователя (дословно):

> продолжи

AppNumberStepper.output/input реализован с внешним value/controller и nullable onDecrease/onIncrease, onChanged/onSubmitted. Геометрия контролов одинакова mobile/desktop56/48/32, local label layout330 сохраняет источник. Доступность и пределы не вычисляются production компонентом. Собственная runtime тема и AppStepperMetrics, shared fixtures/Widgetbook. Source12/12 PASS после update и обычного comparison; native3 tests PASS без update, включая keyboard intents/typing/null и одинаковые размеры. Overlay просмотрены. Numeric slot сравнивается rect/style/baseline; browser Canvas не поддерживает CSS tabular features в measureText. Проверка document.fonts использует явный font string, потому что shorthand пуст при tabular-nums. Analyzer no issues, architecture189 files PASS, engine37 PASS. MacOS Widgetbook перезапущен; другие ОС NOT_RUN. Итог текущей итерации: выполнено.

### Высота в Widgetbook viewport
Prompt пользователя (дословно):
> степпер и choice в виджет буке отображаются так. Нужно либо задать высоту компонента либо ограничить высоту в useCase смотря как правльней будет по лучшим практикам

Stage IMPLEMENTING; TestGate NOT_REQUIRED: layout-only. Проверить format/score через настоящий Mobile/Desktop viewport; использовать общий ComponentPreview из53 и natural contentHeightFactor для output Center. Размер кнопок56 не меняется, фиксированная высота use case не вводится; source/goldens сохранить.

Stage DONE. RED format/Mobile844px вместо56px воспроизведён. Output Center использует heightFactor из WidgetTheme; format/score use cases используют общий ComponentPreview/Align. Root natural height56px при full viewport, в узких constraints label корректно добавляет строку сверху; высота капсулы всегда56px при обычном шрифте. Native goldens Stepper сохранены без update, source comparison PASS без update.

Проверки:2 real Workbench viewport tests PASS (segmented+stepper, оба presets; stepper format/score). Component suite8 PASS (Stepper3+Segmented5) с ordinary goldens. В общем прогоне каталог101 и остальные bootstrap tests прошли, но одна новая assertion ошибочно требовала56px от всего narrow block с label; исправлена на высоту капсулы, component suite повторно GREEN. Analyzer PASS, architecture326 файлов PASS, rules/diff PASS. Native Widgetbook перезапущен, Stepper/format выбран через UI, Mobile390×844 включён; визуально подтверждён обычный горизонтальный control вместо растянутой капсулы. No push.
