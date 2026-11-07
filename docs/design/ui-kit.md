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


## Отдельные component sets —7 ноября2026

23 категории содержат47 самостоятельных карточек по назначению/анатомии. Категория Buttons содержит отдельные Primary action, Secondary action, Destructive action, Neutral icon, Accent icon и Text action: у каждой собственная вертикальная матрица состояний и Mobile/Desktop previews. Общая матрица Primary больше не выступает состояниями всех кнопок.

Аналогично разделены Text input/Text area; Format/Score stepper; Character avatar/Portrait/Profile monogram; Inline/Fighter/Profile identity; Achievement/Plain metric; Back/Save/Edit header; Roster/Assignment/Ranking/History row; Information/Operation error/Inline error. Остальные самостоятельные элементы также имеют свою карточку, назначение, варианты и адаптацию. Нажатие по категории в локальном индексе ведёт к её наборам.

Для read-only элементов показаны варианты данных вместо выдуманных interaction states. Отсутствующие состояния явно описаны; восстановленные/предложенные помечены. Select сохраняет реальное различие исходников: native Desktop и статичная Mobile строка. Шаблоны ui-kit-library.js и исходные prototype CSS остаются источником внешнего вида; новые рамки и заголовки принадлежат только стенду.


### Унификация TextField —7 ноября2026

По запросу пользователя input и textarea в UI kit используют одинаковую непрозрачную заливку `surface` (`#171a20`) в обеих адаптациях. Border/radius и семантика focus/error общие; disabled сохраняет raised/muted. Desktop больше не переключает fill на canvas. Высота textarea и остальные source-размеры остаются адаптивными. Решение применяется к component sets и обратным сборкам UI kit; исходные прототипы сохраняют исторические значения.


### Mobile Select —7 ноября2026

Mobile preview заменён с исходной static setting строки на общий рабочий native Select. Обе адаптации используют C.select(), единые оформление и набор опций. Выбор меняет локальное значение образца, не сохраняет настройки и не переключает тему приложения. Это утверждённое пользователем развитие UI kit относительно исторического mobile-прототипа.


### Select в исходном Mobile-оформлении —7 ноября2026

Предыдущее решение с одинаковым полем на обеих платформах уточнено пользователем: Mobile сохраняет исходную анатомию flow-panel/flow-setting-row («Оформление» слева, выбранное значение справа). Значение теперь нативный select, оформленный как прежний strong-text; раскрытие и изменение значения работают без ручного дублирования текста. Desktop сохраняет отдельное поле с chevron. Mobile default/focus/disabled показаны в карточке. Изменение значения образца не применяет тему приложения.


### Mobile Select с bottom sheet —7 ноября2026

По запросу пользователя Mobile сохраняет исходную строку настроек как button trigger; раскрытие реализовано через модальный dialog, оформленный нижней панелью. Варианты показывают текущий выбор галочкой/выделением. Выбор обновляет только вызвавший образец и закрывает панель; крестик, backdrop и Escape закрывают без изменения. Нативный dialog удерживает focus внутри и блокирует фон, после закрытия focus возвращается к trigger. Disabled trigger недоступен. Desktop остаётся native select. Реализация взаимодействия изолирована в ui-kit-select.js; новые app settings/state/сохранение не добавляются.


### Stepper без платформенных различий —7 ноября2026

По уточнению пользователя desktop-адаптация Stepper признана ошибкой прототипа. Из desktop.css удалены переопределения заливки/ширины/кнопок/value FT, фон score stepper в sheet и отдельный layout wrapper FT. Оба варианта используют существующие shared Mobile-стили flow.css/competition.css: raised fill, высота56px, кнопки56px, FT value min-width48px. Score input сохраняет shared source width32px. UI kit и исходный Desktop prototype теперь показывают одинаковые контролы. Прежние source-документы о canvas fill FT относятся к историческому варианту и заменены этим решением.


### Avatar по размерам —7 ноября2026

Визуальные категории Avatar/Identity объединены. Базовый Avatar — графика/монограмма, Identity — композиция того же Avatar с именем и подписью, а не второй графический компонент. Каталог теперь группирует Avatar по размерам28/40/48/64/96/112/128px. В каждой карточке показаны без подписи, круглая форма и композиция с подписью; на Mobile/Desktop размер одинаков. Цвета Ice/Fire и другие больше не служат названием типа. Рамки/outline удалены у всех Avatar в UI kit, включая row/identity/recipe uses. Исходные prototype assets этой итерацией не меняются.


