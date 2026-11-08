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
| AppElevation | floating offset(0,8)/blur24/#8007080B; sheet offset(0,−16)/blur48/#6007080B; dialog offset(0,24)/blur80/#88000000 |
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

### Завершение Shape43

AppShape остаётся общей темой. Source16 cases показывают радиусы8/16/24/32/pill, circle и реальные Surface mobile/desktop20. Sheet24 соответствует mobile select UI kit, largeSheet32 — flow-sheet; оба строятся AppSurfaceTheme из текущих AppShape значений с прямыми нижними углами. Команда `node tools/visual-comparison/compare.mjs shape`.

### Завершение Borders44

AppBorderMetrics — единственный runtime источник hairline1/emphasis2/focus3/offset4. Удалён дублирующий ControlMetrics.focusWidth; Button high-contrast focus теперь реагирует на основную border theme. Native roles catalog и настоящий focus consumer проверены заменой толщины5/offset6. Source report: `node tools/visual-comparison/compare.mjs borders`.

## Elevation — сверка45

AppElevation остаётся runtime ThemeExtension для floating/sheet/dialog; scrim#07080bb8 задаётся основным ColorScheme и читается потребителями оттуда. Shadow showcase использует эти реальные роли, scrim проверяется на двух поверхностях. Source floating ×2: `node tools/visual-comparison/compare.mjs elevation`. Native visual binding сохраняет blur теней приложения.

## Motion — сверка46

AppMotion.reveal160ms/curve ease/reduced0 — единственный источник анимации раскрытия RosterRow через его WidgetTheme. AppRosterMetrics хранит только размеры и swipe threshold. Reduced policy берётся из MediaQuery.disableAnimations. Source сравнивает closed/revealed, native clock проверяет80/160ms и замену duration320/linear. Progress использует штатный Material3 CircularProgressIndicator: HTML wave/segment durations не являются Flutter tokens.

## Responsive — сверка47

AppResponsive использует CSS-смысл границы: mobile width≤740, desktop width>740. Consumer WidgetTheme Surface/Button/RosterRow читают текущую extension. Compact круглый action48 desktop /56 touch; primary56 остаётся56 в обеих плотностях. Thresholds1000/1100 описывают композиции прототипов, не глобальные переключатели каждого элемента. Source comparison33 сценария на390/739/740/741/999/1000/1001/1099/1100/1101/1440. Native actual consumer fixture нормальный и textscale1.6; replacement threshold1500 сохраняет mobile в1440. VisualViewport — только capture environment; optional ComparisonScenario.captureSize не является продуктовым токеном.

## Field — реализация51

