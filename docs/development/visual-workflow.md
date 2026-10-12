# Widgetbook и golden: рабочий процесс

## Назначение

Каждый проектный визуальный компонент DS и каждый screen имеют воспроизводимое визуальное сравнение. Организация элементов и контрактов описана в [архитектуре presentation](../architecture/presentation-ui.md). Нормативные ограничения — в Flutter rules; [TestGate](../../ai-context/workflow.md) логики остаётся отдельным процессом.

## Единый сценарий

Сначала перечислить основной вид и значимые состояния: loading/empty/error, selected/disabled, длинные данные, доступные действия — только те, которые поддерживает контракт. Не нужен декартов продукт всех возможных knobs. Реально важная граница не пропускается ради малого числа PNG.

Каждый сценарий определяет входные данные, theme, locale/direction, viewport/DPR/text scale, состояние presentation-контракта и фазу анимации. Его fixture и именованный builder используются **и Widgetbook, и golden test**. Golden не строит независимую копию UI. Fixture не импортирует flutter_test; тестовые matcher/capture принадлежат только test/. Идентификатор сценария стабилен; строка файлового имени — внешнее представление, не предметный статус.

Widgetbook зеркалит scopes foundation/components/widgets/screens. Внутри конкретного элемента каждый use case в собственной папке, например `widgetbook/components/<element>/<state>/`. В папке — регистрация use case, fixture/preview contract и именованный builder либо отдельный preview-widget, когда нужны параметры. Общая registry собирает scopes, не содержит implementation всех примеров в одном файле.

Knobs помогают исследовать варианты, но не заменяют именованный сценарий и его PNG. В Widgetbook нет подключения к реальному DI, сети, БД или бизнес-use cases; сценарий передаёт preview presentation-контракт. Авторский UI-текст использует intl; подписи tooling-каталога/идентификаторы сценариев не подменяют переводы продукта.

## Эталон и тест

- PNG находится в `golden/` рядом с компонентом/экраном. Это baseline, коммитируемый вместе с согласованным визуальным изменением.
- Тест расположен в `test/presentation/` с зеркальной структурой. `flutter_test`, сравнение файлов и test harness не попадают в lib.
- Новый элемент: основной вид + значимые состояния. Screen дополнительно фиксирует mobile и desktop. Точные размеры принадлежат versioned render-профилю и не выбираются случайно каждым тестом.
- Темы/value objects без UI не получают бессмысленных PNG. Визуальные foundation-примитивы получают golden как остальные компоненты.
- Каталог Widgetbook/third-party chrome не заменяет goldens продукта и не требует эталона каждой панели пакета.

PNG без теста, который реально сравнивает рендер с ним, — не golden-покрытие. Тест должен падать при отсутствии baseline и неожиданном diff, а не молча его создавать. Обычная проверка никогда не использует `--update-goldens`.

## Каноническая среда Linux

Генерация и comparison эталонов выполняются на единой Linux CI-среде. Зафиксировать Ubuntu/image, точную Flutter/Dart версию и шрифты в репозитории/CI; не использовать плавающий stable для обновления baselines. Обновление SDK/шрифтов/renderer — отдельное явно описанное визуальное изменение.

Harness фиксирует размер поверхности, DPR, locale, direction, text scaling, тему, шрифты и animation state. Product typography использует реальные bundled fonts; тестовый Ahem не выдаётся за корректный product font. Шрифты загружаются до capture, сеть запрещена. Время/данные стабилизируются fixture; нельзя полагаться на локальную ОС, timezone, случайность или системные fallback fonts для поддерживаемых символов.

На Windows разрешены Widgetbook, analyzer и не-golden widget tests. PNG, полученные там, не заменяют Linux-эталоны. При отсутствии Linux runner агент фиксирует NOT_RUN и не утверждает, что golden comparison прошёл. В минимальном пустом каркасе нет production PNG; конкретные font assets и render-профили необходимы до первого реального визуального компонента.

## Изменение UI

1. Найти компонент/тему и все затронутые screens/scenarios; новый элемент разместить в DS, не копировать его в screens.
2. Изменить UI/тему и сценарии в пределах запроса; logic changes отдельно проходят TestGate.
3. Выполнить comparison существующих Linux goldens. Визуальный mismatch при намеренном изменении не означает ошибку реализации, но каждый diff должен иметь объяснение.
4. Агент обновляет **только затронутые** эталоны в Linux, затем повторяет comparison без update. Массовое обновление без просмотра не допускается.
5. Показать пользователю результат: новые/изменённые PNG и существенные различия, желательно before/after. Отдельного approval для обновления baseline не требуется; это не разрешает unrelated визуальные изменения.
6. В карточке: сценарии, environment/SDK/fonts, update и compare команды, результаты, scope изменений и неисполненные проверки. Сохранить golden рядом с элементом, тест/fixture и docs одним изменением.

Изменение общего токена требует проверки затронутых потребителей, а не только одного showcase. Если элемент не изменился визуально, достаточно успешного comparison существующего baseline; не нужно создавать PNG-diff ради отчёта.

## Команды и пределы каркаса

В минимальной обвязке `test/flutter_test_config.dart` автоматически устанавливает locale ru, text scale 1 и DPR 1 с reset после теста. Comparator делегирует штатному Flutter comparison/update и сохранению versioned URI, но отвергает оба режима вне Linux. Он не подменяет SDK comparator и не создаёт PNG сам. В `test/presentation/golden_environment_test.dart` проверяются фиксированная среда, mobile/desktop и запрет Windows compare/update, без fake product baselines.

Общие render-профили в `presentation/widgetbook/visual_viewport.dart`: mobile 390×844 и desktop 1440×900 логических пикселей при DPR 1. Это размеры тестового контекста, не дизайн-токены размеров UI. Будущий use case и его тест выбирают один профиль; theme/localization/animation fixture задаются самим сценарием. Before capture тест устанавливает physicalSize = profile.size при DPR 1 и регистрирует reset. Изменение этих профилей требует пересмотра соответствующих screen goldens.

Test hook не загружает отсутствующие product fonts и не называет Ahem готовой типографикой. До первого component golden нужно добавить реальные font assets/loader и pinned Linux image/SDK. Удалённый CI пока не создан и не запущен; пустой каркас не выдаёт успешный golden suite без baseline.

Используются штатные `flutter test` / `flutter test --update-goldens` для конкретных test paths на Linux. Будущая CI обвязка обязана отделять compare от update и сохранять failure artifacts для просмотра. Сейчас не объявляются существующими удалённый CI runner, font assets или component goldens, пока они реально не добавлены и проверены.

Добавление большого визуального testing framework, генератора Widgetbook и собственного анализатора не требуется для минимального каталога. Golden pipeline не является способом выполнять бизнес-правила или обходить обязательные архитектурные тесты.
