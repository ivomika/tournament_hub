# Задача38. Desktop bento-прототип

## Статус и этап

✅ Выполнена — визуальное ревью и исправления подтверждены

- Mode: CODE.
- TestGate: NOT_REQUIRED — композиция существующих визуальных fixtures, без бизнес-логики.
- Stage: DONE; specification/plan5 — исправления и выбранная визуальная регрессия завершены.

## Цель и границы

Отдельный desktop.html показывает те же группы, экраны и состояния в прежнем порядке, с переработанной bento-композицией. Мобильный index.html не меняется. Сохраняются fixture-данные, actions/anchors, QR и визуальные сценарии. Flutter, реальные use cases и новые продуктовые состояния вне scope.

## Применимые правила

- R-001: desktop layout отделён в собственный CSS, общие primitives и существующие interactions переиспользуются.
- R-002: отдельный документ desktop и ссылка из prototype docs, русский текст.
- R-004: HTML identifiers/fixtures не используются как новые domain contracts.
- R-007: сравнить полный состав и порядок groups/figures, fixture-тексты, anchors/resources, CSS/JS syntax; визуальную проверку выполнять только доступным разрешённым способом.
- Flutter rules неприменимы: HTML/CSS вне apps. Conditional scan: других правил нет. Core/router/workflow прочитаны.

## Критерии и план

- [x] AC-1: desktop.html независим от мобильного документа;49 figures/17 groups в исходном порядке.
- [x] AC-2: отдельные bento wrappers/layouts для profile/forms/live/history/QR/results; композиция переработана.
- [x] AC-3: desktop CSS скрывает statusbar/home-indicator, центрирует dialogs и выделяет полотно сетки. Реальный browser-render подтверждён в итерации2.
- [x] AC-4: IDs/links/resources/data parity, JS syntax и browser-геометрия проверены; границы проверки записаны.
- [x] AC-5: завершён повторный визуальный проход всех макетов после итерации3, включая24/48 элементов, раскрытия, ширины1440/1000/700. Частичное evidence ниже; доступ браузера нужен для оставшихся проверок.

1. Создать desktop.html из актуального набора, перекомпоновать содержимое по назначению.
2. Создать desktop.css с общей bento сеткой и специализированными композициями, сохраняя foundation.
3. Проверить parity/anchors, resources и исходный mobile hash; записать docs/result.

## Проверки

План: structural parity source/desktop, уникальность ID, существование всех ссылок/assets, JS syntax, правила/diff-check. Browser file:// ранее запрещён политикой; обходить этот запрет нельзя. Desktop screenshots при отсутствии разрешённой browser-среды NOT_RUN.

## Changelog

### Итерация 2 — переработка desktop-композиций

**Prompts пользователя (дословно)**

> так посмотри гайдлайн по бенто ui. И посмотри сам на визуалы которые получились. Выглядит как простая перестановка контейнеров. Это не то что я ждал. Отчетиво это видно в профиле. Простые 3 колонки, нет разделений на более мелкии компоненты как в bento ui

> отлично давай по новой, почитай гайды и приведи экраны по гайдам

**Specification/plan 2**

- Продолжаем этот номер. Все 49 экранов/17 групп, данные и действия сохраняются; меняется только desktop-композиция.
- Использовать смысловые плитки разных spans, общий модульный ритм и один главный фокус. Не дробить простые формы и dialogs ради декора.
- Пересобрать настройку, профиль, главную, состав/раздачу, проведение, QR, историю и итоги; у простых и переходных состояний убрать пустые колонки.
- Проверить реальный рендер через локальный HTTP: все состояния, основные layouts на desktop и narrower fallback. Проверить геометрию, anchors/controls/data parity, сохранность mobile и syntax.
- Источники: EMCD Bento Grid, NN/g Cards и Visual Hierarchy, Michelin Principles of a Dashboard. Ссылки и применение будут сохранены в owning docs.
- TestGate остаётся NOT_REQUIRED: только HTML/CSS-композиция, без новой бизнес-логики. Approval не нужен.
- Первый реальный screenshot подтвердил проблемы исходника: растянутые контейнеры формы/состава и повторное вложение карточек. Local HTTP 127.0.0.1:8094 доступен; ограничение file:// больше не мешает разрешённому просмотру HTTP.

