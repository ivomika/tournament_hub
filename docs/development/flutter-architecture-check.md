# Архитектурная проверка Flutter

`make architecture-check` проверяет Dart-файлы lib/test приложения. `make architecture-test` дополнительно выполняет регрессионные сценарии checker. Используется Dart AST из уже установленного analyzer в `tools/domain-check`; Flutter-билд не запускается.

## Контракт

Import, export, part, part of и conditional-ветви допускают только package/dart URI. Внутренние package-ссылки проверяются на существование файла, допустимое имя слоя и разрешённое направление зависимости: app → все слои; domain → domain; infrastructure → infrastructure/domain; presentation → presentation/domain. Обратные зависимости к entrypoints запрещены.

В корне lib разрешены main.dart и main_*.dart; их внутренние imports ведут только в app. Остальные файлы находятся в одном из четырёх слоёв. Checker не требует создавать пока пустые слои и не подтверждает, что entrypoint действительно вызывает bootstrap: это review по R-003.a.

Test может использовать все runtime-слои через package URI. Package URI всегда относится к lib, а не к test. Относительные импорты между тестовыми helpers также запрещены: для общих тестовых helpers нужен самостоятельный Dart-пакет либо отдельное документированное решение; checker не придумывает несуществующий package-путь к test.

Задача 32 определяет узкое тестовое исключение: import из test в lib/main_widgetbook.dart разрешён для проверки самостоятельного Widgetbook entrypoint. Другие entrypoints, export/part и runtime-зависимости такого разрешения не получают. Временная организация самого Widgetbook описана в [руководстве](widgetbook.md).

Domain допускает dart:core, async, collection, convert, math и typed_data. Допущенных внешних domain-пакетов пока нет. Добавление требует решения по R-003.c и изменения allowlist checker с regression case. Остальные слои могут использовать внешние пакеты; библиотечные типы в публичных контрактах всё равно проверяются при review.

## Границы

Тест обнаруживает структурные зависимости и ошибочные директории, а не все нарушения архитектуры. Он не анализирует бизнес-правила в теле методов, DI-вызовы, публичные SDK-типы и непрямое поведение внешних пакетов. Generated Dart-файлы не исключаются. Единственное узкое решение для штатного gen-l10n: sibling import между foundation_localizations.dart и foundation_localizations_ru.dart в presentation/l10n/generated нормализуется в package URI и проверяется обычным способом. Другие relative URI и part не допускаются.

Ошибки выводятся с файлом, строкой и rule ID; любой finding даёт ненулевой exit code. Синтаксические ошибки Dart и неизвестные URI также приводят к отказу. Анализ не исполняет код приложения.

## Theme boundaries (R-003.d)

Общий checker вызывает theme AST guard. `make theme-test` / `python3 tools/check_theme_contract.py` дополняет структурную проверку регрессиями и реальной runtime заменой темы. Полный контракт, разрешённые tooling boundaries и пределы parse-only анализа — [runtime foundation](../architecture/runtime-theme-foundation.md).
