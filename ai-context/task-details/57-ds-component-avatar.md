# Задача 57. Avatar — добавить аватар и портрет

## Статус и этап

✅ Выполнена

- Mode: CODE.
- TestGate: NOT_REQUIRED для заявленного visual/theme/layout scope. App state/controllers, вычисления, валидация, сериализация, данные и app routing исключены; при расширении scope классификация пересматривается до кода.
- Stage: DONE.
- Specification:2; plan:1; visual scenarios:2.
- Пользователь разрешил визуальный пилот. TestGate NOT_REQUIRED: чистый visual/theme/layout scope, comparison является тестовым harness, без нового production checker/логики приложения.

## Цель и контекст

Один результат задачи: **AppAvatar**, scope `components/avatar`. Добавление/расширение именно одного элемента вместе с его темой, scoped Widgetbook и проверками; не набор новых компонентов экранов.

Актуальный UI kit после уточнений: размеры28/40/48/64/96/112/128, tile/round, инициалы, без border. Цвет — данные, не самостоятельный компонент.

Эталон: [UI kit](../../docs/design/prototype/ui-kit.html#c-avatar), [описание и ограничения](../../docs/design/ui-kit.md), [mapping источников](../../docs/design/prototype/ui-kit-mapping.json). Уже реализованная основа: [foundation](../../docs/design/foundation.md), [manifest](../../docs/design/tokens-manifest.md). Рабочий порядок: [добавление DS-компонента](../../docs/development/design-system-component-workflow.md), [visual workflow](../../docs/development/visual-workflow.md).

## Scope и non-goals

- Входит: Один Avatar с типизированным size/shape и initials, optional themed foreground; AppAvatarTheme задаёт все параметры. Изображений в актуальном Avatar UI kit нет; image/loading/error API не изобретается.
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

- Depends on: [40](40-ds-foundation-colors.md), [41](41-ds-foundation-typography.md), [43](43-ds-foundation-shape.md), [44](44-ds-foundation-borders.md), [47](47-ds-foundation-responsive.md).
- Product: `lib/presentation/design_system/components/avatar/`; собственная тема рядом с визуальным элементом. Чистые tokens не требуют PNG сами по себе.
- Widgetbook: `lib/presentation/widgetbook/components/avatar/<named_use_case>/`; каждый именованный use case в своей папке, registry только агрегирует регистрации.
- Tests: `test/presentation/design_system/components/avatar/`; PNG — `golden/<native-os>/` рядом с визуальным элементом/showcase в lib. Harness/matcher/flutter_test — только test.
- Никакой независимой копии компонента в showcase/golden. Использовать текущую оболочку/registry и existing FoundationScenarioHost там, где он подходит; не создавать новый entrypoint.

## Уточнения и решения

- Пользователь1 ноября2026 запросил постановку: одна задача — один компонент, начиная с foundation.
- Имена Dart API выше — ориентир для постановки; финальный узкий контракт фиксируется по задаче без добавления несвязанных сущностей.
- Статус source/CSS/restored/proposed из UI kit сохраняется. Отметка «предложено» не превращается в утверждённое product state автоматически.
- Смысловые варианты общие для Desktop/Mobile; менять только подтверждённые constraints/density/layout через theme. Текст и выбор конкретной иконки — данные, не новый компонент.

## Acceptance Criteria

- [x] AC-57.1: AppAvatar реализован/расширен в указанном scope; нет параллельной копии уже существующей сущности, ссылку на HTML-эталон можно проследить.
- [x] AC-57.2: все визуальные параметры приходят из собственной темы и общих токенов, API типизирован; raw styling/строковые discriminators/бизнес-правила отсутствуют.
- [x] AC-57.3: именованные Widgetbook use cases показывают реальный элемент: Все7 размеров, tile/round, нейтральный вид, тематический foreground как данные; пустые/двухбуквенные инициалы. Identity с именем относится к задаче58 и не подменяется заглушкой.
- [x] AC-57.4: Widgetbook и golden используют одинаковые fixtures/именованные builders/темы; native baselines созданы/сверены, diffs просмотрены, comparison после update выполнен без update.
- [x] AC-57.5: проверены constraints, значимые states, локализованные labels/semantics и content limits; совпадение visual identity Desktop/Mobile подтверждено, отклонения записаны.
- [x] AC-57.6: manifest/owning docs/scenario registrations актуальны; analyze/tests/architecture checks по impact PASS либо честный blocker с NOT_RUN. Результат показан пользователю.

## Ошибки и крайние случаи

Не создавать widget для каждого персонажа. Нулевые/длинные инициалы и decorative semantics; поведение загрузки отсутствующего изображения фиксируется перед добавлением image-режима.

Для любой интерактивности отдельно проверить доступный/недоступный callback, pointer/keyboard и focus; требования применяются только к реально поддерживаемому контракту. Не создавать декартов продукт всех props/knobs.

## Test Scenarios

| Сценарий | Критерии | Уровень | Ожидаемый результат |
| --- | --- | --- | --- |
| TS-57.1 Основной вид и перечисленные варианты | AC-57.1, AC-57.2, AC-57.3, AC-57.4 | Реальный Widgetbook + shared golden | Source-анатомия/тема сохранена; собственная папка use case; нет UI-копии |
| TS-57.2 Значимые states и делегирование | AC-57.2, AC-57.3, AC-57.5 | Widget/semantics по контракту | Именованные callbacks и ожидаемая доступность; без domain/infrastructure |
| TS-57.3 Длинный контент/ограничения | AC-57.3, AC-57.5 | Render390×844,1440×900 и обоснованные boundary widths | Нет неожиданных overflow/clipping; прокрутка там, где она часть контракта |
| TS-57.4 Изменение темы/общего токена | AC-57.2, AC-57.4 | Golden затронутых потребителей | Оформление обновляется через theme; source/proposed различия задокументированы |
| TS-57.5 Native comparison | AC-57.4, AC-57.6 | Flutter comparison текущей ОС | Bundled fonts, DPR1, ru/direction/text scale/animation phase фиксированы; missing baseline — ошибка |

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

AppAvatar, runtime theme,8 Widgetbook cases и fixed visual comparison pilot реализованы.28 web/Flutter pairs,17 native goldens и measured JSON/overlay/diff доступны в локальном отчёте. Известный raster edge delta1px для112px явно показан; pixel-perfect не заявлен.

### Визуальный пилот —7 ноября2026

Prompt пользователя (дословно):

> давай попробуем

Контекст: пользователь одобрил начать инструмент сравнения с самостоятельного Avatar после обсуждения зависимостей. План: (1) снять оригинальные14 Avatar samples и computed geometry из исходной страницы UI kit headless Chrome, (2) добавить отсутствующие размерные font/radius значения в runtime foundation и AppAvatar/AppAvatarTheme, (3) shared Widgetbook/scenarios/native goldens, (4) статический локальный отчёт web/Flutter/overlay/diff с измерениями и заведомо смещённым контрольным образцом. Чистый визуальный перенос; test-only capture/comparison harness не является новым production checker. Для будущего общего автоматического инструмента потребуется самостоятельная постановка, если выйдем за pilot harness.

Прочитаны актуальные core/Flutter rules, включая R-003.g, workflow и task57. Других conditional rules нет. Dependencies40/41/43/44/47 удовлетворены runtime foundation задачи72; здесь добавляются только конкретные метрики Avatar. Прямой CUA браузер выключен Work settings; read-only визуальный эталон снимается отдельным headless Chrome с новым tmp profile. UI kit исходник не меняется.

Pilot AC: оригинальные web screenshots и computed metrics;14 matching isolated samples при390/1440 viewport; actual Flutter AppAvatar; current-theme response; no border; статический report со comparison images и контрольным сдвигом; native golden comparison повторяется без update. Glyph antialiasing различается между движками и показывается честно отдельно от geometry.

### Результаты визуального пилота

- Web: исходный UI kit визуально просмотрен через screenshot; измерены computed font/box/radius/colors, затем28 изолированных оригинальных DOM samples сняты headless Chrome156, DPR1, font readiness. Исходные HTML/CSS/JS UI kit не менялись. Второй viewport сначала не перезагружал тот же URL после DOM isolation; capture исправлен на document navigation с отдельным query, полный набор28 подтверждён.
- Flutter: AppAvatar с size/shape, переданными initials/optional themed foreground/semanticsLabel; no image/interactive API. Все метрики идут primitive → AppTheme/AppResponsive/AppAvatarMetrics → AppAvatarTheme → Widget; current Theme replacement проверяет extent/font/radius/colors.7 size use cases и1 data use case используют общую AvatarFixture с goldens.
- Сравнение:28 случаев,14 размеров/форм для390×900 и1440×900. Точно совпали outer bounds, центры text block, font size/weight, color/background, radius и no-border. Layout center tolerance0.01px; baseline≤0.5px (Chrome integer font metrics); glyph raster edge≤1 physical px.24/28 integer ink bounds совпали полностью.112px в обеих формах/viewport имеет Y ink delta1px при baseline Chrome69.5 / Flutter69.671875. Специальные pixel offsets по размеру не добавлялись. Остаток показан в отчёте и не скрывается pixel threshold.
- Проверены CSS half-leading и альтернативные TextHeightBehavior. Последние ухудшили другие размеры и удалены. Runtime тема сохраняет стандартный even leading; существующая геометрия центрирования не подменена ручными смещениями.
- Контроль чувствительности: actual AppAvatar с намеренно ошибочным alignment темы сохраняет контур64×64, но сдвигает букву на5px; test harness обнаружил это и сохранил отдельные overlay/diff. Это fixture, не production state.
- Отчёт визуально просмотрен (top и control), все116 image assets загрузились, horizontal overflow отсутствует. Node scripts — fixed test-only fixture capture/render, не новый общий production checker; отдельного logic gate для visual harness нет по workflow NOT_REQUIRED.

## Финальные проверки пилота

- `flutter test --no-pub --update-goldens test/presentation/design_system/components/avatar/avatar_visual_test.dart` — PASS3,17 macOS native baselines.
- Повтор без update: `flutter test --no-pub test/presentation/design_system/components/avatar/avatar_visual_test.dart test/presentation/foundation_preview_test.dart test/widgetbook_bootstrap_test.dart test/presentation/golden_environment_test.dart test/presentation/design_system/foundation/theme_propagation_test.dart` — PASS28. Прежние foundation PNG не менялись.
- `flutter analyze --no-pub` — PASS, no issues. При расширении data fixture временно добавилась undefined foreground в тестовом вызове; исправлена до последних GREEN.
- `make architecture-test` — PASS49 class-owned/51 architecture/35 theme cases;58 реальных файлов без findings.
- `node --check` обоих capture/report scripts, `node tools/check_rules.cjs` (16 leaf/2 группы), `git diff --check` — PASS.
- DTD hot restart успешен; Widgetbook обновлён. Открытие отчёта запрошено через open_in_codex, tool вернул queued; ссылка для пользователя: http://127.0.0.1:8094/comparison/avatar/index.html.

Ограничения: native comparison только macOS; backend raster различия зафиксированы выше. Пилот проверяет Avatar, а не ещё не реализованные составные Identity/RosterRow. Для них понадобятся отдельные измерения внутренних узлов. Viewport900 выбран для isolated capture; existing foundation presets390×844/1440×900 сохраняются.

Сохраняется прежняя авторизация пользователя: «каждый добавленный компонент сопровождай коммитом без пуша». Этот коммит содержит один Avatar с его визуальной evidence и необходимыми foundation метриками; push не выполняется. Все AC подтверждены с явно указанными visual deviations.