AppFieldTheme получает single input из текущего TextTheme.bodyMedium18, multiline из labelLarge16 с regular role AppControlMetrics; Inter optical sizing через AppTypeRoles.interfaceStyle. Label/supporting caption14. AppFieldMetrics хранит multiline192 mobile/220 desktop и line1; основной AppTheme собирает extension из FieldPrimitives. Surface одинаковый для обоих представлений, disabled raised/muted. Радиус24 из AppShape.surface; border1 из AppBorderMetrics и цвет outlineVariant (#3a414e); padding single24+border, multiline16+border; label/error gap8. Single56 из touchControlHeight. Focus outline3/offset4.

Invalid/disabled — предложенные состояния HTML. Исходный textarea invalid показывает сообщение без danger-границы (CSS меняет border только input); это сохранено и отмечено у сценария. Error icon24 совпадает с остальными стандартными иконками. Валидация отсутствует; controller/callbacks принадлежат потребителю.

## Select — реализация52

AppSelect<T>/AppSelectOption<T> — controlled выбор; selected value должен присутствовать в options. Desktop trigger56, raised/radius16/border1 outlineVariant, label14, value18/500/1.4, chevron24 вниз/right16. Mobile row48 внутри внешней AppSurface fixture, label16 regular/value16 bold; panel не дублируется в AppSelect. Disabled получает muted.

Mobile открывает showModalBottomSheet с AppSelectSheet (то же дерево, что в fixture): поверхность24 сверху, scrim из ColorScheme, padding12/24/28, handle40×4, close44, title22/600/1.3, description14, option16/500 с padding16+border1. Selected raised/border gold/check24. Новые значения AppSelectMetrics собираются только в AppTheme из SelectPrimitives; остальные идут из существующих runtime ролей. Desktop использует Flutter MenuAnchor: открытое платформенное HTML select не переносится побитово, реальное Flutter-меню проверено отдельным native golden и keyboard test. Настройка приложения/сохранение не выполняются.

## Segmented choice — реализация53

AppSegmentedChoice<T>/AppSegment<T> — controlled single selection без знания формата турнира. Height64 из source --format-control-height=--s6 (AppSpacing.space64), horizontal/gap8, selected vertical inset8 даёт48; pill radius из AppShape. Background surface/selected raised; selected label16/600/onSurface, normal16/400/onSurfaceVariant, disabled muted. Все роли из текущих ThemeData/extensions через AppSegmentedChoiceTheme. Pointer и стрелки только делегируют value, RTL учитывается; маршрут/расчёт формата отсутствует. Source ::before подложка измеряется отдельно от48/64 hit area.

## NumberStepper — реализация54

AppNumberStepper.output/input — одинаковая геометрия на всех viewport: actions56, output48, input32, pill raised. Внешние callbacks задают доступность; вычисления и limits вне DS. AppStepperMetrics содержит local label stack threshold330, disabled format opacity0.4 и numeric features. Source score disabled сохраняет ink/opacity1, format muted/opacity0.4. Label caption14/gap8 на узком контейнере; широкий контейнер размещает label/stepper в строку с gap16. Изменение viewport само по себе не меняет контрол. Numeric input сравнивает32px slot: browser Canvas не учитывает CSS tabular-nums при измерении отдельной цифры, raster/overlay проверяется отдельно.

## Score — реализация55

AppScore.pair/fixed принимает готовые строки и semanticLabel, арифметики нет. AppScoreTheme использует runtime AppTypeRoles.score60/700/line1/tabular; pair desktop80 через AppScoreMetrics, fixed60/gold. Separator текущий titleLarge26 с regular weight/line1/normalTracking/muted. Gap24 и центр из runtime spacing/control metrics. Semantic label объединяет результат без дублирования каждого символа. Source9 сценариев, scaled native pair/fixed.

## ScoreChoice — реализация56

Controlled AppScoreChoice<T> показывает готовые AppScoreOption<T> labels; callback не вычисляет результат. Итоговый UI kit: condensed40/700/line1, minHeight56, gap16, radius16, raised background, selected border/text primary, normal border outlineVariant/text onSurface. Снятые computed values имеют приоритет над CSS из другого competition context (32/8 не относится к итоговому образцу). Keyboard focus, disabled и runtime theme поддержаны.

## Metric — реализация59

AppMetric plain/achievement показывает готовые value/label/semanticLabel. Mobile plain40/center/padding16; desktop plain64/left/minHeight160/surface. Mobile achievement60/gold/icon64 leading/dark surface/inset24; desktop88/line.95/onPrimary/gold/icon64 trailing opacity.65/minHeight180. Desktop inset24 (compact≤1000:20), radius24; label max13ch измеряется текущим runtime шрифтом. AppMetricMetrics собирается в основной теме, consumers используют WidgetTheme. Card занимает доступную ширину; label optical axis задаётся после выбора16px.

## NavigationItem — реализация60

AppNavigationItem передаёт onPressed без app routing. Mobile row56/padding24/label16/leading24/chevron16, внутри внешней nested AppSurface fixture. Desktop tile80/radius24/padding24(≤1000:20)/label18/leading32/chevron16. Gap16 и текущие цвета темы; hover raised, disabled muted, видимый focus. Own WidgetStatesController не передаётся Material ButtonStyle-потребителю, чтобы изменение enabled не уведомляло родителя во время build; pointer/keyboard оболочка использует FocusableActionDetector.

## SectionHeader — реализация61

AppSectionHeader композирует AppButton back/save/edit; callback intents снаружи. Slots56 mobile/48 desktop, итоговый source gap8 в обоих, title compactHeader16/1.4 center и comfortableHeader20/1.3 left. Отсутствие trailing action сохраняет слот. Две строки source44.781px/native44px: допуск1px только long title, остальные controls.5px.

## StatusLabel — реализация63

Typed live/outcome/points и accent/error tone, готовый текст. Live14 regular/1.5 dot8/gap8, outcome14 medium/1.4, points14 semibold/1.4; только текущие colors/styles через WidgetTheme. Inline outcome/points сохраняют glyph box исходного span: TextHeightBehavior без first/last extra leading собирается в AppTheme через AppStatusMetrics. Badge-подложки нет.

## Disclosure — реализация64

AppDisclosure controlled expanded/onToggle/body slot, без app state. Summary56/title16medium1.4/secondary/icon24; open chevron поворачивается90°. Body caption14/21 padding top8 bottom16, desktop horizontal4. Native TextButton обеспечивает keyboard activation, Semantics.expanded отражает внешний контракт. В исходнике нет reveal transition — конечные состояния без выдуманной анимации.

## Notice — реализация65

AppNotice information/operationError/inlineError использует caption14/21, gap8, top alignment и AppIcon.standard24 во всех вариантах. Information secondary/info, error error/alert. Текст и liveRegion передаются снаружи; сохранения/валидации нет. Flexible сохраняет естественную ширину source span, длинный текст переносится в доступных constraints.

## ProgressIndicator — реализация66

AppProgressIndicator — изолированный visual adapter к M3ELinearWavyProgressIndicator (m3e_progress_indicator0.0.3, MIT). В установленном Flutter SDK волнистого LinearProgressIndicator ещё нет; пакет не выдаётся за штатный SDK widget. Основная ProgressIndicatorThemeData задаёт active/track цвета; AppProgressMetrics задаёт область240×10, stroke4/track4, wavelength20, speed20px/s; gap/stop из AppSpacing.space4. Primitive → AppTheme extensions → WidgetTheme → adapter.

При disableAnimations используется статичная фаза.6 и TickerMode=false; semantics сообщает только локализованную загрузку, а не60% завершения. Смена reduced mode пересоздаёт только внутренний визуальный adapter для немедленного применения. Motion и Components показывают один и тот же компонент. HTML waveform не считается стандартом: source отчёт явно ожидает только отличие высоты24→10, native start/mid/reduced/theme — основной baseline.

## DataTable — реализация67

AppDataTable typed columns/rows/text-or-identity cells; caption/headers, числовые ячейки выравниваются справа. Расчёта рейтинга/сортировки нет. AppIdentity принимает явную WidgetTheme: avatar40, primary16/600/1.3, secondary14/700/1.5, avatar gap8/text gap4. Это переиспользование Identity, не второй компонент. Column shares измеряются текущим шрифтом, numeric min32 включает padding (border-box). Mobile cell padding8/0, desktop16/8. Дробные CSS45.796px/native46px на3 строках дают0.609px, comparison геометрический допуск.75px. Числовые cell widths/centers проверяются отдельно от содержимого.

## BracketNode — реализация68

AppBracketNode ready/current/pending, готовые label и2 typed participant/placeholder slots, nullable intent. Width220/min116, surface/radius16/border1 outlineVariant/current2 primary; inset12+border/gap8. Compact AppIdentity переиспользует AppAvatar28/radius8/Inter11bold, primary14bold/secondary11regular; text column занимает остаток строки. Label12medium/1.3, unknown13/28min. AppBracketMetrics собирается основной темой.

Compact Identity exactLineBoxes сохраняет дробную высоту runtime style.fontSize×height×textScaler (15.6/16.5px), убирая накопление1.406px округления; не вводятся pixel offsets или фиксированные raster высоты. Геометрия сравнивается с.5px, baseline estimate1.25px. Старые Identity/Table fixtures остаются без exactLineBoxes и проверяются регрессией.

## Dialog — реализация69

AppDialog: mobile radius32/inset24/title18/1.35, desktop radius24/inset28+border1/title22/1.3. Body16 regular/24, gap16, action gap8 и дополнительные8 перед действиями. Реальные AppButton contextual dialogDestructive/dialogCancel сохраняют radius16/no shadow/center16semibold, danger surface/error и transparent/secondary. Внешние callbacks не удаляют участника.

Source CSS уточнил AppElevation.dialog: offset24/blur80/#0008; исправлены единственные primitives и обновлён owning native shadows showcase. Реальный Widgetbook showDialog использует cancel initial focus/closed-loop Tab/Escape/return focus, семантику route. Source-компонент без device/overlay chrome сравнивается отдельно, настоящая modal проверяется native interaction test.

## QR code — реализация70

AppQrCode принимает data (текст ссылки), semanticLabel и optional code; генерирует QR через изолированный qr4.0.1 adapter, без сети/создания сессии. Минимальная version4 сохраняет исходные33×33 модуля; длинные данные автоматически увеличивают сетку. ECC-M, явный UTF8 ECI. Собственная immutable матрица не раскрывает типы библиотеки.

Renderer соединяет модули одним Path, радиус exposed corners.32; finder outer1/gap.65/center.5, quiet zone4 в module units. Эти proportions идут primitive → AppTheme/AppQrMetrics → AppQrCodeTheme → painter. Runtime foreground=scaffoldBackgroundColor/background=onSurface, radius32, preferred288 mobile/320 desktop. Source preview220 остаётся внешним constraint; подпись condensed26/700/1.2 и padding horizontal16/bottom24.

PNG-маска больше не используется runtime. При изменении payload изменяется реальный QR pattern; source comparison проверяет прежнюю геометрию и подпись, raster отличается от статичного SVG намеренно. Независимый decoder проверяет готовое изображение220/320px для короткой, длинной и UTF8 ссылки. Контракт и ограничение тестового decoder: [генерация QR](qr-generation.md).

## ShareLink — реализация71

AppShareLink показывает переданные role/address и композирует AppButton.shareIcon; Clipboard/services отсутствуют, onCopy — внешний nullable intent. Caption14/1.5 из TextTheme, padding16/gap8/radius24 из extensions; surface mobile/background desktop; copy56/48 без тени. Для соответствия CSS overflow-wrap:anywhere адрес подавляет Unicode line-break после slash через word joiner: длинный сегмент переносится внутри строки. Исходные данные и semanticsLabel остаются без служебных символов. Четыре source сценария + native scaled/theme/keyboard/null checks.