### Итерация1 — 2026-10-31

**Prompt пользователя**

> так отлично. Теперь давай сделаем отдельный файл с интерфейсом для descktop. Это должно быть не простое растягивание, а прям переделка layout. Желательный стиль bento ui. Работаем в отдельном файле. Нужно показать все те же экраны и состояния структуру прототипа не меняем.

**Решения**

- Полный набор и порядок галереи сохраняются; разрешена внутренняя композиция desktop screens. Непрозрачные graphite surfaces, gold accent, Inter/Condensed сохраняются.
- Desktop — самостоятельный snapshot HTML с общими styles/assets и отдельным override desktop.css.

## Итог

Созданы `docs/design/prototype/desktop.html` и `desktop.css`: полный desktop snapshot с адаптивными bento-композициями. Mobile index не изменён этой задачей. Общие токены/интеракции переиспользованы; новых business states нет. Документация — `docs/design/desktop-prototype.md`.

## Фактические проверки

- Python HTMLParser:49 screens/17 groups — идентичны исходнику по порядку; IDs, все видимые тексты и controls с href/labels/value/min/max сохранены. Перестановка текста внутри screen допускается desktop-композицией; проверяется multiset каждого экрана.
- Все anchors и stylesheet/script resources существуют; duplicate IDs отсутствуют. CSS brace balance PASS.
- `node --check` обоих внешних scripts; `node tools/check_rules.cjs` —15 leaf/2 группы PASS; `git diff --check` PASS.
- Screenshot/geometry/focus/interaction NOT_RUN: ранее установлен browser policy запрет observation file://, обход не выполнялся. Результат требует дальнейшего визуального просмотра; никакого browser успеха не заявляется.
- Flutter/build/commit/push не выполнялись. Все исходные dirty changes задачи37 сохранены.

## Changelog — завершение итерации1

- SPEC_READY/PLAN_READY → IMPLEMENTING → VERIFYING → DONE. Созданы2 отдельных desktop файла и owning doc; исходные49 макетов сохранены с новым desktop chrome и semantic bento wrappers.
- Общие состояния центрированы; profile три колонки, forms/QR/history/live/results две; result sheets стали central dialogs, карта занимает широкую область. Score сохраняет соответствие колонкам игроков.
- Approval логического TestGate не требуется, scope чисто визуальный. Проверки/ограничения перечислены выше.

## Changelog — завершение итерации 2

**Изменения и решения**

- Переработаны desktop HTML/CSS: профиль с восемью плитками, модульные setup/roster/distribution/QR/results, компактные simple forms и переходные состояния. History пересобрана без обрезания третьей карточки; bootstrap wordmark больше не выходит из блока.
- Общая сетка12 колонок/gap20/radius24, разные spans по смыслу; действия привязаны к контекстным блокам, а не к пустой боковой колонке. Исправлен порядок CSS cascade для профильных/live-композиций.
- Owning docs обновлены с источниками EMCD, NN/g, Michelin и конкретными применениями/исключениями. Шрифты и данные исходника сохранены.

**Проверки / evidence — 2026-10-31**

- Local HTTP на127.0.0.1:8094; browser screenshots всех49 состояний на исходном viewport1184×912, дополнительные просмотры ключевых композиций на1440×1000/1000×1000 и fallback700×1000.
- Read-only DOM geometry всех49 экранов:1440 и1000 — нет overflow X/Y основного screen-content в свёрнутом состоянии;700 — нет overflow X, вертикальная прокрутка длинного контента ожидаема. Раскрытые подробности проверены отдельно; карта сохраняет собственные pan/zoom.
- Browser: FT1→FT2→FT1, раскрытие управления турниром и панели управления сеткой выполнены. Действия copy/share, реальные use cases и LAN не реализовывались/не проверялись, это прежние fixtures.
- Python HTMLParser parity — PASS:49 screens/17 groups, порядок, тексты и controls каждого экрана, ID uniqueness, links/resources. Первое обнаружение отсутствующего SVG symbol оказалось ошибкой одноразового checker (не учитывал self-closing id); checker исправлен, повторная проверка PASS; HTML не менялся для обхода проверки.
- `node --check docs/design/prototype/bracket-map.js`, `node --check docs/design/prototype/roster-gestures.js`, `node tools/check_rules.cjs`, `git diff --check` — PASS.
- SHA256 мобильного index до/после: `c304ad4bb496187ae8837d07885e30436c5b0437f432ec5d0d7f49be1ddb2c92` — совпадает. Изменения задачи37 сохранены.
- Контрольные screenshots: `/tmp/tournament-desktop-profile.jpg`, `/tmp/tournament-desktop-setup.jpg` (временные browser artifacts, не источники прототипа).
- Flutter/build/commit/push не выполнялись. TestGate NOT_REQUIRED подтверждён неизменным визуальным scope. IMPLEMENTING → VERIFYING → DONE.

