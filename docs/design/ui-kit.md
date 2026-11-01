# Визуальный UI kit TournamentHUB

[Открыть UI kit](prototype/ui-kit.html#components). Локальный запуск: `python3 tools/serve_prototype.py`.

Один визуальный лист с семью разделами: Colors, Typography, Icons, Foundations, Components, Layouts, Component Mapping. Основание — [ТЗ пользователя](ui-kit-brief.md), три референса организации UI kit и два существующих HTML-прототипа. Референсы определяют организацию листа; внешний вид взят из TournamentHUB.

## Состав и переиспользование

23 семантических семейства. Button объединяет текстовые, иконочные и destructive применения; Field — single/multiline ввод с общим chrome; Identity — Avatar и текст; Metric — число/подпись и achievement emphasis. NumberStepper и Score разделены по ответственности; строковые применения собираются через Identity и slots. Большие экранные композиции не объявлены атомарными компонентами.

[ui-kit-library.js](prototype/ui-kit-library.js) — общие визуальные HTML-шаблоны с параметрами текста, иконок, значений, состояния и плотности. Presentation enums — Symbol-наборы Style/State/Density/Identity/Row. Это не API бизнес-моделей. [ui-kit.js](prototype/ui-kit.js) собирает лист из этой библиотеки. Те же функции собирают Setup и Profile для Desktop и Mobile в Layouts. Исходные HTML/CSS, Flutter и бизнес-логика приложения не изменены.

Компоненты используют исходные tokens.css/components.css/screens.css/flow.css/competition.css/bracket-map.css/desktop.css. [ui-kit-tokens.css](prototype/ui-kit-tokens.css) добавляет primitive/semantic алиасы с теми же значениями и совместимостью source variable names. Палитра, отступы и шрифты распространяются на компоненты через CSS variables. [ui-kit.css](prototype/ui-kit.css) оформляет лист, изолирует presentation context и показывает фиксированные состояния; исходная форма/типографика компонентов сохранена. Device chrome и рамки устройств отсутствуют; iframe нет.

## Foundations и трассировка

Аудит всех49 mobile и49 desktop figure: исходные классы и computed styles1425/1554 DOM-узлов без status/chrome/SVG-внутренностей. Найдены21 CSS color literal,59 типографических сигнатур и18 SVG symbols. Частоты в листе — число макетов с наблюдаемым значением, а не количество независимых дизайнерских решений. Базовые роли выделены семантически, совпадающие параметры не дублируются; дробные clamp/cqw значения не становятся новыми токенами.

Шкала8/16/24/32/48/64 сохранена;4px подтверждены микроритмом identity;12/20px — повторяющейся desktop-композицией. Единственные/контекстные28/9/144px и технические значения остаются в раскрываемом списке исключений. Цвета scrim/elevation отделены от статусной палитры. Desktop breakpoints740/1000/1100px описаны как границы конкретных композиций, а не универсальные размеры устройств.

[ui-kit-mapping.json](prototype/ui-kit-mapping.json) и Mapping в листе классифицируют222 класса из98 макетов: component/foundation/layout/excluded. Есть источники figure/selector,49 пар сценариев и классификация расхождений. Классовое покрытие подтверждает трассировку исходника, но не доказывает готовность всех производственных состояний или всех комбинаций данных.

## Состояния и исключения

Без отметки — исходное оформление. CSS — состояние определено исходным stylesheet. Восстановленные/предложенные примеры явно помечены: Field invalid/disabled, промежуточный/максимальный Stepper, Raised surface как композиционный образец. Эти примеры не утверждают новые бизнес-ограничения FT или правила валидации.

Различия не исправляются молча: mobile settings статичны, desktop select интерактивен; Achievement меняет emphasis; Identity имеет контекстные typography overrides; FT и Field меняют fill по поверхности. Missing copied/loading-button/success, modal focus и keyboard selection отмечены как дальнейшая спецификация, а не показаны готовой функциональностью.

Гайдлайны: [Figma variants](https://www.figma.com/best-practices/creating-and-organizing-variants/), [component properties](https://help.figma.com/hc/en-us/articles/5579474826519-Explore-component-properties), [Carbon checklist](https://www.carbondesignsystem.com/getting-started/contributing/component-checklist).

## Проверки и границы результата

Визуально проверены все23 семейства и семь разделов по screenshots/contact sheets. Setup/Profile собраны из общей библиотеки на двух платформах и сверены с исходниками. Найденные дефекты first-child рейтинга, intrinsic ширины density-wrapper, desktop-класса в mobile recent и тесного Score layout исправлены.

Browser:1280/1000/390px; отсутствие body/family/rebuild overflow и duplicate IDs; native Disclosure; отсутствие console warnings/errors. Кнопка, поле, степпер и mobile Achievement совпали с исходником по13 проверенным computed параметрам (фон/цвет/font/line-height/radius/padding/height/shadow). Это выборочная проверка, не полный pixel diff всех компонентов.

Отдельная временная страница проверила токены: изменение palette-gold-400 меняет кнопку и акцент метрики; space-md меняет padding кнопки/поля/метрики. Страница удалена после проверки. Проверки ссылок/ресурсов, JavaScript syntax, rules checker и diff-check выполняются при завершении задачи. Исходные13 файлов прототипов проверяются SHA256.

Это визуальная библиотека и восстановленные правила. Полная обратная сборка всех98 экранов, рабочие сценарии турнира, clipboard, фокус модальных окон и accessibility сертификация не заявляются. Для приёмки выбраны два разных сценария на обеих платформах согласно финальному тесту ТЗ; дальнейшее production-извлечение отдельно.


## Постановка переноса в приложение

1 ноября2026 по запросу пользователя добавлены отдельные planning-only задачи: сначала9 foundation scopes, затем23 семейства Components. Номера, зависимости, критерии и текущее состояние — только в [едином реестре задач](../../ai-context/task-list.md) и его карточках. Существующие Colors/Typography задачи36 переиспользуются и сверяются с UI kit, а не создаются повторно. Реализация Flutter в рамках постановки не выполняется. [Порядок добавления DS-компонента и Widgetbook](../development/design-system-component-workflow.md) описывает применение действующих project rules и прочитанных официальных гайдлайнов.
