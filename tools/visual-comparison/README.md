# Общее визуальное сравнение Web ↔ Flutter

Из корня репозитория: `node tools/visual-comparison/compare.mjs roster-row`.

Доступные декларации: `avatar`, `icons`, `surface`, `button`, `identity`, `roster-row`. Вся настройка нового компонента — `ComparisonSpec` со shared fixture builders и именованными контрольными элементами, плюс запись в `ComparisonCatalog`.

Полный процесс, формат и ограничения: [руководство](../../docs/development/visual-component-comparison.md). Native baselines создаются намеренно с `--update-goldens`, затем проверяются без этого флага. Нужны Flutter, Python3 и Chrome; дополнительных Node-пакетов нет.

Отчёты: `docs/design/prototype/comparison/<component>/index.html`. Engine tests: `node --test tools/visual-comparison/test/generic_engine.test.mjs`. Старые отдельные Avatar capture/report scripts заменены общей командой.
