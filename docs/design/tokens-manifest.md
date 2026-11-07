# Manifest foundation-токенов

Текущая схема: **dark graphite / warm gold**. История выбора, assets и проверка: [foundation](foundation.md). Значения в коде и этом manifest обновляются вместе; raw-значения определяются в foundation/primitives и собираются в ThemeData фабрикой foundation/theme/app_theme.dart. WidgetTheme и widgets читают только runtime тему.

## Цвета — primitive шкалы и runtime ColorScheme

ColorPrimitives содержит static const Color. Суффикс — светлота внутри семейства (50 светлый, 950 тёмный), не opacity или ключ runtime lookup. Семантические defaults собираются фабрикой в ColorScheme/AppStatusColors; таблица primitive значений приведена ниже.

| Роль | Значение | Назначение |
| --- | --- | --- |
| background | #0E1014 | Фон приложения |
| surface | #171A20 | Основная поверхность |
| surfaceRaised | #232730 | Визуально поднятый блок |
| border | #3A414E | Декоративная граница поверхности |
| textPrimary | #F4F2EE | Основной текст |
| textSecondary | #B8BEC9 | Вторичный текст |
| textMuted | #969EAC | Подписи, не снижение читаемости через opacity |
| accent | #F1C75B | Основной золотой акцент |
| onAccent | #19150B | Текст на золотом акценте |
| success | #78D7A5 | Успешный результат/состояние |
| warning | #F5B968 | Предупреждение |
| danger | #FF968E | Ошибка/опасное действие |
| information | #8CC3FF | Информационное состояние |

| Дополнительная семантика | Primitive | Назначение |
| --- | --- | --- |
| borderStrong | graphite500 | Усиленная граница |
| disabledSurface / disabledContent | graphite700 / graphite400 | Недоступное состояние |
| accentHovered / accentPressed | gold200 / gold500 | Наведение / нажатие |
| focus | gold200 | Фокус |
| accentContainer / onAccentContainer | gold900 / gold100 | Акцентный контейнер и текст |
| successContainer / onSuccessContainer | green900 / green100 | Успех: контейнер и текст |
| warningContainer / onWarningContainer | amber900 / amber100 | Предупреждение: контейнер и текст |
| dangerContainer / onDangerContainer | red900 / red100 | Ошибка: контейнер и текст |
| informationContainer / onInformationContainer | blue900 / blue100 | Информация: контейнер и текст |

Материальные primary/onPrimary, surface/onSurface, error/onError и outline отображаются на соответствующие семантические роли. Компоненты продукта используют собственные темы и не полагаются на неописанные Material defaults.

## Типографика — runtime TextTheme и AppTypeRoles

| Роль | Семейство | Размер, logical px | Вес wght | Line height |
| --- | --- | ---: | ---: | ---: |
| display | Roboto Condensed | 60 | 700 | 1.05 |
| heading | Roboto Condensed | 40 | 700 | 1.15 |
| title | Inter | 26 | 600 | 1.25 |
| bodyLarge | Inter | 20 | 400 | 1.50 |
| body | Inter | 18 | 400 | 1.50 |
| label | Inter | 16 | 600 | 1.50 |
| caption | Inter | 14 | 400 | 1.50 |
| score | Roboto Condensed | 60 | 700 | 1.00 |

Исходные const styles изолированы в TypographyPrimitives. display/heading/title имеют tracking −2.4/−1/−0.91. TextTheme заполнена полностью: displayLarge/Medium → display; displaySmall и headlineLarge/Medium → heading; headlineSmall/titleLarge → title; titleMedium/bodyLarge → bodyLarge; bodyMedium → body; titleSmall/labelLarge/Medium → label; bodySmall/labelSmall → caption. Цвет текста назначается из текущей ColorScheme. AppTypeRoles.score хранит нестандартную роль с tabular figures. WidgetTheme не импортирует TypographyPrimitives.

## Layout foundation-каталогов — FoundationLayout

| Токен | Значение | Использование |
| --- | --- | --- |
| pagePadding | 24 со всех сторон | Внешние отступы showcase |
| tilePadding | 20 со всех сторон | Внутренние отступы sample |
| smallGap | 8 | Текстовые подписи/metadata |
| gap | 16 | Промежутки между блоками/колонками |
| sectionGap | 32 | Заголовок → набор образцов |
| tileWidth | 320 | Ширина цветовой карточки |
| colorTileHeight | 136 | Высота с запасом для трёхстрочных semantic подписей |
| swatchSize | 44 | Размер цветового образца |
| borderWidth | 1 | Декоративная граница |
| cornerRadius | 16 | Радиус блока |
| swatchRadius | 10 | Радиус цветового образца |
| fullWidth | infinity | Заполнение доступной ширины текстовым образцом |
| textAlignment | start | Выравнивание текстовой композиции |
| centered | center | Вертикальное выравнивание цветового образца |

