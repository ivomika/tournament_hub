# 104. Читаемость имён и условий

✅ Завершена · CODE · Stage DONE · TestGate REQUIRED: новые правила AST checker.

Specification/plan/test set: 1. Approval пользователя 2026-11-10: «делаем», относится к gate после RED31/41 и согласованному исключению координат. Разрешена реализация checker, правил и scan без массовых исправлений.

## Цель

Запретить непонятные сокращения переменных и вложенные тернарные выражения; встроить проверку в существующий architecture checker и выполнить полный scan Flutter lib/test. Существующие границы слоёв сохраняются. Коммит103 выполнен отдельно до начала этой задачи.

## Применимые правила

R-001: отдельная ответственность AST visitor; R-002: docs и канонические leaf rules; R-004: типизированные findings; R-007 и workflow: fixtures, baseline, RED, approval до реализации checker. Router/maintenance/registry прочитаны. Новые общие ограничения размещаются в core, Dart реализация checker — tools/domain-check. Нет изменений product Flutter/UI и conditional triggers.

## Уточнения

- Интерактивно запрошены границы запрещённых имён и исключений, определение вложенности и разрешение на исправление legacy. До ответов правила не объявляются утверждёнными в деталях, реализация checker не начинается.
- Предложение: однобуквенные имена + явный список сокращений отклоняются AST; семантическая понятность остальных — review. id/url/uri не объявлять нарушением без согласования. Ignore/comments не обходят проверку; generated/framework исключения требуют точных границ.
- Предложение: запрещать вложенный ConditionalExpression в condition/then/else, включая скобки; независимые выражения разрешены. Именованный метод использует if/switch, а не прячет ту же цепочку.

## Предварительный план и критерии

1. Зафиксировать ответы, scope, исключения и два правила в core с docs/router/registry.
2. Проверить baseline существующих architecture tests. Подготовить positive/negative fixtures: locals/fields/parameters, несколько деклараций, private names, comments/strings, вложенность в трёх ветвях/скобках, независимые expressions и if/switch.
3. Запустить RED по ожидаемой причине, сохранить evidence, остановиться на AWAITING_APPROVAL по workflow.
4. После approval реализовать visitor, file/line/rule findings и ненулевой exit; встроить в architecture-check/test без silent skips.
5. Выполнить регрессию и полный scan, сохранить количество/пути нарушений и пределы проверки. Массовые правки кода только после согласования.

## Changelog

### 2026-11-10

> Сделай коммит изменений по стилю проекта, после чего давай добавим правило и архитектурную проверки
> 1) Запрет сокращенний в написании переменных. Перменная t - это антипатерн, который на уровне проверки должен отклоняться. Разработчик не должен догадываться что означает переменная по сокращению и искать это в коде.
> 2) запрет больших вложенных тернарных операций, если потребывалось сделать больше чем 1 тернарную операцию, это должно быть вынесено в именованный метод который укажит явные условия,
>
> После запусти проверку кода на соответсвия архитектуре и этим новым правилам

- Создана задача104, отправлены три интерактивных вопроса. Реализация правил/checker и новый scan ещё не выполнены: ожидаются ответы, затем test-first gate. Сборки и push не разрешены и не выполняются.

### 2026-11-10 · ответы и тестовое подтверждение

**Ответы пользователя дословно**

> Принимаю, но нужно учитьывать исключения, например в Painter  x и y это координаты и не стоит их явно ограничивать

> Да, запрещаем вложенность

> Да, отчёт без массовых исправлений

## Specification 1 и решения

- AC-1: core-группа читаемости R-008 с leaf R-008.a (имена) и R-008.b (условия), docs и согласованный router/registry. Номера будут зарегистрированы при реализации после approval, не являются уже действующими правилами.
- AC-2: AST checker Flutter lib/test отклоняет однобуквенные variable/parameter bindings, включая private leading underscore; generic type parameters и настоящий wildcard `_` — не переменные. Явный начальный список сокращений: ctx/cfg/args; проверяются целые camelCase/snake_case сегменты без ложных совпадений context/configuration/arguments/texture. id/url/uri разрешены. Смысл остальных имён проверяется review, не имитируется AI/словарём.
- AC-3: предлагаемое узкое техническое исключение координат — локальные x/y с явно объявленным числовым типом double/int/num непосредственно в paint класса, напрямую extends Flutter CustomPainter. Имя класса с суффиксом Painter само по себе не даёт исключения, вложенные closures/другие методы и t не освобождаются. Не выводить координатный смысл произвольных значений эвристикой. Это точная граница первого набора, показывается пользователю на gate; расширение на поля/helpers/другие geometry APIs потребует отдельных fixtures и решения.
- AC-4: отклоняется ConditionalExpression внутри condition/then/else другого ConditionalExpression, в том числе через скобки/аргументы вызовов. Независимые ?: разрешены, ?? не считается тернарным. Именованный метод использует явные if/switch, перенос цепочки в метод не обход.
- AC-5: findings имеют путь, строку и leaf ID; ошибки дают nonzero. Проверка интегрирована в architecture-check/test. Комментарии/строки не считаются кодом; ignore не отключает правило. Нет общего исключения generated/framework: допустимые точные исключения добавляются явно и с tests, не из предположения.
- AC-6: полный scan даёт честный отчёт по существующим нарушениям без массовых исправлений. Наличие legacy findings не выдаётся за ошибку checker, suite fixtures должен быть GREEN отдельно от scan продукта.

