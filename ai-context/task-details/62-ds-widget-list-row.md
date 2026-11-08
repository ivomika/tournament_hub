# Задача 62. AppRosterRow — строка участников из общих компонентов

## Статус и этап

✅ Выполнена

- Mode: CODE; будущая реализация — CODE в этом же номере.
- TestGate: NOT_REQUIRED для заявленного visual/theme/layout scope. App state/controllers, вычисления, валидация, сериализация, данные и app routing исключены; при расширении scope классификация пересматривается до кода.
- Stage: DONE.
- Specification:2; plan:1; test scenarios:2, PASS.
- Реализация визуального scope завершена по approval74; отдельная бизнес-логика не добавлялась.

## Цель и контекст

Один результат задачи: **AppRosterRow**, scope `widgets/roster_row`. Добавление/расширение именно одного элемента вместе с его темой, scoped Widgetbook и проверками; не набор новых компонентов экранов.

Текущий scope после approval74: только mobile roster row/reveal и desktop roster card. Assignment/ranking/history исключены из этой реализации.

Эталон: [UI kit](../../docs/design/prototype/ui-kit.html#c-row), [описание и ограничения](../../docs/design/ui-kit.md), [mapping источников](../../docs/design/prototype/ui-kit-mapping.json). Уже реализованная основа: [foundation](../../docs/design/foundation.md), [manifest](../../docs/design/tokens-manifest.md). Рабочий порядок: [добавление DS-компонента](../../docs/development/design-system-component-workflow.md), [visual workflow](../../docs/development/visual-workflow.md).

## Scope и non-goals

- Входит: Реализовать AppRosterRow через общие AppSurface/AppIdentity/AppAvatar/AppButton/AppIcon, runtime тему и локальный swipe reveal. Remove intent делегируется; desktop имеет явную кнопку.
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

- Depends on: [40](40-ds-foundation-colors.md), [41](41-ds-foundation-typography.md), [42](42-ds-foundation-spacing.md), [43](43-ds-foundation-shape.md), [44](44-ds-foundation-borders.md), [46](46-ds-foundation-motion.md), [47](47-ds-foundation-responsive.md), [49](49-ds-component-surface.md), [50](50-ds-component-button.md), [58](58-ds-widget-identity.md).
- Product: `lib/presentation/design_system/widgets/roster_row/`; собственная тема рядом с визуальным элементом. Чистые tokens не требуют PNG сами по себе.
- Widgetbook: `lib/presentation/widgetbook/widgets/roster_row/<named_use_case>/`; каждый именованный use case в своей папке, registry только агрегирует регистрации.
- Tests: `test/presentation/design_system/widgets/roster_row/`; PNG — `golden/<native-os>/` рядом с визуальным элементом/showcase в lib. Harness/matcher/flutter_test — только test.
- Никакой независимой копии компонента в showcase/golden. Использовать текущую оболочку/registry и existing FoundationScenarioHost там, где он подходит; не создавать новый entrypoint.

## Уточнения и решения

- Пользователь1 ноября2026 запросил постановку: одна задача — один компонент, начиная с foundation.
- Имена Dart API выше — ориентир для постановки; финальный узкий контракт фиксируется по задаче без добавления несвязанных сущностей.
- Статус source/CSS/restored/proposed из UI kit сохраняется. Отметка «предложено» не превращается в утверждённое product state автоматически.
- Смысловые варианты общие для Desktop/Mobile; менять только подтверждённые constraints/density/layout через theme. Текст и выбор конкретной иконки — данные, не новый компонент.

## Acceptance Criteria

- [x] AC-62.1: AppRosterRow реализован/расширен в указанном scope; нет параллельной копии уже существующей сущности, ссылку на HTML-эталон можно проследить.
- [x] AC-62.2: все визуальные параметры приходят из собственной темы и общих токенов, API типизирован; raw styling/строковые discriminators/бизнес-правила отсутствуют.
- [x] AC-62.3: именованные Widgetbook use cases показывают реальный элемент: Mobile default/revealed; Desktop default/focus; long/disabled; keyboard и accessible removal intent.
- [x] AC-62.4: Widgetbook и golden используют одинаковые fixtures/именованные builders/темы; native baselines созданы/сверены, diffs просмотрены, comparison после update выполнен без update.
- [x] AC-62.5: проверены constraints, значимые states, локализованные labels/semantics и content limits; совпадение visual identity Desktop/Mobile подтверждено, отклонения записаны.
- [x] AC-62.6: manifest/owning docs/scenario registrations актуальны; analyze/tests/architecture checks по impact PASS либо честный blocker с NOT_RUN. Результат показан пользователю.

## Ошибки и крайние случаи

Не наследовать winner emphasis из first-child списка. Удаление/места/сортировка/история — логика потребителя. Свайп не единственный способ открыть действие; отключённый callback=null.

Для любой интерактивности отдельно проверить доступный/недоступный callback, pointer/keyboard и focus; требования применяются только к реально поддерживаемому контракту. Не создавать декартов продукт всех props/knobs.

## Test Scenarios

| Сценарий | Критерии | Уровень | Ожидаемый результат |
| --- | --- | --- | --- |
| TS-62.1 Основной вид и перечисленные варианты | AC-62.1, AC-62.2, AC-62.3, AC-62.4 | Реальный Widgetbook + shared golden | Source-анатомия/тема сохранена; собственная папка use case; нет UI-копии |
| TS-62.2 Значимые states и делегирование | AC-62.2, AC-62.3, AC-62.5 | Widget/semantics по контракту | Именованные callbacks и ожидаемая доступность; без domain/infrastructure |
| TS-62.3 Длинный контент/ограничения | AC-62.3, AC-62.5 | Render390×844,1440×900 и обоснованные boundary widths | Нет неожиданных overflow/clipping; прокрутка там, где она часть контракта |
| TS-62.4 Изменение темы/общего токена | AC-62.2, AC-62.4 | Golden затронутых потребителей | Оформление обновляется через theme; source/proposed различия задокументированы |
| TS-62.5 Native comparison | AC-62.4, AC-62.6 | Flutter comparison текущей ОС | Bundled fonts, DPR1, ru/direction/text scale/animation phase фиксированы; missing baseline — ошибка |

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

- Реальный общий pipeline RosterRow PASS4/4,29 controls; Flutter DS/Widgetbook suite PASS24, Node engine PASS34, analyzer и architecture-test PASS.
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

- [ ] Все AC подтверждены при реализации; тесты фактически запущены.
- [ ] Theme/scenarios/goldens/docs согласованы, визуальный результат показан.
- [ ] Нет бизнес-логики/запрещённых dependencies/raw styling.

## Итог

Постановка создана; 🟣. Реализация и выполнение Flutter-проверок не начаты.

### Авторизованная очередь после инструмента74

Prompt пользователя (дословно):

> Давай сделаем этот инструмент общим для всех компонентов, чтобы для нового компонента нужно было только описать сценарии и контрольные элементы, а сравнение и отчёт запускались одной командой.
> После реализуй компоненты от которых зависит строка участников, каждый компонент отдельным комитом без пуша. После реализуй компонент widget "Строка участников" и остановись показав его в инструменте сравнения

Запуск реализации после общего сравнения74; до его завершения эта карточка остаётся запланированной. Отдельный коммит данного компонента без push; сверка сценариев/контрольных элементов в общем отчёте.

Уточнение текущего scope: запрос относится к «Строке участников» — AppRosterRow, mobile row/reveal и desktop card с постоянной кнопкой. Assignment/ranking/history сейчас не реализуются. Перед кодом обновить specification/AC до этого конкретного результата; не объявлять все HTML Row recipes готовыми. Remove intent делегируется потребителю, без удаления данных/confirmation logic внутри widget.

### Уточнение scope и Plan1 после approval74

По явной очереди пользователя реализуется только AppRosterRow в widgets/roster_row. Исходная общая идея AppListRow с assignment/ranking/history заменена узкой композицией. Эти дополнительные recipes не входят в текущий принимаемый результат и не считаются выполненными автоматически. Историческая постановка выше сохранена.

Specification2: mobile min72, Avatar48 round, Inter18/1.4, inset8×16; swipe left reveals action88 на всю высоту справа. Desktop min208, inset24, Avatar64 radius22, gap24, Inter22/1.4, explicit remove40 top/right24 без swipe. Shared AppSurface/AppIdentity/AppButton/AppIcon. Локальная drag/focus/reveal — только визуальное взаимодействие, TestGate NOT_REQUIRED. Callback только remove intent, confirmation/business deletion у потребителя. Keyboard Left/Right/Escape mobile; Enter/Space action; hidden action исключён из focus/semantics, доступный semantic delete intent. Nullable callback disabled.

Plan: runtime Roster metrics/theme → widget composition и визуальный reveal → shared scoped fixtures/сценарии → источник и native controls плюс long/disabled native goldens → gesture/keyboard/semantics/theme checks → полный report, отдельный коммит без push и остановка.

AC текущей версии: mobile default/reveal и desktop default/focus source сравнены с Avatar/Text/action controls; actual drag/cancel/reclose и keyboard/disabled/semantics делегируют intent без удаления данных; long/narrow/text scale/theme не ломают layout; native goldens/analyzer/architecture проходят, отчёт показан.

### Итерация2 — реализация и завершение

Prompt пользователя (дословно):

> Подтверждаю, приступай. Реализуй общий инструмент, затем зависимости и строку участников, каждый компонент отдельным коммитом без пуша. После покажи строку в сравнении и остановись.

Продолжение пользователя (дословно):

> продолжи

Изменения: AppRosterRow через AppSurface/AppIdentity/AppAvatar/AppButton/AppIcon; runtime AppRosterMetrics/Theme, drag/reveal/cancel, постоянный desktop action, keyboard/focus, custom semantics intent и intl label. Callback/null callback делегируются без изменения данных. Внутренняя поверхность flat имеет прямую границу; outer radius остаётся у строки. Scoped Widgetbook5 use cases и10 macOS PNG (4 source +6 long/disabled/scaled).

Реальное сравнение выявило desktop name offset8px: поздний source CSS задаёт gap16, а не прежний24. Исправлена participant stacked theme, обновлены2 затронутых Identity baselines; старые character/Avatar baselines сохранены. Pointercancel-test выявил commit reveal при отмене принятого gesture; raw cancel теперь восстанавливает положение до pointer down. Полный suite повторён после исправлений. Scoped control locator withinType исключает зависимость от глобального порядка private boxes; измеряется actual used radius, CSS999px и circle48 дают24px.

Test evidence (macOS, DPR1, bundled fonts):

- `node tools/visual-comparison/compare.mjs roster-row --update-goldens`, затем без update — PASS4/4,29 controls,0 findings. Все16 PNG Web/Flutter/overlay/diff загружены в настоящем браузере; отчёт и снимки лично просмотрены. Geometry0.5px/baseline1px — явные дробные renderer допуски. Desktop focus note: CSS-demo3px против реального desktop focus2px; Flutter2px, отличие прямо показано в отчёте.
- `flutter test --no-pub test/presentation/design_system test/widgetbook_bootstrap_test.dart` — PASS24. Отдельно Roster+Identity с update и без: swipe/reclose/cancel/vertical, Left/Right/Escape, Enter/Space, hidden focus/semantics и custom action, null callback, theme replacement, long/narrow/scaled1.6. Обновлён bootstrap после добавления законного Widgets scope, без искусственного старого ограничения2 folders.
- `flutter analyze --no-pub` — No issues. `make architecture-test` —49 function fixtures,51 architecture,35 theme boundaries и114 реальных файлов PASS. `node --test tools/visual-comparison/test/generic_engine.test.mjs` —34/34 PASS (включая escaping source note). `node tools/check_rules.cjs`, `git diff --check` — PASS.
- Регрессия общей used-radius нормализации: `node tools/visual-comparison/compare.mjs button` — PASS25/25 без update.
- Widgetbook hot restart succeeded; runtime errors отсутствуют. Сервер8094 продолжает работать. Browser report открыт через Codex panel (queued клиентом) и доступен по прямой ссылке; headless проверка подтвердила все cases/images.

Временный отказ automatic approval reviewer из-за workspace credits прервал один запуск; после «продолжи» повторное согласование инструментом прошло, заблокированных проверок не осталось. Linux/Windows native проверки NOT_RUN.

Final verification: текущие AC-62.1–6 выполнены; code/tests/scoped fixtures/theme/docs/report согласованы. DONE. Отдельный локальный коммит RosterRow без push; после показа отчёта работа останавливается по запросу. Assignment/ranking/history и остальные задачи DS не начинались.

Дополнительная граница жеста: DragStartBehavior.down сохраняет отсчёт порога от pointer down, без добавления framework touch slop. Проверки20px (закрыт) /30px (раскрыт) и обратный30px PASS; повторные5 Roster tests без update PASS.

### Новая очередь переноса после RosterRow

Prompt пользователя (дословно):

> выглядит хорошо. Обнови задачи по реализации компонентов, посмотри что уже выполнено, а что еще требует реализации и реализуй каждый компонент по новому flow делая коммит для каждого компонента без push

Обязательный flow текущей итерации: сверить существующий runtime и итоговый CSS UI kit → определить реальные состояния/адаптацию и контрольные узлы → typed runtime WidgetTheme без primitives в consumers → scoped Widgetbook/shared fixture → декларация общего comparison pipeline → source/native/overlay/diff и native goldens → осмотр и исправление внутренних различий → повтор без update, tests/analyzer/architecture → отдельный локальный коммит компонента без push. Существующая реализация не дублируется. Наличие tokens в72 не равно выполнению всех старых AC foundation.
Факт сверки: компонент уже реализован и имеет comparison declaration/отчёт и native проверки; повторная реализация не нужна. Изменять только при обнаруженном расхождении.

### Аудит76: раскрытый action при увеличенном шрифте
Prompt пользователя (дословно):
> Проверь остальные компоненты в Widgetbook на такие же проблемы с размерами в Mobile и Desktop. Исправь найденное, каждый компонент отдельным коммитом без push.

Stage IMPLEMENTING; TestGate NOT_REQUIRED layout-only. Ширина reveal должна совпадать с content-aware ButtonTheme, full-height/right-edge поведение сохраняется.

Stage DONE. Reveal width берётся из ButtonTheme с localized delete label; edge/full-height сохранены. Button+Roster10 tests PASS, обычные goldens неизменны, только mobile_scaled обновлён. Source comparison PASS. No push.
