# Сравнение Web и Flutter одной командой

Запуск из корня: `node tools/visual-comparison/compare.mjs avatar`. Для намеренного создания/обновления native baselines добавьте `--update-goldens`, затем повторите без него. Нужны Flutter SDK, Python3 и Chrome (путь можно передать через `CHROME`). Сторонние Node-пакеты не нужны.

Новый компонент добавляется typed декларацией `ComparisonSpec` в scoped Widgetbook-папке и регистрацией в `ComparisonCatalog`. Декларация задаёт реальные fixture builders, viewport/state, selector исходного HTML и locators каждого Flutter control: по типу или тексту. Общий driver не содержит ветвлений по имени компонента. Fixture переиспользуется Widgetbook и native golden.

Свойства контролей: rect/center/width/height, fontSize/fontWeight/lineHeight/baseline, color/background/radius/borderWidth/strokeWidth/opacity. Rect задаётся относительно корня. Сравнивайте внутренние Avatar/Text/action, а не только внешнюю форму. Геометрия, типографика и baseline имеют независимые явные допуски. Browser baseline оценивается через DOM Range/Canvas; для Avatar задан допуск1px из-за округления метрик шрифта (максимум наблюдаемого расхождения0.672px), при геометрическом допуске0.25px. Raster diff остаётся самостоятельной диагностикой, не доказательством pixel-perfect.

Pipeline экспортирует manifest, захватывает оригинальный DOM с исходными CSS/ancestry, измеряет Web, рендерит реальный Flutter widget, проверяет native goldens и контролы, строит PNG/overlay/diff и отчёт. Только размещение DOM переносится в начало capture: размеры до/после контролируются. Native высота не подгоняется под web. Все данные берутся из нового временного каталога; ошибки не переиспользуют старый PASS. Код выхода0 — совпадение контрактов и успешные negative controls,1 — различия,2 — ошибка инфраструктуры.

Результат: `docs/design/prototype/comparison/<component>/index.html`, `spec.json`, `results.json`, измерения и PNG. При работающем prototype server: `http://127.0.0.1:8094/comparison/<component>/index.html`. Runner закрывает только созданные им процессы; существующий сервер сохраняется. Без сервера откройте локальный HTML. Ошибки capture/report/cleanup отражаются в результате.

Native goldens расположены рядом с DS-элементом в `golden/<native-os>`. Обычный Flutter suite не запускает внешний capture; integration driver вызывается CLI с VC_RUN_DIR. Baseline обновляется отдельно от подтверждения соответствия web. Для отрицательного контрольного сценария указывается конкретное ожидаемое finding; отсутствие этого finding считается failure. В Avatar намеренно смещены инициалы, root сохранён.

Проверки engine: `node --test tools/visual-comparison/test/generic_engine.test.mjs`. Новые компоненты требуют деклараций, а не отдельных capture/report scripts.


Уточнения составных компонентов: `ComparisonControl.type(withinType: AppAvatar, type: DecoratedBox, ...)` ограничивает locator реальной дочерней компонентой; приватный layout не приходится искать глобальным индексом. `textRange:true` измеряет непосредственный текстовый узел отдельно от SVG. Радиус сравнивается как фактическое скругление, ограниченное половиной меньшей стороны: CSS999px и нативный circle48×48 дают24px. `capturePadding` включает внешние контуры/тени; фон вне root нейтрализован без изменения CSS компонента. `note` явно показывает принятые расхождения, не скрывая raster diff.

Пример принятого отклонения RosterRow: UI kit принудительно показывает `.kit-focus` с3px, а настоящий desktop `:focus-visible` прототипа использует2px. Native повторяет последний; это отмечено прямо у focus-сценария. Четыре source-состояния RosterRow проверяют frame, avatar rect/style, initials, name, remove rect/style и glyph/label. Native long/disabled/text-scale fixtures дополнительно проверяются Flutter-тестами.

Внешний capturePadding не уменьшает исходные constraints: native boundary находится в горизонтальном и вертикальном scroll-контейнере, а browser mask покрывает root вместе с padding даже за viewport. Это позволяет показывать полную тень. Test binding переопределяет disableShadows=false: стандартный Automated binding убирает blur и не соответствует приложению. Это изменение требует намеренного обновления затронутых shadow baselines и повторного сравнения.

Для граничных размеров ComparisonScenario.captureSize переопределяет размер render environment, одинаково сериализуется для browser и используется native driver. Два основных VisualViewport остаются390/1440; дополнительные boundary samples не расширяют автоматически матрицы остальных компонентов.

Полям ввода доступны controls по EditableText: native driver берёт RenderEditable фактического framework state, стиль и измерение текста, browser — value input/textarea и canvas metrics. Baseline браузера для form controls — оценка line box/font metrics, а не пустой DOM Range. `textRange:true` сравнивает ширину текста без Expanded/внешней рамки. BorderColor измеряется отдельно от borderWidth. Field содержит negative control изменённого input fontSize; expected finding обязателен. Cursor/focus raster остаётся самостоятельной диагностикой.

Открытое состояние задаётся optional webOpenSelector: browser ждёт существующий trigger и вызывает его реальный click перед поиском source root. Это общий capture параметр, без ветвления по компонентам. Select использует его для настоящего dialog bottom sheet из UI kit; Flutter fixture рендерит ту же AppSelectSheet, что и modal route. Внутренние handle/close/options/title проверяются controls.

ComparisonControl.webPseudo — typed before/after; browser читает оригинальный getComputedStyle(node,pseudo) и фактический rect из computed inset/width/height. Это не DOM-копия подложки. Segmented choice отдельно сравнивает ::before выбранного сегмента и полную область нажатия.

Для исходного display:inline capture использует relative positioning, сохраняя inline formatting и glyph box. Fixed превратил бы span в block и изменил высоту; прежняя проверка isolation dimensions это обнаруживает. Прочие roots остаются fixed.

Служебные capture position/left/top/margin/width/z-index применяются с important: CSS source .kit-dialog содержит !important, который иначе оставлял root под capture mask. Layout/style компонента не переписываются; isolation dimension guard остаётся. Native image driver отбрасывает source PNG, полностью совпадающий с фоном: пустой снимок не может дать ложный PASS по одним DOM metrics.

Для fixtures с Image driver ждёт precacheImage в real async context, затем проверяет RawImage.image!=null до capture. Геометрия Image не доказывает загрузку данных; QR выявил пустой первый baseline, который был отклонён ordinary golden после decode. Для загрузки не используются фиксированные sleep/timers.