### Roster row: source anatomy и swipe —7 ноября2026

Roster row использует исходные `flow-panel flow-roster flow-roster-guests`: Mobile inset16, row72/avatar48; Desktop — bento tile208/avatar64 с24px inset (20px в source compact media). Убрана лишняя outer surface UI kit. Desktop specimen показывает одну исходную карточку без screen grid.

Общий roster-gestures.js используется прототипами и UI kit. Действие не раскрывается от hover/focus: горизонтальный drag справа налево двигает передний слой, отпускает в revealed после24px; обратный drag закрывает. Вертикальное намерение сохраняет scroll, pointercancel возвращает исходное состояние. Keyboard: ArrowLeft раскрывает, ArrowRight/Escape закрывают. Скрытое удаление исключено из Tab/AT. Состав турнира не меняется. Desktop delete pill заменён правой reveal-областью; удалён transform:none, ширина grid переднего слоя зафиксирована в1fr.


### Границы Mobile row и Desktop tile —7 ноября2026

Предыдущее извлечение ошибочно включало padding16 всего списка в размер отдельной Mobile-строки, показывая104px вместо72px. Standalone Mobile Roster row теперь72px с avatar48 и именем Inter18/600; padding8px/16px находится внутри переднего слоя, контейнер списка не добавляет размер. Правая delete-область88×72px без inset, от края до края по высоте.

Desktop выделен отдельно: tile208px/avatar64/inset24/gap16/name Inter22/600, ширина fluid. Восстановлена исходная compact delete-кнопка96×48px в верхнем правом углу с inset24. Она появляется после свайпа; передний слой возвращается на место, в отличие от Mobile. Неверная Desktop-полоса из предыдущей итерации отменена. Обе версии показаны самостоятельными sets с default/revealed, проверены напрямую по исходным browser specimens.


### Desktop удаление без жестов —7 ноября2026

Предыдущее Desktop swipe-решение отменено по запросу пользователя. Desktop tile показывает постоянно доступную neutral trash-кнопку40×40px в верхнем правом углу; hover добавляет danger emphasis, keyboard focus — outline. Desktop rows исключены из roster-gestures.js, действие сразу участвует в Tab. Source Desktop ссылка ведёт к существующему guest-remove макету.

В UI kit нажатие открывает native modal confirmation с initial focus на «Отмена», Escape/cancel возвращают focus к trigger. Подтверждение скрывает только demo-card и показывает «Восстановить пример»; восстановление возвращает карточку и focus. Эта механика изолирована в ui-kit-roster.js и не меняет данные турнира. Mobile swipe и геометрия72px остаются прежними.


### Points ranking context —7 ноября2026

В образце Points исправлен ошибочный context: вариант без номера места использует исходный competition-results-points с grid `minmax(0,1fr) auto`. Identity получает свободную ширину, очки остаются компактной правой колонкой. Обычные Place/Shared place сохраняют собственную place-column. Shared prototype CSS не менялся.


### Иконки сообщений —7 ноября2026

Inline error/error-copy в UI kit использует24×24px (space24), как Information/Operation error. Унификация распространяется на supporting error поля. Исходные source CSS сохраняют историческое20px значение; UI kit задаёт согласованное значение поверх него.


### Кастомный ProgressIndicator —7 ноября2026

По уточнению пользователя waveform-индикатор является кастомным компонентом TournamentHUB, не копией Material3. При будущем переносе сохраняются его собственные геометрия/анимация и normal/reduced-motion states; штатный Flutter LinearProgressIndicator не подменяет этот визуальный контракт. Текущий HTML SVG/CSS остаётся эталоном. Уточнение отражено в постановке задачи66; Flutter-реализация не начиналась.


### ProgressIndicator: исправленное требование к приложению —7 ноября2026

Пользователь уточнил и отменил предыдущее решение: HTML waveform неверен. В Flutter нужен штатный Material3 progress indicator, настроенный через основную ThemeData/ProgressIndicatorThemeData. Кастомная отрисовка/анимация волны не переносится. Исторический HTML образец помечен неканоническим для Flutter; он не определяет геометрию приложения. Task66 обновлена до spec v3.
