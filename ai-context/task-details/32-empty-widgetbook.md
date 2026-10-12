# Задача 32. Пустой Widgetbook

## Статус и этап

🚧 В работе — исправление debug-запуска Widgetbook

- Mode: CODE.
- Stage: IMPLEMENTING.
- TestGate: NOT_REQUIRED — локальная debug-конфигурация; по изменённому workflow gate больше не требуется.
- Versions: specification 3, plan 3, test set 3 (предыдущие evidence сохранены).

## Цель и контекст

Подключить отдельный каталог Widgetbook в существующем Flutter-клиенте. На момент постановки v1 в lib был только main.dart, widgetbook и launch.json отсутствовали. Текущий v2 размещает запуск непосредственно в main_widgetbook.dart по запросу пользователя; обычный main.dart не меняется.

Официальный pub.dev на дату discovery показывает stable widgetbook 3.25.0, min Dart 3.10; проект требует Dart ^3.13.0. Beta 4.x не выбирается. Источники: https://pub.dev/packages/widgetbook/versions и https://docs.widgetbook.io/quick-start.

## Scope/non-goals

- package widgetbook, отдельный lib/main_widgetbook.dart с запуском непосредственно внутри main, root .vscode/launch.json, документация запуска.
- Пустой каталог: без компонентов, экранов, use cases, addons, custom themes и Cloud integration.
- Без генератора/annotations/build_runner, без отдельного Flutter-проекта, без изменения обычного main.dart, без product feature и business rules.
- Не создавать дизайн-систему до появления соответствующей задачи. Запускается штатный UI третьестороннего каталога, без собственного оформления/текста.

## Применимые правила

- R-001/R-002 — отдельный bootstrap и документация.
- R-004/R-007 — типизированный тест поведения и конфигурации, evidence RED до production.
- R-003.a/c/e — main обращается к app, внешняя UI-зависимость не проникает в domain, package imports.
- R-003.b/d/R-005/R-006.a/b — бизнес-вызовов, собственного визуального оформления, UI-текста и showcase widgets нет; Widgetbook-root создаётся bootstrap без Widget-returning helper и анонимных обработчиков.
- Flutter rules прочитаны, conditional rules отсутствуют.
- Текущий launcher-fix: R-001/R-002 — локальное исправление окружения и документация причины; R-004 — строки только внешней схемы launch.json; R-007 — реальный запуск с воспроизведённым окружением, без нового теста каждого параметра и TestGate. Flutter-логика/UI/импорты не меняются.

## Уточнения и решения

- Запрос однозначен по поведению; unresolved бизнес-решений нет.
- Технический выбор: Widgetbook.material с пустыми directories, зависимость widgetbook ^3.25.0, default addons/integrations не подключаются.
- VS Code: два профиля (обычное приложение и Widgetbook), cwd существующего Flutter-клиента, без фиксированного deviceId. Профиль выбранного устройства используется на поддерживаемых платформах.

## Acceptance Criteria

- [x] AC-1: установлен widgetbook, bootstrap запускает Widgetbook-root с пустыми directories без Flutter exceptions и без addons/integrations.
- [x] AC-2: lib/main_widgetbook.dart — отдельный entrypoint, обычный main.dart не изменён.
- [x] AC-3: VS Code имеет отдельный корректный debug-профиль Widgetbook и профиль обычного приложения с существующими разными program paths.
- [x] AC-4: запуск описан в docs, архитектурные проверки и analyzer проходят.
- [x] AC-5: пользователь получил в чате обзор возможностей пакета с отделением Cloud/generator/CLI.

## Ошибки и границы

- Пустой каталог — штатное состояние, не ошибка и не повод добавлять demo use case.
- Неправильный cwd/program либо отсутствующий target делает launcher непригодным; конфигурационный тест проверяет эти условия.
- Отсутствующий package/bootstrap — ожидаемый compile RED новой capability; ошибки SDK/runner не считаются RED.

## Test Scenarios

- TS-1/AC-1: вызвать bootstrap, проверить реальный Widgetbook в tree, пустые directories/addons/integrations и отсутствие exceptions.
- TS-2/AC-2/3: прочитать реальный launch.json, проверить Flutter launch schema, cwd, раздельные program paths и существование target files. JSON maps используются только на границе чтения конфигурации.
- AC-4: analyzer и make architecture-test после implementation; до теста baseline проверен.

