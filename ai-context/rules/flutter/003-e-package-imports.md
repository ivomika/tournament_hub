# R-003.e. Абсолютные Dart-импорты

## Применение

Обязательное правило для Dart-файлов lib и test Flutter-клиента `apps/tournament_app`.

## Ограничения

- Import выполняется только через `package:` или `dart:`. Относительные и абсолютные файловые URI запрещены, включая ссылки внутри того же слоя.
- То же ограничение действует для export, part, URI part of и всех ветвей conditional import/export. Named part of без URI не допускается: принадлежность library должна проверяться явно.
- Package-импорт внутри приложения указывает существующий Dart-файл в app/domain/infrastructure/presentation. Неизвестные названия слоёв, переходы `..`, файловые обходы и корневые barrels запрещены.
- Матрица R-003.a действует также для export и part: barrel не разрешает зависимость от запрещённого слоя.
- В корне lib допустимы только entrypoints `main.dart` и `main_*.dart`; они импортируют собственный пакет только через app. Test может импортировать любой runtime-слой, runtime не импортирует test.
- Для самостоятельного Widgetbook в задаче 32 разрешён только import из test в `lib/main_widgetbook.dart`. Это не разрешает другим слоям импортировать entrypoints и не распространяется на export/part либо другие entrypoints.
- Domain использует только разрешённый чистый Dart SDK и явно допущенные технические пакеты; платформенные библиотеки запрещены по R-003.c.

Для штатного `flutter gen-l10n` допускаются только sibling import между `foundation_localizations.dart` и `foundation_localizations_ru.dart` в `lib/presentation/l10n/generated/`. Генератор не предоставляет package-import режим; checker нормализует эти две ссылки и всё равно проверяет цель/слой. Другие relative URI, export/part и файлы этого каталога исключения не получают (решение задачи72).

## Проверка

Для go_router_builder допускается только парная директива part 'app_routes.g.dart' в lib/app/routing/app_routes.dart и part of 'app_routes.dart' в сгенерированном sibling. Combining builder не выпускает результат с package URI. Checker нормализует только PartDirective/PartOfDirective указанной пары; import/export, другие владельцы и пути исключения не получают. Решение и regression fixtures: задача106 и navigation_boundaries_test.dart.

Обязательны `make architecture-check` и `make architecture-test` при изменении Dart-директив, структуры слоёв или checker.

Контракт и ограничения проверки: [Архитектурный тест](../../../docs/development/flutter-architecture-check.md).
