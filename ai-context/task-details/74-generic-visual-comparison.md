# Задача74. Общий инструмент визуального сравнения

## Статус и этап

✅ Выполнена. Mode CODE. Stage DONE.
Specification1 / plan1 / test set1. TestGate REQUIRED: новый общий инструмент с validation/comparison/orchestration/error handling. До RED и отдельного approval меняются только docs/tests. Existing Avatar pilot остаётся рабочим.

## Goal / Context

Пользователь одобрил Avatar pilot, теперь просит общий механизм для всех компонентов. Fixed scripts/harness сейчас знают размеры Avatar, пути, CSS selectors и glyph метрики. Их нельзя копировать для каждого нового элемента. После этого пользователь требует реализовать зависимости строки участников отдельными коммитами без push, затем саму строку и остановиться с её отчётом.

## Scope / Non-goals

- Одна команда `node tools/visual-comparison/compare.mjs <component>` (Make shortcut допустим) запускает получение декларации, web capture, Flutter capture, измерения, overlay/diff, validation и отчёт. Сервер и отдельный Chrome управляются runner; существующий сервер переиспользуется, закрываются только собственные процессы.
- Декларация компонента содержит scenarios/viewports/data/states, исходные web root/control selectors, реальные Flutter fixture builders и typed locators контролей. Builders/locators объявляются в Dart: JSON сам по себе не конструирует произвольный Flutter Widget. Registry только агрегирует декларации. Общие engine/capture/report не содержат switch по именам компонентов.
- Общий measurement protocol: scenario id, root rect, именованные control rect/style/baseline, raster stats и artifact paths. Rect относительно root; область текста и видимый glyph ink различаются явно. Точность назначается по свойствам/контролям, неизвестные измерения не игнорируются.
- Missing/duplicate scenarios/controls, invalid metrics, захват неудачен, отсутствуют fonts или images — явный failure, не PASS и не старый отчёт. В отчёте остаются все случаи и причины. Geometry/style/raster сравниваются раздельно; source/Flutter/diff/overlay доступны.
- Перевести Avatar на этот путь, подтвердить baseline. Доказать отсутствие Avatar-specific assumptions тестовым многоконтрольным компонентом; затем настоящей строкой участников.
- Не переносить все DS-компоненты, не менять HTML-эталон, бизнес-правила/DI/сеть приложения, не подключать cloud. CI/native OS не считаются проверенными без реального прогона.

## Применимые правила

Прочитаны core R-001/002/004/007, все Flutter R-003.a–g/R-005/R-006.a–d, maintenance и workflow. Conditional scan: других правил нет. R-007/workflow требуют test-first gate общего инструмента. Flutter DS переносы visual/theme/gesture scope NOT_REQUIRED, сохраняют goldens/checkers. R-003.g: authored Dart функции в классах; capture/report tools остаются самостоятельным Node package scope. Runtime app/lib не импортирует flutter_test.

## Принятые решения

- Сохраняется цепочка primitive → FlutterTheme → WidgetTheme → Widget. Shared scenarios используют реальные widgets и source UI kit.
- Font/raster rounding не разрешает геометрические сдвиги. Пороги явные; root/control координаты, размеры, alignment, style свойства имеют собственные findings.
- Для text baseline web используются реальные DOM Range/font metrics, Flutter — реальные RenderParagraph/TextPainter данные; JSON protocol не содержит Finder/Widget.
- Freeze/settle policy задаётся сценарием, capture ограничен timeout; никакого бесконечного pumpAndSettle для анимаций.
- Existing Avatar контрольный сдвиг сохраняется как проверка чувствительности. Отчёт не называет ожидаемый дефект нормальным состоянием.
- Native capture не должен принудительно присваивать widget исходную web-height и скрывать неправильную компоновку. Контейнерные constraints и реальный measured rect различаются.

## Acceptance Criteria

- [ ] AC74.1 Новый компонент добавляется декларацией builders/scenarios/control locators и registration; engine/capture/report не меняются.
- [ ] AC74.2 Одна команда выполняет весь pipeline с собственным lifecycle сервера/Chrome; fonts/viewport/DPR/state фиксируются.
- [ ] AC74.3 Missing/duplicate/unknown/invalid данные и stage failures приводят к ненулевому выходу и полному диагностическому отчёту; stale PASS не используется.
- [ ] AC74.4 Сдвиг внутреннего control при том же root выявляется; numeric/style thresholds применяются отдельно; raster не заменяет geometry.
- [ ] AC74.5 Отчёт универсален по числу/именам контролей и scenarios; содержит screenshots/overlay/diff/findings, экранирует source text.
- [ ] AC74.6 Avatar воспроизводится общей командой без потери текущих golden/theme/architecture проверок; модульные/интеграционные тесты GREEN.

## Test Scenarios

TS74.1: spec accepted/invalid/duplicate/nonfinite/unknown properties; TS74.2: equal geometry / inner shift / missing controls / style mismatch / explicit tolerances; TS74.3: full escaped report including failed/missing cases and raster diagnostics; TS74.4: ordered pipeline and cleanup/failure propagation with fake external capture adapters but real comparison; TS74.5: existing Avatar baseline and final native integration; CLI help/command exists.

