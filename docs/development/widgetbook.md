# Widgetbook

Widgetbook подключён в Flutter-клиент как отдельный entrypoint. Зависимость — `widgetbook: ^3.25.0`; разрешённая версия — 3.25.0. Основной `lib/main.dart` не менялся. Foundation содержит Colors / Primitive scales, Colors / Dark palette и Typography / Text styles; выбор, tokens и font assets описаны в [foundation](../design/foundation.md).

## Запуск в VS Code

Открыть корень репозитория, выбрать Flutter-устройство, затем в Run and Debug выбрать **Widgetbook** и нажать F5. Профиль **TournamentHUB** запускает основное приложение. Оба профиля находятся в [.vscode/launch.json](../../.vscode/launch.json), используют cwd Flutter-клиента и не фиксируют deviceId.

Из `apps/tournament_app` также можно запустить `flutter run -t lib/main_widgetbook.dart -d <device-id>`. Для web выбрать Edge (web) в VS Code. Профиль не подменяет браузер web-server и сохраняет штатную debug-интеграцию Flutter.

### Окружение запуска Edge на Windows

Профиль Widgetbook задаёт `env.__COMPAT_LAYER` пустым значением. Причина: VS Code в проверенном окружении наследует `__COMPAT_LAYER=DetectorsAppHealth`; с этой переменной воспроизведён сбой Edge `Failed to launch browser after 3 tries`, без неё браузер запускает DevTools и приложение. Пустое значение перекрывает родительскую переменную только для дочернего Flutter-процесса и его браузера. Это не изменяет окружение Windows или совместимость самого VS Code.

Не добавлять `--no-sandbox`, не отключать защиту браузера и не менять SDK ради этого сбоя. Исправление адресует подтверждённую причину; другие причины browser launch failure требуют отдельной диагностики. Обычный профиль TournamentHUB не изменён.

## Структура

- `lib/main_widgetbook.dart` вызывает `app/widgetbook_bootstrap.dart`; bootstrap только выполняет `runApp` оболочки `TournamentWidgetbookApp`.
- Оболочка находится в `presentation/widgetbook/widgetbook_app.dart`, scoped registry — в `widgetbook_catalog.dart`. По решению задачи 33 это заменяет временный standalone main задачи 32; основной main.dart и launcher не менялись.
- Будущие use cases располагаются в собственных папках scopes foundation/components/widgets/screens и используют общие с golden сценарии. [Визуальный workflow](visual-workflow.md) описывает добавление и проверку.
- Foundation showcases используют общий тёмный стиль, реальные bundled fonts и ru ARB. Product screens, addons и Cloud integration не добавлены; chrome инструмента предоставляется пакетом.
- Generator, build_runner и отдельный Widgetbook-проект не добавлены. Транзитивные зависимости пакета, включая widgetbook_annotation, устанавливаются pub resolver, но аннотации и генерация в проекте не используются.

## Проверка

Из `apps/tournament_app`: `flutter test --no-pub` и `flutter analyze --no-pub`. Из корня: `make architecture-test`.

Widget-тест вызывает main_widgetbook.main через package import и проверяет реальный Widgetbook-root, foundation-каталог и отсутствие exceptions/addons/integrations. Для этого checker допускает только import из test в main_widgetbook.dart; runtime-слоям импорт entrypoints не разрешён. Конфигурационный тест проверяет разделение entrypoints, cwd и существование target files. Фактический старт F5 на выбранном устройстве этим тестом не подтверждается. Preview-тесты используют те же builders, что каталог; проверяют contrast, mobile/desktop, scroll и нативные golden по платформам.

Возможности и последующие настройки описаны в официальной [документации Widgetbook](https://docs.widgetbook.io/); подключение дополнительных возможностей выполняется отдельной задачей, когда появятся компоненты.
