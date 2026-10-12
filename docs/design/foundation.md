# Базовый визуальный стиль

## Решение

12 октября 2026 года выбран сдержанный турнирный стиль: тёмная графитовая основа и тёплый золотой акцент. Светлая схема не добавляется. Inter используется для интерфейса и счёта, Roboto Condensed — для двух крупных ролей заголовков.

Акцент выделяет важное, но не окрашивает каждый блок. Статусы имеют собственные семантические цвета; цвет не заменяет подпись/значок состояния. Этот foundation не определяет новые продуктовые screens или правила турнира.

## Реализация

Общая типизированная тема — `presentation/design_system/foundation/app_foundation.dart`. Цвета и типографика располагаются в отдельных scopes, значения описаны в [manifest](tokens-manifest.md). Виджеты не выбирают raw colors, text styles или размеры: визуальные параметры приходят из их component themes.

Foundation разделён на три уровня:

- ColorPrimitives — именованные static const Color, шесть шкал по 11 оттенков. Это значения, не enum с вычислением цвета.
- AppColors.dark — immutable semantic ссылки на primitives: поверхности/текст, accent hovered/pressed/focus, disabled и container/onContainer. Нет forRole или строкового lookup.
- AppTypography — готовые static const TextStyle: display, heading, title, bodyLarge, body, label, caption, score. Они не связаны с палитрой; component theme назначает цвет через copyWith.

`PaletteTheme` и `TypographyCatalogTheme` используют общий foundation и готовые стили. Layout берётся из FoundationLayout. Enum нужен для реального выбора варианта/состояния компонента, не для доступа к именованному токену. Label в preview-данных — отображаемая подпись, а не discriminator.

### Шрифты

Шрифты подключены как локальные variable TTF, без runtime HTTP или google_fonts. В TextStyle явно задаётся ось wght; размер/weight/line height принадлежат text role. Счёт использует tabular figures, чтобы цифры не меняли ширину при смене результата.

Источники — [Inter](https://rsms.me/inter/) и [Roboto Condensed в Google Fonts](https://github.com/google/fonts/tree/main/ofl/robotocondensed). Кириллица и OFL лицензии относятся к фактически закреплённым файлам; OFL.txt лежат рядом с assets.

| Asset | Upstream revision | SHA-256 |
| --- | --- | --- |
| assets/fonts/inter/Inter-Variable.ttf | 0b58fb370093f9a9f4ff785d94405710b79de67c | 29160a80ff49ddcab2c97711247e08b1fab27a484a329ce8b813d820dc559031 |
| assets/fonts/roboto_condensed/RobotoCondensed-Variable.ttf | 69d0549e8fc7ad72e1531734c81237be401ec4fd | dace262afcee68a5276f200d8026c57221735c0118ab5fda8c2c0d3dc409a8d0 |

FontLoader в test/flutter_test_config.dart загружает те же assets до capture. Ahem/system fallback не используются как подмена product typography.

## Widgetbook

- Foundation → Colors → Primitive scales: graphite/gold/green/red/blue/amber, уровни 50–950, имена const tokens и HEX.
- Foundation → Colors → Dark palette: semantic ссылки, interaction и пары container/onContainer.
- Foundation → Typography → Text styles: восемь готовых TextStyle, кириллические образцы, font family/size/weight и счёт.

Каждый use case имеет отдельную папку своего scope. Именованные builders используются одновременно в Widgetbook и тестах; `FoundationScenarioHost` задаёт общий контекст темы и русской локализации. Метаданные навигации Widgetbook остаются техническими названиями; авторский текст примеров — в ARB.

## Локализация

Ресурсы: `presentation/l10n/arb/foundation_ru.arb`. SDK gen-l10n создаёт типизированный API `FoundationLocalizations` с intl. После `flutter gen-l10n` два локальных generated import нормализуются в package URI по R-003.e; generated messages вручную не меняются. Команда architecture-test ловит ненормализованные импорты, исключение для generated не добавлено.

Пока только ru. Новая локаль/тексты расширяют ARB и генерируемый API, а не добавляют ручные словари в widgets.

## Проверки

Contrast tests проверяют основной, вторичный и muted текст, акцент и статусы на всех трёх поверхностях; onAccent на default/hovered/pressed и все пары onContainer/container: минимум 4.5:1. Border — декоративная граница; borderStrong — усиленная. Disabled-цвета не обещают доступность обычного текста и не используются для активного контента.

Рендер тестируется на mobile 390×844 и desktop 1440×900; проверяются верх, середина и низ scrollable-каталогов без overflow. Golden хранится рядом с каждым showcase в golden/<native-os>/. По решению от 12 октября 2026 разработка и comparison выполняются на текущей ОС без обязательного Docker, сейчас Windows/Flutter 3.47.1/Dart 3.13.1. Наборы разных ОС не смешиваются; [визуальный workflow](../development/visual-workflow.md) описывает порядок.

Основной Hello World приложения не мигрируется в этой задаче. Foundation подготовлен для дальнейших UI-задач и подключён к Widgetbook, а не объявлен готовым набором экранов приложения.
