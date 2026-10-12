# Визуальные тесты

Тесты компонентов/экранов зеркалят presentation; PNG рядом с элементом в lib/.../golden/<native-os>/. Test-only hook test/flutter_test_config.dart подключается автоматически и запрещает compare/update с набором другой ОС либо без platform folder.

golden_environment_test.dart проверяет контекст и guard. foundation_preview_test.dart использует те же builders, что Widgetbook, и включает native golden без skip текущей платформы. Шрифты загружаются локально, viewport-профили в presentation/widgetbook/visual_viewport.dart. SDK/ОС и update/compare команды указаны в docs.

Полный процесс: [визуальный workflow](../../../../docs/development/visual-workflow.md).
