# R-003.d. Обязательная токенизация тем виджетов

## Применение

Scope: Flutter-клиент `apps/tournament_app` и его тесты, включая app/domain/infrastructure/presentation. К другим приложениям и инструментам проекта это правило не применяется; их архитектура определяется отдельно.

Обязательное правило. Проверяется при создании и изменении widgets, компонентов, экранов, responsive-layout и визуальных состояний.

## Ограничения

- Обязательная цепочка: `primitive const → FlutterTheme (ThemeData/ThemeExtension) → WidgetTheme → Widget`. Основная тема — runtime-источник оформления; WidgetTheme получает стандартные ColorScheme/TextTheme и типизированные extensions из текущей Theme.of(context). Стандартный Flutter widget может использовать непосредственно стандартную тему; проектный custom widget использует свою WidgetTheme.
- Цвета, отступы, размеры, типографика, радиусы, границы, тени, opacity, иконки, motion и breakpoint-параметры токенизируются. Raw-значения и локальные константы оформления внутри widgets запрещены, включая `0` и значения стандартной Material-темы без отображения в тему компонента.
- Нельзя создавать в widget raw `Color`, `TextStyle`, `EdgeInsets`, `BorderRadius`, `BoxDecoration`, `Duration` и другие объекты оформления из литералов. Widget использует готовые значения темы или собирает объект только из её типизированных параметров.
- Весь новый проектный UI размещается в presentation. `presentation/design_system/foundation` содержит базовые scopes токенов и общую тему; `components` — малые элементы, `widgets` — переиспользуемые композиции. Каждый реализованный scope/элемент имеет собственную папку, визуальный элемент — собственную типизированную тему. Не создавать папки будущих элементов до их реализации.
- `presentation/screens` содержит обособленные экраны со своими токенизированными темами компоновки. Экраны используют DS, не определяют собственные кастомные компоненты. DS не импортирует screens, Widgetbook или продуктовые controllers.
- Варианты, интерактивные состояния и responsive-значения определяются темой; при отсутствии нужного параметра сначала дополняется тема и документируется токен.
- Primitive const разрешены только в определениях примитивов и единственном слое сборки основной Flutter темы. Widgets и их WidgetTheme не импортируют primitive constants, AppTypography/ColorPrimitives или fixed dark factory напрямую. `Text(style: AppTypography.body)` / `Colors.red` / `const TextStyle(...)` внутри production UI запрещены. Color/TextStyle доступны через runtime тему; константные значения style в primitive-слое допустимы как вход сборки TextTheme.
- Замена основной ThemeData/ColorScheme/TextTheme/ThemeExtension должна обновлять существующие consumers. Нельзя кешировать WidgetTheme/static TextStyle так, чтобы обходить InheritedTheme, или молча восстанавливать dark constants при отсутствии extension. Нестандартные tokens — типизированные ThemeExtension с copyWith/lerp. Тема компонента не является вторым registry const tokens.
- `const`-конструктор widget допустим: запрет касается источника оформления, а не ключевого слова `const`. Предметные данные и callbacks не являются дизайн-токенами.

## Проверка

`make theme-check` проверяет AST boundaries и regression fixtures; `make theme-test` дополнительно проверяет runtime propagation через реальные consumers. Общий `make architecture-check/test` также включает guard. Нарушение даёт ненулевой exit code с R-003.d.

Проследить каждый изменённый визуальный параметр до темы компонента и общего токена. Проверить отсутствие raw-оформления и переносимые темы компонентов.

Размещение тем и границы токенизации: [Типизация, локализация и темы](../../../docs/architecture/typed-localized-themed-ui.md).

Структура и роли элементов: [Архитектура presentation](../../../docs/architecture/presentation-ui.md).

Реализованные foundation значения: [Manifest токенов](../../../docs/design/tokens-manifest.md). Изменение визуального значения обновляет соответствующий token/theme и manifest, не добавляет raw literal в widget.


Архитектурное решение и границы проверки: [Runtime theme foundation](../../../docs/architecture/runtime-theme-foundation.md). Тесты могут использовать primitive fixtures; production исключения ограничены definitions/ThemeData assembly. Tooling primitive-palette use case отображает токены как данные, его оформление всё равно следует основной теме. Импорт через alias/barrel/part не разрешает обход границы.
