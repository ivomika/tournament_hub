# Задача73. Функции классов и AST guard

## Статус и этап

✅ Выполнена. Mode CODE. Stage DONE.
Specification1 / plan1 / test set1. TestGate REQUIRED: новая логика checker. До подтверждённого RED и отдельного approval меняются только docs/rules/tests, не production checker или приложение.

## Цель и контекст

Прямое решение пользователя запрещает верхнеуровневые функции. Сейчас действует только R-006.a для Widget helpers; общий checker их не запрещает. Новое самостоятельное правило R-003.g охватывает Flutter lib/test. Пользователь не задавал правило Python/JS/самостоятельного Dart tools package; на них Flutter scope не расширяется.

## Scope и non-goals

- Документировать правило/router/registry, добавить AST guard к существующему архитектурному checker и отдельные regression fixtures.
- Проверять FunctionDeclaration (включая accessors/generic/async/generator), lambda initializers верхнеуровневых переменных, part-файлы. Не запрещать методы классов/mixin/enum/extensions, function typedef, references/tear-offs методов и локальные функции (если не запрещены другими правилами).
- Точные framework exceptions: main в корневых lib/main.dart/lib/main_*.dart и test/**/*_test.dart; testExecutable только test/flutter_test_config.dart; lookupFoundationLocalizations только в одном generated API. Нельзя исключить целый generated/Widgetbook/test directory.
- После gate мигрировать все authored top-level функции приложения/тестов в классы, не менять внешний вид/доменное поведение. Сохранить shared preview/golden scenarios и реакцию на тему.
- Не менять HTML, продуктовые компоненты49–71 и зависимости. Запрет не распространяется на Python/JS; существующий Python runner получает только вызов новой проверки. Не создавать бессмысленный общий Utils.

## Применимые правила

Прочитаны core R-001/002/004/007; все обязательные Flutter R-003.a–f, R-005, R-006.a–d; maintenance и workflow. Conditional scan: других conditional rules нет. Новый leaf R-003.g последователен после f. R-007/workflow требуют RED и отдельного approval для checker; R-003.e — architecture checks; R-006.c/d — существующие native goldens/shared previews при миграции.

## Уточнения и решения

Исключения технические и точечные: обязательный Dart main/Flutter hook и штатный gen-l10n output. Все обычные builders/helpers/test callbacks принадлежат классам. Generated helpers не нормализуются вручную после генерации. Текущая миграция следует буквальному запрету в Flutter scope и не вводит запрет локальных функций.

## Acceptance Criteria

- [x] AC73.1 R-003.g зарегистрирован, router/docs согласованы, определены scope и точные исключения.
- [x] AC73.2 Checker ловит top-level функции/accessors/lambda initializer в lib/test/part независимо от модификаторов/формы тела; finding содержит точный файл/строку/R-003.g, CLI exit1.
- [x] AC73.3 Exception не распространяется на helpers рядом с main/hook/generated lookup; wrong-path/fake getter/ignore не обходят запрет.
- [x] AC73.4 Методы/typedef/data/tear-offs/local functions и comments/strings не дают false positives.
- [x] AC73.5 Реальные lib/test мигрированы, architecture-check/test и theme regression GREEN; Flutter analyzer/tests/native golden comparison без изменения вида.

## Ошибки и крайние случаи

Проверяется несколько деклараций в одном файле: ошибка не прячется за разрешённым main. Part не даёт особых разрешений. Getter main не является entrypoint. Function typedef остаётся типом; скобки вокруг lambda не обходят правило. Нельзя прятать новые helpers в generated-файле. Неполный Dart source отвергается существующим syntax guard. Новые hooks без расширения явного allowlist не допускаются.

## Test Scenarios

| ID | AC | Проверка |
| --- | --- | --- |
| TS73.1 | 2/3 | top-level public/private/generic/async/generator/accessor/lambda и part |
| TS73.2 | 3 | main/hook/lookup exact positive + wrong path/name/helpers negative |
| TS73.3 | 4 | class/static/extension/mixin/enum/typedef/data/tear-off/local/comment |
| TS73.4 | 5 | существующие architecture51/theme35 baseline и после миграции; production CLI negative probe |
| TS73.5 | 5 | Flutter analyzer/25 affected tests/native goldens/runtime hot restart |

## Implementation plan

1. Baseline architecture-test, AST inventory существующих declarations.
2. Создать standalone fixture tests на существующем inspect API; подтвердить RED по отсутствию R-003.g. Gate AWAITING_APPROVAL по workflow.
3. После approval добавить отдельный guard и интеграцию в inspect/Make/scripts, мигрировать authored функции lib/test по ответственности, оставить точные hooks.
4. Проверить guard/regression/real code, analyzer, existing native goldens, docs и статус.

## Test Evidence и Approval

- Baseline `make architecture-test` из корня — PASS: architecture51, theme35, реальные43 файла; production код неизменён.
- `dart run test/top_level_functions_test.dart` из tools/domain-check — exit1, ожидаемый RED:30 запрещённых сценариев из46 не обнаружены текущим checker (actual [] вместо R-003.g). Все16 разрешённых сценариев проходят; runner/parse ошибок нет.
- `dart run test/top_level_functions_test.dart --inventory` — PASS; AST inventory42 top-level declarations в lib/test.8 технических exceptions (2 app main,4 test main,1 Flutter hook,1 generated lookup);34 authored функции потребуют миграции.
- `dart format test/top_level_functions_test.dart`, `node tools/check_rules.cjs` (16 leaf/2 группы), `git diff --check` — PASS.
- Тест вызывает существующий inspect API. Production checker/приложение не менялись; новые runtime API/заглушки не добавлялись.
- Stage RED_CONFIRMED → AWAITING_APPROVAL. Отдельного approval после evidence пока нет; workflow требует остановку перед checker implementation.

