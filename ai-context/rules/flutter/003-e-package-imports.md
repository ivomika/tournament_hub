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

## Проверка

Обязательны `make architecture-check` и `make architecture-test` при изменении Dart-директив, структуры слоёв или checker.

Контракт и ограничения проверки: [Архитектурный тест](../../../docs/development/flutter-architecture-check.md).
