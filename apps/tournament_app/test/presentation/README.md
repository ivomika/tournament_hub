# Визуальные тесты

Тесты будущих компонентов/экранов зеркалят их расположение в presentation; PNG находятся рядом с элементом в lib/.../golden/. Test-only hook `test/flutter_test_config.dart` подключается автоматически и запрещает generate/compare на не-Linux платформах.

`golden_environment_test.dart` проверяет обвязку без создания PNG/продуктовых примеров. Перед первым component golden требуется зафиксировать Linux image/SDK и загрузку реальных bundled fonts. Viewport-профили: `presentation/widgetbook/visual_viewport.dart`.

Полный процесс: [визуальный workflow](../../../../docs/development/visual-workflow.md).