## Implementation Plan

Plan v2 (behavior-preserving follow-up):

1. Перенести существующий runApp/Widgetbook.material в main_widgetbook.dart и удалить app/widgetbook_bootstrap.dart; пакет, каталог и VS Code профили не меняются.
2. Тест запускает entrypoint напрямую; assertions пустого каталога и конфигурации сохраняются. Для этого checker получает узкое разрешение test → lib/main_widgetbook.dart, без разрешения runtime-слоям импортировать entrypoints или ослабления остальной матрицы.
3. Документировать временный standalone bootstrap Widgetbook по прямому запросу пользователя и тестовое исключение; общую архитектуру приложения не переносить в root.
4. Выполнить test set, analyzer и architecture-test; подтвердить отсутствие app bootstrap и сохранение main.dart/launcher.

Files v2: lib/main_widgetbook.dart, удаление lib/app/widgetbook_bootstrap.dart, test/widgetbook_bootstrap_test.dart, checker и regression cases, R-003.e и документы запуска/проверки. Pubspec и launch.json в этой итерации не меняются. Билды/коммиты не запрошены.

## Test Evidence

- Baseline, 2026-10-12: make architecture-test с явным путём Dart SDK — 39 сценариев прошли; текущий клиент — 1 файл, imports без нарушений. Node rules checker — 12 leaf, 2 группы.
- RED_CONFIRMED, 2026-10-12, test set v1: `flutter test --no-pub test/widgetbook_bootstrap_test.dart`, cwd apps/tournament_app, exit 1. Runner загрузил тест; ожидаемые compile diagnostics: Couldn't resolve package widgetbook, отсутствует lib/app/widgetbook_bootstrap.dart, Method not found bootstrapWidgetbook. Это отсутствие запрошенной capability, не ошибка SDK/runner.
- Тест после запуска только отформатирован, смысл сценариев не менялся. TS-2 ещё не дошёл до assertions из-за compile RED общего test-файла; его успех не заявляется.
- Stage PLAN_READY → RED_CONFIRMED → AWAITING_APPROVAL. Pubspec, lib/main_widgetbook.dart, bootstrap и .vscode/launch.json до approval не изменены/не созданы.
- GREEN, 2026-10-12, test set v1: `flutter test --no-pub` из apps/tournament_app — 2 tests passed. Оба сценария реально выполнились; смысл tests не менялся.
- `flutter analyze --no-pub` — No issues found. Первоначальные 3 info по braces в tests исправлены без изменения поведения.
- `make architecture-test` — 39 regression cases passed, 4 Dart-файла клиента прошли imports-check; node rules checker — 12 leaf, 2 группы. Markdown-ссылки и diff-check проверены.
- `git diff --exit-code -- apps/tournament_app/lib/main.dart` подтвердил неизменность обычного entrypoint.
- DTD найден и подключён к VS Code, но активных Flutter-apps нет; hot reload/restart недоступен. Desktop/Web/F5 запуск и build не выполнялись; startup подтверждён widget-тестом и проверкой launcher configuration, не реальным нажатием F5.
- GREEN v2: flutter test --no-pub — 2 passed; Flutter analyzer и analyzer checker — No issues found. Architecture self-tests — 49 passed (добавлены 10 cases узкого исключения); imports-check — 3 Dart-файла, без нарушений.
- V2: app-папка и bootstrap отсутствуют, main_widgetbook содержит прямой runApp; main.dart неизменён. Rules checker, links и diff-check прошли. Запущенных apps в DTD по-прежнему нет, restart/build не выполнялись.

## Approval

- Пользователь, 2026-10-12: «делаем».
- Контекст: ответ после RED-gate отчёта о пустом Widgetbook, отдельном entrypoint и профилях VS Code.
- Утверждены specification v1, plan v1 и test set v1; expected compile RED подтверждён в Test Evidence.
- Согласование v1 не переносилось автоматически на spec/plan v2; отдельный baseline GREEN gate пройден до следующей записи approval.
- Пользователь, 2026-10-12: «да», ответ на baseline GREEN gate и plan v2 переноса в entrypoint. Spec/plan v2 и механическая адаптация tests v2 утверждены.