## Changelog — итерация 3

**Prompts пользователя (дословно)**

> посмотри каждый макет есть жесткие проблемы согласованности элементов внутри контейнеров. А еще удаление участников выглядит не правильно сверху и снизу тоже появляются красные полосы

> а еще проверь как будут отображатся динамические компоненты на 20+ компонентах: участники/история и тд

**Specification/plan 3**

- Исправить внутренние padding/gap/alignment и геометрию reveal-действия. Не менять продуктовые данные, мобильный прототип и структуру49 состояний.
- Добавить отдельный демонстрационный density-режим24/48 повторяющихся элементов для проверки длинных составов, раздачи, истории, результатов/таблиц. Это визуальные fixtures, не расчёт турниров или production state.
- Главные действия не должны уезжать вместе с длинными списками; scroll принадлежит списку, текст переносится, карточки не сжимаются.
- Browser-проверка всех макетов и раскрытий, stress-контента, ширин1440/1000/700. Сравнение baseline data/controls и неизменности index; syntax/rules/diff-check.
- R-001/002/004/007 и scope неизменны; Flutter/conditional неприменимы. TestGate NOT_REQUIRED: только prototype layout/visual fixtures.

### Итерация 3 — выполненное и препятствие

- Установлена причина полос: action имел inset0 на родительской карточке, а сдвигался только padded-внутренний content. Для desktop action заменён компактной кнопкой96×48 с inset24; лицевая часть не сдвигается и не обрезает имя. Hover/focus/gesture раскрывают прежнее действие; mobile CSS/JS не менялись.
- Упорядочены padding/gap, группы heading/caption, формат/FT, идентификация игроков, action areas. У состава, раздачи, рейтингов и таблиц собственная прокрутка. Последний элемент доступен без уезда главного действия.
- Добавлен desktop-only `desktop-density.js`: links исходные/24/48 в заголовке галереи и query `?items=24` / `?items=48`. Синтетические имена/длинные названия, списки состава/раздачи/истории/итогов и строки standings; не моделирует валидный турнир на48 человек, не рассчитывает сетку/результаты. Исходный режим не меняет figure-данные.
- Browser1184×912:24 элемента — просмотрены состав, reveal, история, раздача;48 — итоги, standings, состав с прокруткой до конца. Состав: count48, scrollTop4862=maxScroll, lastVisible=true, buttonInside=true. Reveal: rowHeight=faceHeight208, actionHeight48, actionTop24, actionWidth96; полос и сдвига текста нет.
- Read-only DOM48: все49 screen-content без overflow X/Y на исходном viewport. Проверка1440/1000/700 и новый screenshot-проход всех49 после последних правок НЕ ЗАВЕРШЕНЫ: браузер отказал в origin approval сначала8095, затем8094. Повторные/обходные browser-вызовы не выполнялись.
- При проверке ресурсов выяснено: сервер8094 с корнем в prototype не отдаёт шрифты по исходным ../../../apps путям; screenshots используют fallback. Попытка нового preview с корнем репозитория отклонена из-за избыточной области экспозиции. Создана безопасная альтернатива во временном `/tmp/tournament-preview.gRBkWZ` с доступом только к prototype/fonts, но браузер не разрешил8095. Этот дополнительный сервер остановлен;8094 не остановлен. Для полноценной проверки со шрифтами потребуется разрешённый preview; обход отказа не выполнялся.
- `node --check` desktop-density/roster-gestures — PASS; `node tools/check_rules.cjs`15 leaf/2groups — PASS; `git diff --check` — PASS. HTML49/17, order, ID uniqueness, anchors/resources, CSS braces — PASS. Сравнение с desktop-markup итерации2: screen markup полностью сохранён (добавлен только script в head).
- SHA256 mobile index совпадает с итерацией2; commit/build/push не выполнялись. Задача не объявляется завершённой: требуется разрешить браузерный доступ и закончить AC-5.