## Changelog

### Итерация1 —7 ноября2026

Prompt пользователя (дословно):

> давай запретим верхнеуровневые функции правилом и напишем checker для этого правила

Подготовлены R-003.g, router/registry, docs и постановка. Новый контракт не заменяет R-006.a: Widget helpers запрещены и внутри классов. Scope Flutter lib/test следует текущему контексту; независимый checker tool не становится Flutter-клиентом.

## Final Verification

- [x] Guard/tests/real code GREEN.
- [x] Миграция сохраняет поведение и native goldens.

## Итог

R-003.g реализован и подключён к architecture-check/test и общему runner.34 authored функции lib/test перенесены в классы;8 обязательных hooks сохранены точечно.49 regression scenarios и25 affected Flutter tests GREEN; analyzer/native goldens/runtime проверки успешны.

Baseline, inventory и RED выполнены7 ноября2026. Новое правило связано с точным исходным prompt; отсутствующий контракт воспроизводится executable fixtures. Следующий шаг после явного approval spec1/plan1/test set1 — implementation и миграция с сохранением существующих tests/goldens.

### Approval и реализация —7 ноября2026

Prompt пользователя (дословно):

> делаем

Пользователь явно одобрил implementation задачи73 specification1/plan1/test set1 после RED46 fixtures (30 ожидаемых отказов). Stage IMPLEMENTING. Реализуется guard и behavior-preserving миграция34 authored функций lib/test.

### Реализация и регрессия —7 ноября2026

Добавлен AST guard ClassOwnedFunctions с точечными hooks и file/line/R-003.g diagnostics. Интеграция — общий inspect, make architecture-test и существующий Python theme runner. Методы и local functions не объявляются top-level; lambda initializers анализируются после снятия скобок.

34 authored функции lib/test перенесены в классы по ответственности. Все4 test main делегируют private suite.run; testExecutable делегирует environment.run. App/Widgetbook bootstrap и ThemeExtensions.require — static методы.6 UI builders остаются реальными Widgetbook/Builder callbacks, но принадлежат preview classes. В generated code не было правок.

Existing theme fixtures содержали верхнеуровневые createTheme/read/child/blend в разрешённых примерах; они механически перенесены в static методы, assertions R-003.d не ослаблялись. Новое правило ожидаемо поймало эти fixtures; после миграции прежние35 случаев GREEN.

При первом compile после миграции2 bool callbacks test suite остались instance members; исправлены на static, повторный analyzer и25 affected tests GREEN. Переходы/тесты/снимки не менялись ради прохождения.

Набор R-003.g технически расширен с46 до49 сценариев в рамках прежних AC: аннотация перед точной строкой finding, несколько top-level variables с lambda, main в part library под именем test entrypoint. Framework exception проверяется только для самостоятельной library, не для part. Это уточнение исходного edge case «part не даёт разрешений», не расширение scope.

## Итоговые проверки

- `make architecture-test` — PASS:49 fixtures R-003.g,51 прежних architecture self-tests,35 theme fixtures,43 реальных lib/test файла без нарушений. Команда architecture-check запускается как обязательный заключительный шаг Make target.
- `python3 tools/check_theme_contract.py` — PASS: новые guard fixtures, существующая architecture/theme регрессия и5 runtime propagation tests. После расширения49 сценариев актуальный guard отдельно подтверждён make architecture-test.
- `dart run test/top_level_functions_test.dart --inventory` — PASS: ровно8 технических top-level declarations, остальные34 перенесены в классы.
- `flutter analyze --no-pub` — PASS, no issues. `dart analyze lib/class_owned_functions.dart bin/check_flutter_architecture.dart test/top_level_functions_test.dart test/theme_boundaries_test.dart` — PASS, no issues.
- `flutter test --no-pub test/presentation/foundation_preview_test.dart test/widgetbook_bootstrap_test.dart test/presentation/golden_environment_test.dart test/presentation/design_system/foundation/theme_propagation_test.dart` — PASS25; native macOS comparison без update, baselines/HTML не менялись.
- DTD hot restart — PASS; runtime errors отсутствуют.
- `node tools/check_rules.cjs` — PASS16 leaf/2 группы; `git diff --check` — PASS. Registry/router и таблица действующих правил согласованы.

Ограничения проверки: Flutter scope lib/test; самостоятельный tools package/Python/JS не под этим правилом. Direct lambda initializer contract не обещает полный data-flow анализ возвращаемых closures. Native comparison выполнен на macOS, Windows/Linux не запускались.

- Production CLI negative integration — PASS: временный `lib/domain/top_level_contract_probe.dart` с запрещённой функцией вернул exit1 и `:2 R-003.g:`. Probe гарантированно удалён в finally; исходники после проверки не изменялись.
- Все AC73.1–73.5 подтверждены, Stage DONE. Изменения этой задачи оставлены в рабочем дереве; отдельного запроса на коммит новой архитектурной задачи не было. Push не выполнялся.

### Сохранение изменений

Prompt пользователя (дословно):

> закоммить изменения без пуша

Авторизован отдельный коммит завершённой задачи73. Перед сохранением проверены состав изменений и git diff --check; исходники после подтверждённых GREEN не менялись. Push запрещён и не выполняется.
