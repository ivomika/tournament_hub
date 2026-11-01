# Задача 40. Foundation Colors — согласовать палитру приложения с UI kit

## Статус и этап

🚧 В работе

- Mode: CODE.
- TestGate: NOT_REQUIRED для заявленного visual/theme/layout scope. App state/controllers, вычисления, валидация, сериализация, данные и app routing исключены; при расширении scope классификация пересматривается до кода.
- Stage: DISCOVERY.
- Specification:1; plan:0 (черновая последовательность ниже); test scenarios:1, NOT_RUN.
- Реализация не начата; отдельного разрешения на логический gate этой постановкой не получено.

## Цель и контекст

Один результат задачи: **AppColors / ColorPrimitives**, scope `foundation/colors`. Добавление/расширение именно одного элемента вместе с его темой, scoped Widgetbook и проверками; не набор новых компонентов экранов.

Уже реализованы ColorPrimitives (66 const значений), AppColors.dark, PaletteTheme/ColorPalette и два use case: Primitive scales / Dark palette. Повторная реализация с нуля не нужна.

Эталон: [UI kit](../../docs/design/prototype/ui-kit.html#colors), [описание и ограничения](../../docs/design/ui-kit.md), [mapping источников](../../docs/design/prototype/ui-kit-mapping.json). Уже реализованная основа: [foundation](../../docs/design/foundation.md), [manifest](../../docs/design/tokens-manifest.md). Рабочий порядок: [добавление DS-компонента](../../docs/development/design-system-component-workflow.md), [visual workflow](../../docs/development/visual-workflow.md).

## Scope и non-goals

- Входит: Расширить существующий color foundation только отсутствующими primitive/semantic ролями UI kit: character tones, fill/feedback/interaction по необходимости. Составить сверку current → UI kit → решение; не удалять используемые success/warning/information роли только из-за отсутствия HTML-примера. Обновить manifest и существующие color use cases.
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

- Depends on: нет; существующий foundation задачи36 — baseline.
- Product: `lib/presentation/design_system/foundation/colors/`; собственная тема рядом с визуальным элементом. Чистые tokens не требуют PNG сами по себе.
- Widgetbook: `lib/presentation/widgetbook/foundation/colors/<named_use_case>/`; каждый именованный use case в своей папке, registry только агрегирует регистрации.
- Tests: `test/presentation/design_system/foundation/colors/`; PNG — `golden/<native-os>/` рядом с визуальным элементом/showcase в lib. Harness/matcher/flutter_test — только test.
- Никакой независимой копии компонента в showcase/golden. Использовать текущую оболочку/registry и existing FoundationScenarioHost там, где он подходит; не создавать новый entrypoint.

## Уточнения и решения

- Пользователь1 ноября2026 запросил постановку: одна задача — один компонент, начиная с foundation.
- Имена Dart API выше — ориентир для постановки; финальный узкий контракт фиксируется по задаче без добавления несвязанных сущностей.
- Статус source/CSS/restored/proposed из UI kit сохраняется. Отметка «предложено» не превращается в утверждённое product state автоматически.
- Не менять палитру молча и не вводить light theme. Техническая сверка не утверждает новые бизнес-статусы.

## Acceptance Criteria

- [ ] AC-40.1: AppColors / ColorPrimitives реализован/расширен в указанном scope; нет параллельной копии уже существующей сущности, ссылку на HTML-эталон можно проследить.
- [ ] AC-40.2: все визуальные параметры приходят из собственной темы и общих токенов, API типизирован; raw styling/строковые discriminators/бизнес-правила отсутствуют.
- [ ] AC-40.3: именованные Widgetbook use cases показывают реальный элемент: Primitive scales; Dark palette; пары surface/content; hover/pressed/focus/disabled; character tones; отрицательное действие.
- [ ] AC-40.4: Widgetbook и golden используют одинаковые fixtures/именованные builders/темы; native baselines созданы/сверены, diffs просмотрены, comparison после update выполнен без update.
- [ ] AC-40.5: проверены constraints, значимые states, локализованные labels/semantics и content limits; совпадение visual identity Desktop/Mobile подтверждено, отклонения записаны.
- [ ] AC-40.6: manifest/owning docs/scenario registrations актуальны; analyze/tests/architecture checks по impact PASS либо честный blocker с NOT_RUN. Результат показан пользователю.

## Ошибки и крайние случаи

Контраст text/background и onAccent; одинаковое значение с разными ролями; pressed/focus не становятся новой primitive шкалой. В HTML hover Primary использует focus #FFE199, в AppColors accentHovered — gold300 #F8D576; disabledContent также отличается. Решение о сохранении/изменении роли должно быть явно записано до реализации.

Для любой интерактивности отдельно проверить доступный/недоступный callback, pointer/keyboard и focus; требования применяются только к реально поддерживаемому контракту. Не создавать декартов продукт всех props/knobs.

## Test Scenarios

| Сценарий | Критерии | Уровень | Ожидаемый результат |
| --- | --- | --- | --- |
| TS-40.1 Основной вид и перечисленные варианты | AC-40.1, AC-40.2, AC-40.3, AC-40.4 | Реальный Widgetbook + shared golden | Source-анатомия/тема сохранена; собственная папка use case; нет UI-копии |
| TS-40.2 Значимые states и делегирование | AC-40.2, AC-40.3, AC-40.5 | Widget/semantics по контракту | Именованные callbacks и ожидаемая доступность; без domain/infrastructure |
| TS-40.3 Длинный контент/ограничения | AC-40.3, AC-40.5 | Render390×844,1440×900 и обоснованные boundary widths | Нет неожиданных overflow/clipping; прокрутка там, где она часть контракта |
| TS-40.4 Изменение темы/общего токена | AC-40.2, AC-40.4 | Golden затронутых потребителей | Оформление обновляется через theme; source/proposed различия задокументированы |
| TS-40.5 Native comparison | AC-40.4, AC-40.6 | Flutter comparison текущей ОС | Bundled fonts, DPR1, ru/direction/text scale/animation phase фиксированы; missing baseline — ошибка |

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

До изменения baseline разрешить явно перечисленные расхождения foundation/UI kit и зафиксировать выбранные роли; DISCOVERY не означает разрешение молча заменить прежний foundation.

## Changelog

### Итерация1 — постановка,1 ноября2026

**Prompt пользователя (дословно)**

> выглядит лучше. Добавь задачи на добавление каждого копонента в дизайн систему приложения. Перед добавлением прочитай правила проекта и как правильно добовлять компоненты в дизайн систему и widgetbook. Одна задача - один компонент начиная с foundation

**Изменения и проверки**

- Прочитаны core/Flutter rules, canonical workflow, проектные документы о DS/Widgetbook/golden, существующие AppFoundation/AppColors/AppTypography/FoundationLayout/registry/fixtures; изучены официальные Widgetbook Use-cases/Knobs/Golden и Flutter theming.
- Создана отдельная карточка одного элемента; отмечены зависимости, source anchor, significant states, границы и условия приёмки. Только metadata/docs; runtime-папки не созданы, Flutter tests не запускались.
- Проверка постановки: сквозной реестр1–71 без повторов;32 карточки покрывают9 foundation scopes и все23 семейства UI kit; зависимости без циклов;412 локальных ссылок существуют; обязательные секции и AC refs присутствуют. `node tools/check_rules.cjs` и `git diff --check` — PASS. Это проверки metadata, а не запуск будущих Flutter tests.

## Final Verification

- [ ] Все AC подтверждены при реализации; тесты фактически запущены.
- [ ] Theme/scenarios/goldens/docs согласованы, визуальный результат показан.
- [ ] Нет бизнес-логики/запрещённых dependencies/raw styling.

## Итог

Постановка создана; 🟣. Реализация и выполнение Flutter-проверок не начаты.


### Уточнение пользователя

> воспринимаем текущие компоненты в коде как legacy и спокойно переделываем

UI kit принят целевым визуальным ориентиром; существующие реализации допустимо переработать. Перед переносом значений сохраняются визуальные проверки и история задачи.


### Начало реализации

> приступай

Задача переведена в работу. Flutter SDK доступен с расширенными правами: Flutter 3.47.0 / Dart 3.13.0; это отличается от указанного в visual workflow Flutter 3.47.1 / Dart 3.13.1. Реализация и golden comparison ещё не выполнены.


### Проверка baseline

> продолжай

На macOS запущен `flutter test --no-pub test/presentation/foundation_preview_test.dart` с Flutter 3.47.0 / Dart 3.13.0: 8 проверок прошли, 6 golden comparison завершились ошибкой из-за отсутствующих macOS baseline. В репозитории доступны только Windows PNG; копировать их в macOS запрещено. Локальный тег Flutter 3.47.1 существует, но активный SDK — 3.47.0. Изменения продукта и golden не выполнялись.