## Changelog — итерация 4: выбор настроек

**Prompt пользователя (дословно)**

> не давай с настройками разберемся оформление и язык нельзя выбрать

**Scope/plan и результат**

- Заменить статичные значения оформления/языка на доступные native select в существующих двух bento-плитках. Начальные значения сохраняются; продакт-сохранение настроек, тема всей галереи и локализация приложения вне scope. На экране явно обозначить демонстрационные границы.
- Добавлены label/for, focus-visible, декоративный chevron и общий aria-describedby. Оформление: Тёмное/Светлое/Как в системе; язык: Русский/English. Изменение только HTML/CSS, без JS/business contracts; TestGate NOT_REQUIRED. Применимые R-001/002/004/007 и scope неизменны.
- Python HTMLParser PASS: controls не disabled, labels связаны, опции/default корректны, help существует,49 figures/уникальные IDs/CSS brace balance сохранены. `node tools/check_rules.cjs` и `git diff --check` PASS.
- Browser NOT_RUN: ранее отозвано разрешение origin; новый prompt касается controls, не содержит нового разрешения браузерного доступа. Отказ не обходился. Общая задача остаётся🔴 по незавершённому AC-5; commit/build/push не выполнялись.


## Changelog — итерация 5: три направления визуального ревью

**Prompt пользователя (дословно)**

> заведи пару суб агентов для ревью desktop версии один разбирает дизайн на связанность компонентов по архитектуре и переиспользованию,, второй по тому как это отображается на desktop и правильности построению приложений для desktop, третий смотрит правильно ли реализовано bento ui. Причем прежде чем приступать к ревью пускай каждый прочитает свои гайдлайны. после ревью ты должен подтвердить проблему сам и решить ее. Каждый суб агент должен визуально видеть прототип а не только код

**Scope / specification / plan5**

- Каждый из трёх reviewers читает project rules и профильные первичные guidelines до проверки, подтверждает собственный screenshot-доступ. Только read-only review; исполнитель изменений — root.
- Root независимо воспроизводит findings в браузере и исправляет подтверждённые дефекты desktop-композиции/визуальных взаимодействий; сохраняет49 состояний/17 групп и мобильный документ.
- Проверить ресурсы шрифтов, основные desktop размеры1440/1000, fallback700, исходные/24/48 fixtures, раскрытия и доступность действий. Зафиксировать результаты и ограничения.
- TestGate: NOT_REQUIRED — HTML/CSS композиция, визуальные взаимодействия и локальный preview, без новых business contracts. R-001/002/004/007 перечитаны; Flutter/conditional неприменимы.
- Проверки: screenshots и DOM-геометрия, source structure/resources, JS syntax, rules/diff-check, mobile SHA256. Новые тесты констант не требуются.


### Итерация5 — findings, исправления и фактические проверки

