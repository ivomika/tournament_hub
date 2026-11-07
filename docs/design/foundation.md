# Базовый визуальный стиль

## Решение

12 октября 2026 года выбран сдержанный турнирный стиль: тёмная графитовая основа и тёплый золотой акцент. Светлая схема не добавляется. Inter используется для интерфейса, Roboto Condensed — для крупных заголовков и счёта.

Акцент выделяет важное, но не окрашивает каждый блок. Статусы имеют собственные семантические цвета; цвет не заменяет подпись/значок состояния. Этот foundation не определяет новые продуктовые screens или правила турнира.

## Реализация

Основная тема собирается единственной фабрикой `presentation/design_system/foundation/theme/app_theme.dart`. Канонический поток: **primitive const → ThemeData → WidgetTheme → Widget**. `AppFoundation.dark().materialTheme` оставлен только как совместимый facade фабрики; production consumers его не импортируют.

- `foundation/primitives/` содержит исходные Color/TextStyle, scalar и composite defaults. Только `AppTheme.dark()` преобразует их в runtime тему.
- Стандартные цвета и типографика находятся в ColorScheme/TextTheme. Success/warning и character colors — в AppStatusColors; score — в AppTypeRoles.
- AppSpacing, AppShape, AppBorderMetrics, AppElevation, AppMotion, AppResponsive, AppIconMetrics и FoundationLayout — типизированные ThemeExtension с copyWith/lerp, без primitive defaults внутри.
- PaletteTheme.of(context) и TypographyCatalogTheme.of(context) получают текущую Theme.of(context) в build. Каталоги зависят от InheritedTheme, поэтому замена темы обновляет уже существующие элементы.
- Обязательный extension читается через ThemeExtensions.require; неполная assembly даёт StateError, без скрытого возврата к dark constants.

Точные значения и отображение ролей — в [manifest](tokens-manifest.md). Стандартные Flutter controls используют стандартные component themes. ProgressIndicator — штатный Material3 с текущим оформлением SDK; HTML waveform и его motion-параметры не переносятся.

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

Ресурсы: `presentation/l10n/arb/foundation_ru.arb`. SDK gen-l10n создаёт типизированный API `FoundationLocalizations` с intl. Штатный `flutter gen-l10n` создаёт sibling imports между двумя generated файлами. Checker нормализует только эти две ссылки для проверки по R-003.e; остальные generated директивы проверяются без исключений. Generated messages вручную не меняются.

Пока только ru. Новая локаль/тексты расширяют ARB и генерируемый API, а не добавляют ручные словари в widgets.

## Проверки

Contrast tests проверяют основной, вторичный и muted текст, акцент и статусы на всех трёх поверхностях; onAccent на default/hovered/pressed и все пары onContainer/container: минимум 4.5:1. Border — декоративная граница; borderStrong — усиленная. Disabled-цвета не обещают доступность обычного текста и не используются для активного контента.

Рендер тестируется на mobile 390×844 и desktop 1440×900; проверяются верх, середина и низ scrollable-каталогов без overflow. Golden хранится рядом с каждым showcase в golden/<native-os>/. По решению от 12 октября 2026 разработка и comparison выполняются на текущей ОС без обязательного Docker, первоначальный baseline Windows; перенос runtime foundation проверен также на macOS. Наборы разных ОС не смешиваются; [визуальный workflow](../development/visual-workflow.md) описывает порядок.

В основном entrypoint сохранена существующая Hello World заглушка; wiring перенесён в app/bootstrap и подключает ту же ThemeData. Это не реализация новых продуктовых экранов.

## Автоматический контракт

`python3 tools/check_theme_contract.py` (или `make theme-test`) выполняет regression tests AST guard, проверку реальных lib/test и Flutter tests замены темы. `make theme-check` запускает статическую часть без Flutter runner. Нарушение даёт ненулевой exit code и finding с файлом, строкой и R-003.d. Границы и исключения — [runtime foundation](../architecture/runtime-theme-foundation.md).
