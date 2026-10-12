# R-006.c. Обязательные визуальные goldens

## Применение

Обязательное Flutter-правило для новых/изменённых проектных визуальных DS-компонентов, композиций, foundation widgets, screens и их тем. Не распространяется на невизуальные tokens/value objects или chrome стороннего Widgetbook.

## Ограничения

- Каждый визуальный элемент имеет собственный executable golden test: основной вид и значимые поддерживаемые состояния; screen дополнительно mobile и desktop.
- PNG baseline хранится в golden/<native-os>/ рядом с элементом (windows/linux/macos); тест — в зеркальной структуре test/presentation. Test harness, matcher и flutter_test не входят в lib. PNG без comparison-теста не является покрытием.
- Затрагивая UI/тему, сформировать рендер и сравнить соответствующие goldens; для нового элемента создать baseline. Общий токен проверяется по всем затронутым потребителям.
- Golden и Widgetbook используют одни deterministic scenarios, данные/preview-контракты и темы. Capture фиксирует текущую ОС, SDK, bundled fonts, viewport, DPR, locale/direction/text scale и animation phase; без live network/случайности/текущего времени.
- Для скорости generate/compare выполняются нативно в текущем окружении, без обязательного Docker/Linux-прогона. Сравнивается только набор текущей ОС; Windows/Linux/macOS PNG не подменяют друг друга. Baseline другой платформы не копируется и не выбирается как fallback.
- При подключении новой платформы отдельно создать/просмотреть её baselines в закреплённой среде. Отсутствующий baseline должен давать ошибку, не silent skip. Успех на текущей ОС не выдаётся за проверку других ОС.
- Агент может обновлять только затронутые baselines в пределах запроса и обязан показать результат/существенные визуальные изменения. Отдельный approval для visual baseline не нужен; logic changes сохраняют TestGate.
- После update повторить comparison без --update-goldens. Не маскировать unexpected regression массовым обновлением и не обновлять baseline в обычном comparison run.

## Проверка

Сопоставить изменённые элементы/темы с scenarios и platform-specific PNG; проверить environment evidence, просмотр diff, повторное compare и показ результата. Отсутствие UI в каркасе — отсутствие product PNG, не фиктивное golden-покрытие.

Подготовка среды и рабочие шаги: [Визуальный workflow](../../../docs/development/visual-workflow.md).