## Changelog

### Итерация 1

**Prompt пользователя**

> так первая задача по работе с приложением. Добавляем отдельный main_widgetbook и отдельный запуск для vscode. Добавляем пакет widgetbook пока что без каких либо виджетов. и напиши мне в чате все возможности этого пакета

**Изменения и проверки**

- Discovery официальной документации и baseline выполнены; spec/plan записаны. Создан и запущен test set v1, compile RED подтверждён по отсутствующему package/bootstrap. Production/config изменения отложены до gate.

### Итерация 2

**Prompt пользователя**

> делаем

**Изменения и проверки**

- Contextual explicit approval записан до первого production diff; Stage AWAITING_APPROVAL → IMPLEMENTING. Scope и смысл тестов не меняются.
- Добавлены dependency widgetbook ^3.25.0 (resolver установил 3.25.0), main_widgetbook, void bootstrap в app и два профиля .vscode/launch.json.
- Без widgets/use cases/addons/Cloud и собственной темы. Используется стандартная оболочка пакета; приложение/генератор не реорганизованы.
- Pub get штатно обновил generated native plugin registrants Linux/macOS/Windows для транзитивного url_launcher. Это не ручная правка generated-кода.
- Исправлено оформление if в тестах после analyzer; тестовые критерии/версии не менялись. Документация запуска добавлена в docs/development/widgetbook.md и индекс/README.
- Stage IMPLEMENTING → GREEN → VERIFYING → DONE. Результаты и пределы проверки записаны в evidence выше.

### Итерация 3 — standalone entrypoint

**Prompt пользователя**

> давай сделаем прпавки убери app с бутстрап сделай все внутри main_widgetbook потом решим как этим пользоваться

**Изменения и проверки**

- Переоткрыта задача 32, записаны spec/plan v2. Это перенос без смены поведения: допускается baseline GREEN gate.
- Baseline: flutter test --no-pub — 2 passed; make architecture-test — 39 passed, текущие 4 Dart-файла прошли. Production/tests/checker пока не менялись.
- Stage DONE → DISCOVERY → PLAN_READY → BASELINE_GREEN → AWAITING_APPROVAL. Новое согласование пока не получено.
- Понадобится адаптация package import теста к entrypoint и узкое тестовое разрешение checker; runtime-зависимости слоёв сохраняются.

### Итерация 4

**Prompt пользователя**

> да

**Изменения и проверки**

- Approval plan v2 записан до изменений кода; Stage AWAITING_APPROVAL → IMPLEMENTING.
- Запуск перенесён в main_widgetbook.dart; отдельный bootstrap и пустая app-папка удалены. Тест вызывает entrypoint напрямую; его assertions сохранены.
- В checker разрешён только test import в конкретный main_widgetbook.dart. Positive/conditional case, отсутствие target, запреты других entries, export/part и runtime imports покрыты regression cases; остальная матрица не изменялась.
- Временная организация и исключение отражены в docs и R-003.e. Поведение каталога, package и launcher сохранены.
- V2 GREEN и final verification выполнены; Stage IMPLEMENTING → GREEN → VERIFYING → DONE.

### Итерация 5 — диагностика F5 в Edge

**Prompt пользователя**

> а вот через vs code не запускается

> Failed to launch browser after 3 tries.

> нет нужно починить ткущий

**Изменения и проверки**

- Пользователь требует сохранить текущую браузерную debug-интеграцию; замена на web-server отклонена.
- 2026-10-12: прямой `flutter run -d edge -t lib/main_widgetbook.dart --no-pub -v` успешно получил DevTools listening и запустил main. Дефект F5 этим запуском не воспроизведён.
- В локальном Flutter SDK сообщение о трёх попытках возникает, если stderr браузера завершился без DevTools listening. Сообщение само по себе не устанавливает причину завершения браузера.
- Доступные VS Code logs не содержат stderr неудачного browser launch. Нужен Dart: Capture Logs конкретного F5-запуска. Runtime-конфигурация и тесты не изменены; исправление и GREEN пока не заявляются.

### Итерация 6 — причина установлена, gate v3

**Prompt пользователя**

> та же ошибка