Все размеры логические. Эти токены нужны текущим каталогам; будущие screen/component themes могут использовать общие токены или вводить документированные semantic параметры, но не копировать raw literals.

## Runtime шкалы

| Extension | Поля и defaults |
| --- | --- |
| AppSpacing | space0/4/8/12/16/20/24/32/48/64 — соответствующие logical px |
| AppBorderMetrics | hairline 1, emphasis 2, highContrastFocus 3, focusOffset 4 |
| AppShape | control 8, nested 16, desktopSurface 20, avatarTile 22, surface 24, panel 32, pill 999; sheet — только верхние углы 24 |
| AppIconMetrics | small 16, medium 20, standard 24 (включая inline error), large 32, display 48, hero 64 |
| AppResponsive | mobileToDesktopWidth 740, compactDesktopWidth 1000, wideCompositionWidth 1100; compactControlHeight 48 / touchControlHeight 56 |
| AppResponsive avatars | extraSmall 28, small 40, medium 48, large 64, profile 96, portrait 112, hero 128; размер выбирается явно, не подменяется breakpoint |
| AppMotion | reveal 160 ms, reduced 0 ms, curve ease; component theme выбирает reduced при отключённой анимации |
| AppElevation | floating offset(0,8)/blur24/#8007080B; sheet offset(0,−16)/blur48/#6007080B; dialog offset(0,20)/blur64/#5507080B |
| AppStatusColors | success/warning и их container/onContainer пары; characterIce #92C9ED, characterFan #C6B4EE, characterStorm #A7D6D1 |

Значения AppThemeColors получаются из текущей темы: background → scaffoldBackgroundColor; surface/raised → surface/surfaceContainerHigh; border/strong → outlineVariant/outline; textPrimary/secondary → onSurface/onSurfaceVariant; muted/disabledContent → disabledColor; accent/hovered/pressed/focus → primary/hoverColor/highlightColor/focusColor. Information использует secondary, danger — error; success/warning — AppStatusColors. Остальные container/onContainer пары следуют соответствующим ColorScheme ролям.

Все ThemeExtension заменяются через ThemeData.copyWith(extensions: ...); при замене сохраняйте остальные extensions. Они не содержат static dark defaults. ProgressIndicatorThemeData подключён к primary/raised и включает текущий штатный Material3 вид (`year2023: false` для используемого SDK); кастомной геометрии/таймингов waveform нет.

## Primitive значения — ColorPrimitives

| Семейство | 50 | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | 950 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| graphite | #F4F2EE | #E5E7EB | #CFD4DE | #B8BEC9 | #969EAC | #6E7889 | #3A414E | #232730 | #171A20 | #0E1014 | #07080B |
| gold | #FFF9E9 | #FFF0C8 | #FFE199 | #F8D576 | #F1C75B | #DCA82F | #B57F16 | #896410 | #6D5015 | #493A16 | #19150B |
| green | #EAFBF0 | #CEF7DF | #A5ECC6 | #78D7A5 | #48C48A | #27A56A | #198653 | #14694B | #13543D | #104532 | #052A1E |
| red | #FFF1EE | #FFDAD5 | #FFB9B0 | #FF968E | #EE7268 | #D9514E | #B83A38 | #96302F | #7B2B2A | #632A2A | #371215 |
| blue | #EEF6FF | #D6EAFF | #B0D7FF | #8CC3FF | #61A7F2 | #3D85D1 | #2E69AF | #28558D | #274971 | #233E5B | #102439 |
| amber | #FFF7E8 | #FFECCD | #FFDAAB | #F5B968 | #E59B43 | #C87C27 | #A7611C | #824D1B | #673F1D | #54341C | #301B0B |

## Render-контекст (не токены дизайна продукта)

Mobile 390×844, desktop 1440×900; DPR 1, locale ru, text scale 1; реальные локальные TTF. В golden снимаются позиции scroll top/middle/bottom, если каталог больше viewport; для полностью помещающегося каталога — только top, без одинаковых PNG. Нативная ОС определяет только папку baseline (golden/windows, golden/linux или golden/macos), не выбор визуальных токенов. Эти профили фиксируют условия сравнения и не определяют обязательную ширину приложения или его screen layout.

## Avatar metrics — задача57

AppAvatarMetrics — runtime ThemeExtension. Источник: computed styles исходных Avatar в UI kit, не размеры соседних identity-compositions.

| Extent | Font size | Tile radius | Round radius |
| ---: | ---: | ---: | ---: |
| 28 | 12 | 7 | 50% |
| 40 | 16 | 10 | 50% |
| 48 | 18 | 12 | 50% |
| 64 | 26 | 16 | 50% |
| 96 | 36 | 16 | 50% |
| 112 | 40 | 16 | 50% |
| 128 | 44 | 16 | 50% |