## Test scenarios и план1

- AC-2/3: locals/fields/parameters/closures/loops/catch/patterns/test files, multiple declarations/private names, точная строка, допустимые имена/строки/комментарии/generics/wildcard; coordinates positive и четыре anti-bypass cases.
- AC-4: вложенность в трёх позициях, скобки/аргумент, перенос в метод, test scope; simple/independent/explicit branches/?? positive.
- До реализации добавлен только tools/domain-check/test/code_readability_test.dart с вызовом существующего architecture.inspect. Нет runtime-заглушек или подмены проверяемой логики.
- После approval: отдельный visitor в tools/domain-check/lib, минимальный вызов из inspect и регистрация теста в Makefile; два leaf rules, docs и registry/router/maintenance; регрессия старых fixtures, новый suite, scan с сохранением findings. Production Flutter не менять. Архитектурные слои не меняются, новых пакетов нет. Новые исключения не добавлять ради GREEN старого кода.

## Evidence 2026-11-10

- Cwd tools/domain-check. Baseline: dart run bin/check_flutter_architecture.dart --self-test —51 PASS; dart run test/top_level_functions_test.dart —49 PASS; dart run test/theme_boundaries_test.dart —35 PASS; dart run bin/check_flutter_architecture.dart —536 файлов, нарушений нет, exit0.
- dart format test/code_readability_test.dart завершён. dart run test/code_readability_test.dart — exit1:31/41 failed, каждый negative получил actual [] вместо ожидаемых R-008.a/b; все10 positive прошли без посторонних diagnostics. Это ожидаемый behavioral RED: текущий checker не проверяет новые ограничения. SDK/компиляция работают.
- RED относится к интеграционным fixtures через настоящий inspect; CLI nonzero и конечный inventory будут проверены после реализации. Полный scan по новым правилам пока невозможен: проверки ещё отсутствуют. Изменены только task metadata и тестовый файл. Без новых коммитов/build/push. Следующий этап — явный human approval.

### 2026-11-10 · approval и реализация

> делаем

- Пользователь утвердил specification/plan/test set1 после RED31/41 и показанной границы x/y. Approval записан до production изменения. Созданы R-008.a/b в core, группа R-008, обновлены router/registry/maintenance. Архитектурное решение и ограничения в docs/development/code-readability.md.
- CodeReadability visitor подключён к существующему inspect, тест добавлен в make architecture-test. Декларации/параметры/patterns/catch и вложенные условные выражения анализируются AST, не regex исходного текста. Сегментация identifier детерминирована. Игнорирование comments/strings и координатное исключение покрыты fixtures. Новый visitor не зависит от Flutter и не меняет его код.
- Первоначальные compile errors из-за analyzer13 API исправлены: RegularFormalParameter и ClassDeclaration.namePart; учтён ClassBody между методом и классом. Это исправления реализации в пределах approval, тестовые ожидания не ослаблялись.
- GREEN: dart run test/code_readability_test.dart —41 PASS; architecture --self-test —51 PASS; top_level_functions_test —49 PASS; theme_boundaries_test —35 PASS. Три positive theme fixtures механически переименованы c/a/b/t → context/startColor/endColor/progress: их theme-смысл сохранён, новые правила не отключались. dart analyze lib/code_readability.dart test/code_readability_test.dart — No issues found.
- Полный dart run bin/check_flutter_architecture.dart: exit1,473 existing findings в189 файлах (R-008.a346, R-008.b127). [Полный вывод](104-code-readability-report.md). Старый код не исправлялся, нет baseline/ignore для подавления legacy/generated/framework. Полный scan красный намеренно; executable suite checker GREEN, цель задачи — ввести проверку и показать нарушения, не очистить приложение.
- node tools/check_rules.cjs:18 leaf/3 группы PASS; git diff --check PASS с LF→CRLF warning maintenance. Сборки, Flutter запуск/hot reload, новые коммиты и push не выполнялись: runtime приложения не менялся. Все AC1–6 выполнены в согласованном scope; семантический review имён и проверки других языков не автоматизированы.