- Три агента прочитали AGENTS/context/core/task38/workflow, локальный code-rules-audit, профильные guides. Все получили собственные screenshots прототипа. Component/Bento независимо подтвердили один P2 responsive-профиля; desktop подтвердил P2 раскрытого RR48. Других доказанных дефектов в рассмотренном scope не представили.
- Root подтвердил оба визуально и read-only DOM: profile700 overlap44px/recent scroll183>client158; RR48 table320px пересекал следующий details на130px.
- Исправления desktop.css: profile rows в одной последовательности breakpoints без позднего возврата фиксированных160px, размеры по содержимому; live sidebar flex stack с отдельной scroll area раскрытий. Desktop HTML обновляет версию stylesheet. Mobile SHA256 сохранён.
- Добавлен tools/serve_prototype.py — loopback preview только prototype + два explicit font assets, без directory listing/экспозиции repo; docs и tools README обновлены. До исправления font HTTP404, после перезапуска renderer показывает проектный Condensed/Inter.
- Root повторно подтвердил profile700/1000 без наложения: achievement200px, recent220px/client218/scroll218. RR48 после fix: table bottom626.1 < results top646.1, results bottom734.1 < CTA top754.1 (1280×1000).
- Визуально просмотрены screenshots49 исходных состояний на1440×1000 (сначала были несинхронные screenshots после goto; проход повторён с getAXState перед каждым screenshot, просмотрены именно повторные). DOM49 screen-content на1440/1000/700: overflowX отсутствует. Агентами до fix проверены профиль1280/1000/700, setupDE/liveDE/history/resultsDE, distribution48, roster1440/1000, RR48/keyboard focus.
- Structural PASS:49 figures/17 groups/order/unique IDs/anchors/CSS brace balance/Python AST. node --check desktop-density/roster-gestures/bracket-map PASS; node tools/check_rules.cjs15 leaf/2groups PASS; git diff --check PASS. Mobile SHA256 c304ad4bb496187ae8837d07885e30436c5b0437f432ec5d0d7f49be1ddb2c92 совпадает. Flutter/build/commit/push не выполнялись.
- При следующем сообщении пользователя «продолжи» browser tabs.list отказал: «Local browser use is disabled in Work settings». Обход не выполнялся. Не завершены полный rerun density24/48, все раскрытия/select после fix и viewport reset (последний override1440×1000); browser disabled не позволяет выполнить и cleanup. AC-5 остаётся открытым; задача не объявляется DONE.


### Итерация5 — возобновление визуальной проверки

- Prompt пользователя: «пробуем». Browser больше не отклоняет local use; первый вызов обнаружил остановленный сервер (ERR_CONNECTION_REFUSED). Preview вновь запущен штатной командой на8094; доступ подтверждён собственным screenshot.
- Проверка density24/48 на1440/1000/700: screenshots состав/раздача/история/DE-SE-RR итоги/rr-tie, DOM49 screen-content для каждой пары размеров/плотности без overflowX. Просмотрены42 актуальных screenshot. Повторно подтверждён доступ к48-й строке раскрытой RR таблицы без перекрытия соседних действий.


### Итерация5 — завершение после восстановления доступа

- Проверены все17 раскрываемых блоков на1000px, включая вложенное пояснение таблицыRR после прокрутки до конца. Screenshots просмотрены; пересечений соседних плиток/кнопок не обнаружено. При повторном переходе на тот же hash раскрытие сохранялось; состояние уточнено и проверка вложенного блока повторена после штатного раскрытия.
- Density24/48:42 screenshots семи затронутых композиций на1440/1000/700 просмотрены. На1000 и700 мышью прокручены все шесть длинных списков48 до конца: состав/раздача/история/DE-SE-RR итоги. LastVisible=true для каждого, scrollTop достиг max. На700 таблица/контекст rr-tie допускают последовательную вертикальную прокрутку.
- Native select: Светлое/English выбраны и подтверждены browser UI/values light/en; затем возвращены defaults. FT1→FT2→FT1 проверен в DE. Reveal состава: action96×48, opacity1 при focus, row208, face transform:none; красные полосы не воспроизвелись.
- Итоговая проверка RR48 на1440×1000: строки таблицы прокручиваются внутри собственной области, результаты и CTA остаются отдельными блоками. Viewport reset выполнен; вкладка оставлена доступной пользователю.
- Структурные проверки и mobile hash не изменились с предыдущего PASS; после docs выполнены rules/diff-check. AC-5 закрыт по фактически выбранному покрытию:49 исходных состояний1440, геометрия49 на1440/1000/700, целевой screenshot-проход плотных композиций/профиля/раскрытий и взаимодействий. Это не матрица screenshot каждого состояния на каждой ширине и не проверка production Flutter/LAN.
- Подтверждённые findings устранены; незавершённых обязательных проверок выбранного scope нет. Задача38 закрыта, без build/commit/push.