Пользователь приложил подробный Flutter Run log: приложение компилируется, Edge завершается без DevTools listening, три попытки занимают 149 мс.

**Specification/plan v3**

- Цель: исправить существующий Widgetbook debug-профиль без web-server, замены браузера, правок SDK, отключения sandbox/security и глобальных настроек ОС.
- AC-6: профиль Widgetbook очищает только унаследованный __COMPAT_LAYER; обычный профиль приложения, cwd/program и выбор устройства не меняются.
- AC-7: реальный web debug Edge стартует без проблемной переменной; F5 после правки требует отдельного подтверждения пользователем, прямой запуск не выдаётся за F5.
- Plan: добавить env.__COMPAT_LAYER с пустым значением только в Widgetbook в launch.json; обновить docs запуска; выполнить конфигурационный/widget-тест, analyzer и diff-check. Границы слоёв не меняются.
- Test set v3: существующий launcher-тест требует env с единственным __COMPAT_LAYER='' в Widgetbook и отсутствие env в обычном профиле. TS-1 пустого каталога сохраняется.

**Диагностика и Test Evidence, 2026-10-12**

- Прочитаны только browser-related переменные Code: присутствует __COMPAT_LAYER=DetectorsAppHealth. Процессы Code не elevated, SDK совпадает с успешным прямым запуском.
- Диагностический `flutter run -d edge -t lib/main_widgetbook.dart --no-pub` с одним __COMPAT_LAYER=DetectorsAppHealth — exit 1, Failed to launch browser after 3 tries. Это воспроизведение реального дефекта, не искусственный отказ теста.
- Тот же debug-запуск без __COMPAT_LAYER и с сохранённой проверенной crashpad-переменной — DevTools/VM Service доступны, Starting application from main method. Переменные менялись только в диагностических дочерних процессах, не глобально.
- RED v3: `flutter test --no-pub test/widgetbook_bootstrap_test.dart` из apps/tournament_app — exit 1, 1 passed / 1 failed. Expected {'__COMPAT_LAYER': ''}, Actual null. Пустой Widgetbook по-прежнему проходит.
- Production launch.json не изменён. Stage DISCOVERY → PLAN_READY → RED_CONFIRMED → AWAITING_APPROVAL. Новое approval v3 ожидается.

### Итерация 7 — исправление отложено, изменение процесса

**Prompt пользователя**

> не не надо. Давай TestGate будет применяться не для всего подряд а для кода вне визуализаци по типу domain, infrastructure, app крч все что связано с логикой. тестировать все подряд как будто перепбор

**Изменения и проверки**

- Исправление launch.json не применяется в этом ходе. Изменение процесса продолжается в задаче 31; runtime-профиль сохранён.
- TestGate для локальной debug-конфигурации больше не нужен. Только два собственных assertions v3, подготовленных для gate, удалены; остальное покрытие сохранено. `flutter test --no-pub test/widgetbook_bootstrap_test.dart` — 2 passed.
- Исторический RED и установленная причина __COMPAT_LAYER сохраняются выше. Текущий статус 🟣/PLAN_READY: fix известен, но отложен пользователем; F5 не исправлен и не объявляется успешным.

### Итерация 8 — исправление debug-профиля

**Prompt пользователя**

> и исправь запуск чтоб он был стабильным

**План и критерии**

- Продолжить найденное исправление в существующем профиле Widgetbook: env.__COMPAT_LAYER='' только для процесса запуска. Не менять cwd/program, выбор устройства, основной профиль, browser flags, SDK или настройки ОС.
- Проверить запуск из фактических параметров launch.json, предварительно имитируя унаследованный DetectorsAppHealth; повторить запуск и проверить отсутствие runtime errors. Конфигурационный baseline и diff-check сохраняются. F5 отдельно не заявляется проверенным без IDE-вызова.
- TestGate NOT_REQUIRED по действующему workflow; запрос реализации достаточен. Новые assertions наличия env не добавляются.

## Предыдущий итог v2

V2 завершён: весь запуск Widgetbook в main_widgetbook.dart, app/bootstrap удалён. Тесты, оба analyzers и 49 архитектурных сценариев прошли; прямой пользовательский запрос и approval записаны. Каталог и VS Code launch-профили сохранены. Билды и коммиты не выполнялись.