## Implementation plan

1. Baseline existing architecture + Avatar tests. Написать Node executable tests новых API, подтвердить RED; AWAITING_APPROVAL по workflow.
2. После approval: spec/measurement codecs, pure comparison, universal report, pipeline/CLI lifecycle; generic Flutter driver и typed component declarations. Мигрировать Avatar, выполнить одну реальную команду и negative controls. Отдельный tool-коммит.
3. Далее выполнить пользовательскую очередь:48 AppIcon (исходные18 glyphs, не похожие Material icons) →49 Surface →50 Button (включая необходимые action/icon варианты) →58 Identity. Avatar57 и foundation72 переиспользуются. Каждый компонент отдельным коммитом без push и с отчётом общего инструмента.
4. В62 реализовать именно widget AppRosterRow (mobile row/default/reveal, desktop card/default/focus, long name, disabled action, keyboard/semantics). Assignment/ranking/history не добавлять попутно. Mobile delete справа на всю высоту, desktop явная кнопка; Row делегирует remove intent и не удаляет бизнес-данные/не владеет confirmation flow.
5. Проверки source/native, gestures/theme/semantics/native goldens/analyzer/architecture; итоговый отчёт RosterRow, отдельный коммит и остановка. Дальше по DS не продолжать.

## Зависимости и итоговая очередь

AppIcon для исходной корзины и button glyphs; Surface для shell; Button для action/focus/keyboard; Identity для Avatar + primary/secondary text без копирования компоновки. Точный visual API уточняется по computed source каждой задачи, без второго generic ListRow registry. Текущий AppAvatar не заменяется заглушкой. Foundation scopes уже представлены runtime задачей72; недостающие значения дополняются при реальной необходимости.

## Test Evidence / Approval

- Baseline `make architecture-test` — PASS:49 class-owned,51 architecture,35 theme fixtures;58 реальных файлов без findings.
- Baseline `flutter test --no-pub test/presentation/design_system/components/avatar/avatar_visual_test.dart test/widgetbook_bootstrap_test.dart` — PASS5. Existing Avatar capture/goldens/Widgetbook сохраняют поведение.
- `node --test tools/visual-comparison/test/generic_engine.test.mjs` — exit1,31/31 ожидаемых RED.30 сценариев явно сообщают об отсутствующих validateSpec/compareScenario/renderReport/runPipeline,31-й — об отсутствующем one-command CLI. Это missing capability, допустимый workflow RED для нового API, а не отказ существующего SDK/runner. Node24 runner выполнил все31 tests; syntax/runtime ошибок тестового harness нет.
- Тесты вызывают будущие реальные API, не добавляют production stubs. Pipeline tests fake только external capture/report I/O adapters; сравнение должно исполняться настоящим общим engine. Пока общей реализации нет, tests подтверждают именно отсутствие capability и задают нормальные/ошибочные/граничные результаты для GREEN.
- `node --check tools/visual-comparison/test/generic_engine.test.mjs`, `node tools/check_rules.cjs` (16 leaf/2 группы), `git diff --check` — PASS.
- Stage RED_CONFIRMED → AWAITING_APPROVAL; отдельный approval после evidence пока не получен. До него production не изменён, зависимые компоненты по порядку пользователя ещё не начинались.

## Changelog

### Итерация1

Prompt пользователя (дословно):

> Давай сделаем этот инструмент общим для всех компонентов, чтобы для нового компонента нужно было только описать сценарии и контрольные элементы, а сравнение и отчёт запускались одной командой.
> После реализуй компоненты от которых зависит строка участников, каждый компонент отдельным комитом без пуша. После реализуй компонент widget "Строка участников" и остановись показав его в инструменте сравнения

Постановка общей инфраструктуры и очереди зависимостей. Новая независимо принимаемая цель74; конкретные DS реализации продолжают существующие48/49/50/58/62. До gate не меняются runtime/общие scripts.

## Final Verification

- [x] Generic pipeline/CLI tests и реальный Avatar integration GREEN.
- [x] Source/native measurements и реальный one-command report проверены; компоненты далее выполняются в собственных карточках48/49/50/58/62.

## Итог

Baseline GREEN,31 новых tests RED по отсутствующему general capability. Stage AWAITING_APPROVAL для implementation spec1/plan1/test set1. После approval продолжается инструмент, затем уже авторизованная очередь компонентов отдельными коммитами без push; после RosterRow — остановка с отчётом.

Итог текущей подготовки: изменены только docs/task cards и test-only fixtures. Production tool/Flutter компоненты не менялись. Scope/general architecture reviewable в docs/development/visual-component-comparison.md; тестовая команда выше воспроизводит RED без browser/Flutter зависимостей.

### Approval

Prompt пользователя (дословно):

> Подтверждаю, приступай. Реализуй общий инструмент, затем зависимости и строку участников, каждый компонент отдельным коммитом без пуша. После покажи строку в сравнении и остановись.