Line height1, tracking0, contentAlignment.center и CSS half-leading(even). Font family/weight наследуются текущей TextTheme.headlineLarge. Primitive значения проходят только через AppTheme → AppAvatarMetrics/AppResponsive → AppAvatarTheme → AppAvatar. Legacy общий shape.avatarTile22 не применяется к нормализованным Avatar UI kit. [Компонент и сравнение](components/avatar.md).

### AppIcon (48)

Исходные18 SVG symbols из UI kit#icons перенесены Canvas paths; grid24/stroke1.8 primitive → AppGlyphMetrics основной темы → AppIconTheme → AppIcon. Размеры берутся из существующего AppIconMetrics, цвета из текущего ColorScheme. Directional glyphs отражаются в RTL. Сравнение: `node tools/visual-comparison/compare.mjs icons`; scoped fixtures и macOS goldens рядом с foundation/icons. Без нового dependency.

### AppSurface (49)

Surface/raised ← текущий ColorScheme; Shape surface24/desktopSurface20/nested16; inset ← AppSpacing24/0. AppSurfaceTheme выбирает adaptation по AppResponsive. Border/elevation отсутствуют в source. AppTypeRoles.normalTracking0 сохраняет исходную Inter типографику без Material tracking. Raised — предложенная роль UI kit. Команда сравнения: `node tools/visual-comparison/compare.mjs surface`.

### AppButton (50)

Исходные primary/secondary/destructive/neutral/accent icon через AppButtonTheme и runtime AppControlMetrics. RemoveIcon40 и RemoveSwipe88×72 — action slots RosterRow. Colors/TextTheme/Shape/Spacing/Border/Elevation приходят из текущей основной темы. AppTypeRoles.interfaceStyle настраивает Inter optical axis opsz по текущему размеру14..32, weight по текущему TextStyle; создание FontVariation остаётся только в AppTheme. Сравнение `node tools/visual-comparison/compare.mjs button`. Focus outline снаружи4px, thickness3 (compact remove2); размер компонента не меняется.

### AppIdentity (58)

Композиция существующего AppAvatar и primary/optional secondary. Inline/stacked и character/participant — типизированные контракты. Runtime AppIdentityMetrics содержит источник participant18/22, avatar18/24 и corner22, line-height1.4/1.1 и container ratio0.07; остальные значения приходят из текущих TextTheme/ColorScheme/Spacing/Avatar metrics. AppAvatar принимает typed recipe от темы композиции, default не меняется. Сверка `node tools/visual-comparison/compare.mjs identity`; дробная geometry квантована в пределах0.5px.

### AppRosterRow (62)

Runtime AppRosterMetrics: cardHeight208, swipeThreshold24, reveal160ms/ease; размеры mobile/action берутся из AppControlMetrics72/88/40, spacing/shape из общих extensions. Финальный desktop gap16 подтверждён computed CSS (desktop.css позднее переопределяет прежний24). AppIdentity participant stacked исправлен по этому факту, соответствующие macOS baselines обновлены. Внутренняя AppSurface.flat использует theme spacing0 для прямой границы выдвигаемой области; внешнее скругление принадлежит строке. Контракт/проверки: [AppRosterRow](roster-row.md).

### Завершение Colors40

16 исходных цветов UI kit сопоставлены AppThemeColors runtime roles, включая3 character tones;32 source/native сценария ColorsComparison покрывают mobile/desktop. Роли success/warning/information сохранены как дополнительная семантика приложения. Общая команда: `node tools/visual-comparison/compare.mjs colors`. Existing ColorPalette/primitive scales остаются основными showcases.

### Завершение Typography41

AppTextStyles — runtime фасад текущей TextTheme, включая Inter optical sizing из AppTypeRoles; primitive tracking0 предотвращает неявное наследование Material tracking. Standard TextTheme overrides сохраняются. AppTextMetrics содержит компактную/просторную header line-height1.4/1.3, размеры следуют labelLarge/bodyLarge. CSS half-leading закреплён в primitive assembly. Source8 ролей в2 viewport: `node tools/visual-comparison/compare.mjs typography`; Title32.5/33px имеет явно отмеченный baseline допуск1.25px вместо ручной подгонки текста.

### Завершение Spacing42

AppSpacing содержит только глобальную подтверждённую шкалу0/4/8/12/16/20/24/32/48/64. Неиспользуемый28 удалён из global API; локальные insets28 принадлежат будущей композиции. FoundationSampleMetrics отделяет размеры developer showcases от product tokens. Source18 cases и actual inset/gap consumer snapshots: `node tools/visual-comparison/compare.mjs spacing`.
