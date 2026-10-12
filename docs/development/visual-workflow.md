# Widgetbook и golden: рабочий процесс

## Назначение

Каждый проектный визуальный компонент DS и каждый screen имеют воспроизводимое визуальное сравнение. Организация элементов и контрактов описана в [архитектуре presentation](../architecture/presentation-ui.md). Нормативные ограничения — в Flutter rules; [TestGate](../../ai-context/workflow.md) логики остаётся отдельным процессом.

## Единый сценарий

Сначала перечислить основной вид и значимые состояния: loading/empty/error, selected/disabled, длинные данные, доступные действия — только те, которые поддерживает контракт. Не нужен декартов продукт всех возможных knobs. Реально важная граница не пропускается ради малого числа PNG.

Каждый сценарий определяет входные данные, theme, locale/direction, viewport/DPR/text scale, состояние presentation-контракта и фазу анимации. Его fixture и именованный builder используются **и Widgetbook, и golden test**. Golden не строит независимую копию UI. Fixture не импортирует flutter_test; тестовые matcher/capture принадлежат только test/. Идентификатор сценария стабилен; строка файлового имени — внешнее представление, не предметный статус.

Widgetbook зеркалит scopes foundation/components/widgets/screens. Внутри конкретного элемента каждый use case в собственной папке, например `widgetbook/components/<element>/<state>/`. В папке — регистрация use case, fixture/preview contract и именованный builder либо отдельный preview-widget, когда нужны параметры. Общая registry собирает scopes, не содержит implementation всех примеров в одном файле.

Knobs помогают исследовать варианты, но не заменяют именованный сценарий и его PNG. В Widgetbook нет подключения к реальному DI, сети, БД или бизнес-use cases; сценарий передаёт preview presentation-контракт. Авторский UI-текст использует intl; подписи tooling-каталога/идентификаторы сценариев не подменяют переводы продукта.

## Эталон и тест

- PNG находится в `golden/<native-os>/` рядом с компонентом/экраном. Сейчас используется `golden/windows/`; будущие наборы — `golden/linux/` и `golden/macos/`. Это baseline, коммитируемый вместе с согласованным визуальным изменением.
- Тест расположен в `test/presentation/` с зеркальной структурой. `flutter_test`, сравнение файлов и test harness не попадают в lib.
- Новый элемент: основной вид + значимые состояния. Screen дополнительно фиксирует mobile и desktop. Точные размеры принадлежат versioned render-профилю и не выбираются случайно каждым тестом.
- Темы/value objects без UI не получают бессмысленных PNG. Визуальные foundation-примитивы получают golden как остальные компоненты.
- Каталог Widgetbook/third-party chrome не заменяет goldens продукта и не требует эталона каждой панели пакета.

PNG без теста, который реально сравнивает рендер с ним, — не golden-покрытие. Тест должен падать при отсутствии baseline и неожиданном diff, а не молча его создавать. Обычная проверка никогда не использует `--update-goldens`.

## Нативная среда и отдельные наборы платформ

По решению пользователя от 12 октября 2026 генерация и comparison выполняются на текущей ОС разработки, без обязательного Docker. Для текущих эталонов зафиксированы Windows x64, Flutter 3.47.1 / Dart 3.13.1 и font assets из foundation manifest. Не использовать плавающий stable для обновления baselines. Обновление SDK/шрифтов/renderer — отдельное явно описанное визуальное изменение.

Harness фиксирует размер поверхности, DPR, locale, direction, text scaling, тему, шрифты и animation state. Product typography использует реальные bundled fonts; тестовый Ahem не выдаётся за корректный product font. Шрифты загружаются до capture, сеть запрещена. Время/данные стабилизируются fixture; нельзя полагаться на локальную ОС, timezone, случайность или системные fallback fonts для поддерживаемых символов.

Windows сравнивается только с Windows, Linux с Linux, macOS с macOS. Новый platform set создаётся нативно и просматривается отдельно; нельзя копировать PNG другой ОС или использовать fallback. Отсутствующий baseline вызывает ошибку comparison, не silent skip. Текущая задача не требует прогона всех ОС, но успешный Windows suite не означает проверку Linux/macOS. Если нужную проверку выполнить нельзя, записать NOT_RUN и причину.

## Изменение UI

1. Найти компонент/тему и все затронутые screens/scenarios; новый элемент разместить в DS, не копировать его в screens.
2. Изменить UI/тему и сценарии в пределах запроса; logic changes отдельно проходят TestGate.
3. Выполнить comparison существующих goldens текущей ОС. Визуальный mismatch при намеренном изменении не означает ошибку реализации, но каждый diff должен иметь объяснение.
4. Агент обновляет **только затронутые** эталоны текущей ОС, затем повторяет comparison без update. Массовое обновление без просмотра не допускается; эталоны остальных ОС не переписываются.
5. Показать пользователю результат: новые/изменённые PNG и существенные различия, желательно before/after. Отдельного approval для обновления baseline не требуется; это не разрешает unrelated визуальные изменения.
6. В карточке: сценарии, environment/SDK/fonts, update и compare команды, результаты, scope изменений и неисполненные проверки. Сохранить golden рядом с элементом, тест/fixture и docs одним изменением.

Изменение общего токена требует проверки затронутых потребителей, а не только одного showcase. Если элемент не изменился визуально, достаточно успешного comparison существующего baseline; не нужно создавать PNG-diff ради отчёта.

## Команды и пределы каркаса

`test/flutter_test_config.dart` автоматически устанавливает locale ru, text scale 1 и DPR 1 с reset после теста. Comparator делегирует штатному Flutter comparison/update и versioned URI, но принимает только путь `golden/<текущая-os>/<snapshot>.png`. Он не подменяет SDK pixel comparison и не создаёт PNG сам. `golden_environment_test.dart` проверяет фиксированную среду, оба viewport и запрет другой/отсутствующей platform folder.

Общие render-профили в `presentation/widgetbook/visual_viewport.dart`: mobile 390×844 и desktop 1440×900 логических пикселей при DPR 1. Это размеры тестового контекста, не дизайн-токены размеров UI. Будущий use case и его тест выбирают один профиль; theme/localization/animation fixture задаются самим сценарием. Before capture тест устанавливает physicalSize = profile.size при DPR 1 и регистрирует reset. Изменение этих профилей требует пересмотра соответствующих screen goldens.

Test hook загружает bundled Inter и Roboto Condensed перед тестами. Общие foundation builders используются в Widgetbook и tests; PNG снимаются нативно. Ahem не подменяет выбранные семейства. Удалённый CI пока не создан; при его подключении platform set и SDK фиксируются отдельно.

Из apps/tournament_app: `flutter test --no-pub --update-goldens test/presentation/foundation_preview_test.dart`, затем `flutter test --no-pub`. Первая команда — намеренное обновление, вторая — обычный comparison и остальные tests. Будущая CI обвязка отделяет compare от update и сохраняет failure artifacts. Docker не нужен для локального цикла.

Добавление большого визуального testing framework, генератора Widgetbook и собственного анализатора не требуется для минимального каталога. Golden pipeline не является способом выполнять бизнес-правила или обходить обязательные архитектурные тесты.