Явный approval после RED для specification1/plan1/test set1. Продолжается весь авторизованный порядок, без повторных согласований чистого visual scope. Коммиты отдельных компонентов разрешены, push запрещён.

### Итерация2 — реализация после approval

Общий protocol/validator, comparison engine, report, CLI и Chrome lifecycle; typed Dart declarations и общий Flutter driver. Avatar мигрирован:28 обычных cases PASS, намеренный сдвиг4.75px обнаружен по initials.center.y. Root не изменён. Baseline estimate Avatar допускает1px из-за DOM Range/Canvas rounding, geometry0.25px; raster отклонения показаны отдельно. Старые одноразовые Avatar scripts удалены.

Проверки:34/34 Node tests PASS; реальная команда `node tools/visual-comparison/compare.mjs avatar` PASS; analyzer PASS. Targeted Avatar/Widgetbook/generic-driver suite и architecture-test проверены при завершении. Новые goldens не требовались: старые17 Avatar baselines сохранены. Другие native ОС не запускались.

Итог инструмента: DONE. Зависимые компоненты продолжаются в48/49/50/58/62.

### Проверка на составной строке62

Общий driver дополнен locator scope withinType и фактическим radius для CSS pill/circle; notes показывают сознательные source расхождения. Устаревший README пилота заменён актуальной одной командой. RosterRow сравнивает внутренние Avatar/Text/Button, а не только внешний shell. Общий pipeline обнаружил реальный неверный desktop gap8px, исправление проверено повторно.

### Итоговая сверка очереди40–71 — 8 ноября2026

Prompt пользователя (дословно):

> Продолжай реализацию: сначала заверши foundation, затем остальные компоненты по новому flow. Каждый компонент отдельным коммитом без push.

> продолжи

- Все32 задачи40–71 имеют статус✅:9 foundation scopes и23 UI семейства. Ранее выполненные48/49/50/57/58/62 повторно не дублировались; факт сверки отражён в их карточках. Каждая новая реализация сохранена отдельным локальным коммитом, от Colors9e1bb74 до ShareLink6962cf9. Push не выполнялся.
- Последний ShareLink:4 source/native сценария PASS после update и повторного обычного запуска. Визуальный осмотр overlay выявил различие переноса URL при совпадающей геометрии; перенос исправлен до коммита.
- Итоговая команда из apps/tournament_app: `flutter test --no-pub test/presentation/design_system test/presentation/foundation_preview_test.dart test/widgetbook_bootstrap_test.dart` —90 PASS без обновления goldens. Первый запуск включал несуществующий путь test/presentation/widgetbook и завершился ошибкой загрузки; повтор с реальными путями выше полностью GREEN.
- `flutter analyze --no-pub` — PASS. `make architecture-test` —49 function fixtures,51 dependency fixtures,35 theme fixtures PASS; checker315 файлов без нарушений. `node --test tools/visual-comparison/test/*.test.mjs` —37 PASS. `node tools/check_rules.cjs` и `git diff --check` — PASS. Native Widgetbook hot restart выполнен.
- Source/native/overlay/diff отчёты находятся в docs/design/prototype/comparison/<component>/index.html; report хранит raster delta отдельно от измеряемых контрактов, PASS не означает побитового совпадения растеризации. ProgressIndicator — намеренное утверждённое отличие: стандартный Material3 вместо неверного HTML waveform.
- Проверены только native macOS baselines; Windows/Linux NOT_RUN. Реализованы presentation-компоненты и callback intents; сеть, Clipboard и бизнес-сценарии приложения в scope переноса не входят.

### Ошибка реальной оболочки Widgetbook — 8 ноября2026

Prompt пользователя (дословно):

> открывая widgetbook я почти везде вижу это

Stage IMPLEMENTING; TestGate NOT_REQUIRED: исправление preview theme/localization wrapper, без прикладной логики. Причина: Widgetbook.darkTheme настраивает chrome, default materialAppBuilder создаёт отдельную стандартную тему без extensions/intl. План: передать именованный appBuilder с существующим FoundationScenarioHost и явной основной темой; регрессия открывает каждый use case через настоящий WidgetbookState/Workbench, затем analyze/checker и hot restart.

Завершение follow-up: Stage DONE. Именованный appBuilder явно передаёт main ThemeData в FoundationScenarioHost, включая localization. Галереи singleLine/multiline полей прокручиваются; тест реального Workbench обнаружил multiline overflow и теперь проходит все98 публичных initialRoute. `flutter test --no-pub test/widgetbook_bootstrap_test.dart`:3 PASS (98 сценариев внутри smoke test), `flutter analyze --no-pub` PASS, architecture-check315 файлов PASS, rules/diff PASS. Native приложение перезапущено, Responsive consumers выбран через UI и визуально отображается без red screen. Production DS/PNG не изменялись; golden update не требуется. Изолированные goldens ранее проверяли fixtures, но не их подключение в реальную оболочку — этот пробел закрыт регрессией. Локальный коммит без push.
