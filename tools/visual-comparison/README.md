# Визуальный пилот Avatar

Фиксированный test-only harness для задачи57. Использует оригинальные DOM/CSS образцы `ui-kit.html#c-avatar` и настоящий AppAvatar через общую AvatarFixture. Это пилот одного элемента, а не универсальный production checker или замена native goldens.

## Воспроизведение на macOS

1. Запустить `python3 tools/serve_prototype.py` (порт8094). Если сервер уже работает, использовать его.
2. Запустить отдельный Chrome с новым временным профилем:

```sh
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless=new --disable-gpu --no-first-run --no-default-browser-check --user-data-dir=/private/tmp/tournament-avatar-chrome --remote-debugging-port=9226 about:blank
```

3. Из корня выполнить `node tools/visual-comparison/test/capture_avatar.mjs`. Node24 использует встроенные fetch/WebSocket; внешних browser packages нет. Скрипт снимает7 размеров ×2 формы ×2 viewport из исходного UI kit, ждёт font readiness, сохраняет PNG и computed measurements. DOM изменяется только в изолированной headless странице, исходные файлы UI kit не меняются.
4. Из `apps/tournament_app` выполнить:

```sh
flutter test --no-pub test/presentation/design_system/components/avatar/avatar_visual_test.dart
```

Тест создаёт Flutter PNG, overlay50/50, absolute RGB diff×4 и измерения в `docs/design/prototype/comparison/avatar`. Одновременно сравнивает17 native macOS baselines:14 основных (общие для двух viewport) и3 data-cases. Первичное создание/намеренное обновление baseline делается отдельно с `--update-goldens`, после просмотра обязательно обычное comparison.

5. Из корня выполнить `node tools/visual-comparison/test/render_avatar_report.mjs`.
6. Открыть [локальный отчёт](http://127.0.0.1:8094/comparison/avatar/index.html).

## Что сравнивается

- Размеры контейнера и центр текстового блока, font size/weight/line-height/tracking, actual foreground/background, радиус и отсутствие border.
- Glyph ink bounding box в пикселях и baseline. Исходный CSS font alias Condensed и Flutter RobotoCondensed используют один локальный Variable TTF.
- Каждый из28 web/Flutter случаев остаётся в отчёте вместе с исходными снимками и JSON. Pixel counter не является автоматическим решением о приёмке: он считает Σ|ΔRGB|>12, mean delta записывается без такого отсечения. Diff усиливается в4 раза только для отображения.
- Browser font bounding metrics округляются до целых CSS pixels. Для baseline проверяется отклонение≤0.5px, для raster ink edge≤1 physical px; центр layout-блока проверяется с0.01px. Это разные уровни сравнения, не скрытый общий допуск для отступов/размеров.
- Контроль: реальному AppAvatar подставляется тема с ошибочным contentAlignment. Внешний размер/форма сохраняются; буква смещается на5px. Тест обязан обнаружить этот внутренний дефект. Контрольный образец явно помечен и не является состоянием компонента.

## Результат пилота

Все28 размеров/стилей/центров/baseline прошли контракт.24/28 случаев имеют идентичные integer ink bounds. У112px, обе формы и оба viewport, ink отличается на1px поY; измеренная baseline Chrome69.5 / Flutter69.671875. Эти4 случая помечены в отчёте, не объявлены pixel-perfect. Остаточное сглаживание видно в diff и mean delta. Смещение не компенсировалось специальными offsets по размеру.

Проверялись альтернативные TextHeightBehavior: они ухудшали другие размеры и исключены. Сохранено штатное CSS half-leading через TextLeadingDistribution.even в runtime теме ([Flutter API](https://api.flutter.dev/flutter/dart-ui/TextLeadingDistribution.html)).

Пилот подтверждает работу процесса и чувствительность к ошибке внутри компонента. Для будущих составных элементов потребуются свои контрольные узлы: иконка, текстовые блоки, счёт и промежутки. Avatar этого ещё не доказывает.
