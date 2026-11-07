# Сравнение Web и Flutter одной командой

Запуск из корня: `node tools/visual-comparison/compare.mjs avatar`. Для намеренного создания/обновления native baselines добавьте `--update-goldens`, затем повторите без него. Нужны Flutter SDK, Python3 и Chrome (путь можно передать через `CHROME`). Сторонние Node-пакеты не нужны.

Новый компонент добавляется typed декларацией `ComparisonSpec` в scoped Widgetbook-папке и регистрацией в `ComparisonCatalog`. Декларация задаёт реальные fixture builders, viewport/state, selector исходного HTML и locators каждого Flutter control: по типу или тексту. Общий driver не содержит ветвлений по имени компонента. Fixture переиспользуется Widgetbook и native golden.

Свойства контролей: rect/center/width/height, fontSize/fontWeight/lineHeight/baseline, color/background/radius/borderWidth/strokeWidth/opacity. Rect задаётся относительно корня. Сравнивайте внутренние Avatar/Text/action, а не только внешнюю форму. Геометрия, типографика и baseline имеют независимые явные допуски. Browser baseline оценивается через DOM Range/Canvas; для Avatar задан допуск1px из-за округления метрик шрифта (максимум наблюдаемого расхождения0.672px), при геометрическом допуске0.25px. Raster diff остаётся самостоятельной диагностикой, не доказательством pixel-perfect.

Pipeline экспортирует manifest, захватывает оригинальный DOM с исходными CSS/ancestry, измеряет Web, рендерит реальный Flutter widget, проверяет native goldens и контролы, строит PNG/overlay/diff и отчёт. Только размещение DOM переносится в начало capture: размеры до/после контролируются. Native высота не подгоняется под web. Все данные берутся из нового временного каталога; ошибки не переиспользуют старый PASS. Код выхода0 — совпадение контрактов и успешные negative controls,1 — различия,2 — ошибка инфраструктуры.

Результат: `docs/design/prototype/comparison/<component>/index.html`, `spec.json`, `results.json`, измерения и PNG. При работающем prototype server: `http://127.0.0.1:8094/comparison/<component>/index.html`. Runner закрывает только созданные им процессы; существующий сервер сохраняется. Без сервера откройте локальный HTML. Ошибки capture/report/cleanup отражаются в результате.

Native goldens расположены рядом с DS-элементом в `golden/<native-os>`. Обычный Flutter suite не запускает внешний capture; integration driver вызывается CLI с VC_RUN_DIR. Baseline обновляется отдельно от подтверждения соответствия web. Для отрицательного контрольного сценария указывается конкретное ожидаемое finding; отсутствие этого finding считается failure. В Avatar намеренно смещены инициалы, root сохранён.

Проверки engine: `node --test tools/visual-comparison/test/generic_engine.test.mjs`. Новые компоненты требуют деклараций, а не отдельных capture/report scripts.
