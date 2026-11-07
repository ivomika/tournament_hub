# Функции классов в Dart

Решение пользователя 7 ноября 2026: верхнеуровневые функции запрещены в Flutter-приложении. [R-003.g](../../ai-context/rules/flutter/003-g-class-owned-functions.md) применяется ко всем lib/test, включая domain, Widgetbook и тестовые helpers. Python/JS и самостоятельный Dart-пакет инструмента checker не входят в Flutter scope.

Поведение размещается в instance/static методах классов по ответственности. Метод без состояния допустим как static, если у него есть конкретный владелец; не собирайте всё в общий Utils. Типы, constants, fixture-данные и tear-offs методов классов могут быть верхнеуровневыми. Lambda initializer не заменяет запрещённую функцию. Getter/setter тоже является поведением. Typedef и локальная функция не являются верхнеуровневым поведением, но остальные правила на них сохраняются.

Примеры: AppBootstrap.run вместо bootstrap; ThemeExtensions.require вместо requireThemeExtension; методы fixture-класса вместо test helpers; builder use case — static метод preview-класса. UI-фрагменты извлекаются в widgets по R-006.a, а не становятся static Widget helpers.

Технически необходимые исключения перечислены точно в правиле: main в entrypoints/runner files, testExecutable в одном Flutter test config и lookupFoundationLocalizations в одном штатном generated-файле. Это не исключение всех tests/generated/tooling файлов. Обязательные hooks делегируют работу классам; generator output не редактируется вручную ради правила.

AST checker обнаруживает top-level FunctionDeclaration и прямые function expressions в top-level initializers, в том числе parenthesized. Анализирует каждую декларацию, не строки/комментарии и не regex. Имена вида build/lookup, аннотации и ignore не обходят контракт. Методы классов/enum/mixin/extension и function typedef разрешены; исходный body/lambda локального метода не является top-level declaration.

Проверка реализована в `tools/domain-check/lib/class_owned_functions.dart` и подключена к общему `inspect` существующего architecture checker. Команды:

- `make architecture-check` — реальные lib/test; любое нарушение даёт CLI exit1, файл, строку и R-003.g.
- `make architecture-test` — fixture tests правила, прежние architecture/theme tests и реальный код.
- `python3 tools/check_theme_contract.py` / `make theme-test` — также запускают guard fixtures перед theme/runtime проверками.

В приложении перенесены 34 authored функции: AppBootstrap/WidgetbookBootstrap.run, ThemeExtensions.require, static builders PrimitiveScalesPreview/SemanticPalettePreview/TypographyPreview и методы четырёх test suites/config environment. Остались 8 обязательных top-level declarations: main в 2 app entrypoints и 4 test files, Flutter testExecutable, generated lookup. Это не исключение файлов целиком. Entry hooks в part libraries не разрешаются даже при совпадении имени/пути; аннотации и ignore не подавляют finding.

Тесты проверяют нормальный, ошибочный и граничный исход. Синтаксис функций распознаётся AST, regex применяется только к имени разрешённого entrypoint файла. Для lambda initializers контракт ограничен прямым FunctionExpression после удаления скобок; непрямые вычисления/возвращаемые closures не анализируются как определение верхнеуровневой функции. Это не запрет всех callback-значений библиотеки.

Реализация и evidence — [задача73](../../ai-context/task-details/73-class-owned-functions.md). Миграция сохраняет shared preview/golden scenarios и реакцию на тему. HTML UI kit, продуктовые компоненты49–71 и штатный generated output не меняются.
