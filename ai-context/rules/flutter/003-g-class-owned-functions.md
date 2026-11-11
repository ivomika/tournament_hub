# R-003.g. Функции принадлежат классам

## Применение

Обязательное Flutter-правило для всех Dart-файлов `apps/tournament_app/lib` и `apps/tournament_app/test`, включая domain и Widgetbook. Самостоятельные инструменты `tools/` и другие языки в этот scope не входят.

## Ограничения

- Верхнеуровневые функции запрещены: публичные/приватные, generic, async, generators, expression-bodied, getters и setters. Поведение принадлежит instance/static методам класса с одной ответственностью; enum, mixin и extension members также не являются верхнеуровневыми функциями.
- Нельзя обходить запрет присваиванием function expression (лямбды) верхнеуровневой переменной, в том числе внутри обёрнутого скобками initializer.
- Bootstrap, helper, test callback и Widgetbook builder не получают исключения по имени или назначению: используйте методы и их tear-offs. Регистрации, typed data/constants и ссылки на методы классов могут оставаться на уровне библиотеки.
- Function typedef объявляет тип, а не поведение, и разрешён. Локальные функции не являются верхнеуровневыми; их допустимость отдельно ограничивается другими правилами, включая R-006.a/b.
- Перенос в класс не разрешает Widget-returning helpers, raw styles, лишние зависимости или бизнес-логику в presentation. Правила R-003.a/d и R-006.a/b сохраняются.

## Технические исключения

- Обычная функция `main` в корневых `lib/main.dart`, `lib/main_*.dart` и `test/**/*_test.dart`: обязательная точка входа Dart/runner. Getter/setter с таким именем исключения не получает.
- Функция `testExecutable` только в `test/flutter_test_config.dart`: обязательный test hook Flutter. Другие helpers этого файла переносятся в класс.
- Функция `lookupFoundationLocalizations` только в `lib/presentation/l10n/generated/foundation_localizations.dart`: неизменяемый вывод штатного gen-l10n. Другие имена, generated-файлы и каталоги не исключаются.

Новые framework/generator исключения требуют явного документирования точного имени/пути и positive/negative regression tests. Комментарий ignore, имя main в другом файле или расположение в generated не отключают правило. Framework hooks в part libraries также не разрешены.

## Проверка

Для go_router_builder4.5.3 разрешены только generated top-level getters $appRoutes, $homeRoute и $bootstrapRoute в lib/app/routing/app_routes.g.dart при part of 'app_routes.dart'. Это фиксированная пара владельца/генерации задачи106; произвольные функции/другие файлы не освобождаются. Новый route root требует обновления точного списка и tests; generated код не редактируется вручную.

Обязательны `make architecture-check` и `make architecture-test`. AST checker сообщает файл, строку и R-003.g, завершается ненулевым кодом на нарушении и проверяет lib/test/part-файлы без выполнения приложения. Контракт, миграция и статус реализации — [функции классов](../../../docs/architecture/class-owned-functions.md), [задача73](../../task-details/73-class-owned-functions.md).
