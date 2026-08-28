# Tournament Hub Flutter app

Минимальный Host/Participant application skeleton. Внутренние architecture layers и feature folders добавляются только задачами, которым они действительно нужны.

Запускать и проверять приложение следует из корня репозитория через `make`; полный список команд находится в [корневом README](../../README.md).

Основное приложение запускается через `lib/main.dart`, Widgetbook — через `lib/main_widgetbook.dart` или `make run-widgetbook`. Каталог содержит project viewports Mobile/Desktop и не импортируется production entry point.

Fighter artwork в `assets/fighters` является generated runtime copy. Источник находится в `docs/source/fighters`; синхронизация выполняется только через `make sync-fighter-assets`, ручное редактирование runtime PNG/manifest запрещено.
