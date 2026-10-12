# Manifest foundation-токенов

Текущая схема: **dark graphite / warm gold**. История выбора, assets и проверка: [foundation](foundation.md). Значения в коде и этом manifest обновляются вместе; raw-значения разрешены в foundation/theme definitions, не в widgets.

## Цвета — primitive шкалы и semantic AppColors

ColorPrimitives содержит static const Color. Суффикс — светлота внутри семейства (50 светлый, 950 тёмный), не opacity или ключ runtime lookup. Семантика — прямые immutable ссылки на эти константы; таблица primitive значений приведена ниже.

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
| disabledSurface / disabledContent | graphite700 / graphite500 | Недоступное состояние |
| accentHovered / accentPressed | gold300 / gold500 | Наведение / нажатие |
| focus | gold200 | Фокус |
| accentContainer / onAccentContainer | gold900 / gold100 | Акцентный контейнер и текст |
| successContainer / onSuccessContainer | green900 / green100 | Успех: контейнер и текст |
| warningContainer / onWarningContainer | amber900 / amber100 | Предупреждение: контейнер и текст |
| dangerContainer / onDangerContainer | red900 / red100 | Ошибка: контейнер и текст |
| informationContainer / onInformationContainer | blue900 / blue100 | Информация: контейнер и текст |

Материальные primary/onPrimary, surface/onSurface, error/onError и outline отображаются на соответствующие семантические роли. Компоненты продукта используют собственные темы и не полагаются на неописанные Material defaults.

## Типографика — готовые AppTypography TextStyle

| Роль | Семейство | Размер, logical px | Вес wght | Line height |
| --- | --- | ---: | ---: | ---: |
| display | Roboto Condensed | 60 | 700 | 1.05 |
| heading | Roboto Condensed | 40 | 700 | 1.15 |
| title | Inter | 26 | 600 | 1.25 |
| bodyLarge | Inter | 20 | 400 | 1.50 |
| body | Inter | 18 | 400 | 1.50 |
| label | Inter | 16 | 600 | 1.30 |
| caption | Inter | 14 | 400 | 1.40 |
| score | Inter | 56 | 700 | 1.10 |

Все восемь стилей static const, без color и без forRole. score дополнительно включает tabular figures. Компонентная тема назначает semantic цвет; готовая типографика не зависит от AppColors. Произвольная подмена размера/веса в Text не допускается.

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
