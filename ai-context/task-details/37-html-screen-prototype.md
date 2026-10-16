# Задача 37. HTML-прототип экранов

## Статус и этап

✅ Завершена

- Mode: CODE.
- TestGate: NOT_REQUIRED — чистый HTML/CSS визуальный прототип, ссылки между демонстрационными состояниями; без бизнес-логики или сохранения.
- Stage: DONE; specification/plan 27, test set 1.
- Approval: не требуется для данного scope.

## Цель и scope

Создать обозримый mobile-first HTML-набор экранов полного пользовательского flow, который агент правит по обратной связи. Bootstrap, главная и профиль дополняются остальными состояниями турнира, utility-разделами и spectator. Без navbar, glass и редактора. Не реализуем production Flutter, реальный routing/state/storage/транспорт или расчёты турнира. HTML-якоря связывают демонстрационные состояния; данные — fixtures.

## Применимые правила

- [R-001](../rules/core/001-solid.md): отделить foundation-переменные, компоненты и композицию страниц.
- [R-002](../rules/core/002-documentation-russian.md): решение и границы в docs/design.
- [R-004](../rules/core/004-typed-values.md): нет прикладной модели/строковых дискриминаторов, только HTML-якоря и отображаемые fixture-тексты.
- [R-007](../rules/core/007-code-testing.md): визуальный просмотр и структурные проверки ссылок/ресурсов/размеров.
- Flutter rules не применяются: прототип вне apps/tournament_app, production UI не меняется; Flutter goldens не объявляются созданными для HTML.
- Conditional rules отсутствуют. Процесс: [workflow](../workflow.md).

## Решения и план

1. Непрозрачные плавающие капсулы, крупная типографика и согласованные радиусы; не копировать Liquid Glass. Сохранить действующие цвета/локальные шрифты.
2. Файлы в docs/design/prototype: HTML-галерея и CSS foundation/components/screens. Все состояния доступны сразу; якоря служат просмотром, не редактором.
3. Проверить ресурсы, DOM, desktop/320px и просмотреть браузером. Не запускать Flutter build и не коммитить.

## Acceptance Criteria

- [x] AC-1: доступны профиль новичка/с последним результатом и недостающие экраны flow; принятые главная/профиль сохранены.
- [x] AC-2: непрозрачные floating-actions, без navbar и glass; palette/fonts соответствуют foundation.
- [x] AC-3: макеты читаемы на mobile, ресурсы и якоря работают.
- [x] AC-4: перед новыми экранами прочитаны подходящие рекомендации Apple и других дизайн-источников, в docs есть карта «экран → источник → решение».
- [x] AC-5: визуальные состояния соблюдают утверждённые правила MK11; нет fake draw/Cancelled, FT-настройки RR, возврата снятых или свободного выбора чемпиона при tie.

## Крайние случаи / Test Scenarios

- TS-1 → AC-1/2: просмотр новых профилей, турнира, результата и spectator; состояние retry не выдаёт успешную инициализацию; ошибка не стирает введённое имя.
- TS-2 → AC-3: 320px и desktop, проверка переполнения/шрифтов/локальных ресурсов.
- HTML не является интерактивным приложением: сохранение и создание турнира не выполняются. Static fixture-состояния не утверждают новых business rules.

## Test Evidence

- 2026-10-14: браузерный DOM — 8 макетов, отсутствующих якорей нет, fonts loaded. При первом narrow-просмотре найдены горизонтальные overflow в brand/wordmark; добавлено container-relative масштабирование заголовков и малого логотипа.
- Повторный браузерный замер: при фактической ширине 581px и на desktop нет horizontal overflow контента/страницы; начальный desktop 1280px также без page overflow. Viewport override запрошен 320px, но backend вернул другую фактическую ширину: точный повторный 320px capture не заявляется.
- Просмотрены Bootstrap и профиль, проверена навигация якорями. Целевой mobile frame 390×844, адаптивная single-column обвязка; это HTML-проверка, не Flutter golden.
- Node structural check: относительные ссылки, уникальные ID, оба TTF, 8 article и отсутствие scripts. Rules checker: 15 leaf/2 группы. git diff --check без ошибок.
- Python preview не запустился; обе созданные попытки остановлены. Для показа запущен временный Node HTTP preview на 127.0.0.1:8095, доступны только прототип и font assets. Browser tab оставлен deliverable.

## Changelog

### Итерация 1 — 2026-10-14

**Prompt пользователя**

> так у стича прям фигова получается... Двай нагенерим html с экранами и их вариантами и будем аккуратно их редактиовать. Кстати хочу чтоб дизайн опирался на новшества в дизайне ios например, говорю "нет" навбаром, делаем floating элементы и остальные веянья, кроме glass

**Уточнение пользователя**

> я не буду редактировать html не нужно делать инструменты редактирования

**Изменения**

- Scope: HTML редактирует агент; пользователь просматривает и даёт обратную связь. Первый набор из трёх обсуждённых экранов, без турнирного flow.
- Изучен Apple WWDC25 «Get to know the new design system»: капсулы, concentricity, typography, иерархия через layout. Материал стекла не переносим.
- Добавлены галерея/4 CSS и docs/design/html-prototype.md, ссылка из docs README. Контроль узкой ширины выявил overflow, исправлен масштабированием типографики в рамках proposal. Точные параметры не мигрируются в Flutter foundation автоматически.
- Выполнены проверки выше; Stage IMPLEMENTING → VERIFYING → DONE. Build/commit/push не выполнялись.

### Итерация 2 — 2026-10-14

**Prompt пользователя**

> так уже есть прикол с бутстрап. Мне не нравится индикатор загрузки и почему то все прижато к левом краю

**План и изменения**

- Продолжение той же задачи: только Bootstrap. Центрировать wordmark, статус и сообщение ошибки; заменить circular spinner на тонкую indeterminate линию. Без процентов, стекла или изменений бизнес-поведения.
- TestGate NOT_REQUIRED сохраняется. Проверки: browser render трёх Bootstrap-вариантов, центрирование/overflow и reduced-motion; structural check и diff-check. Home/profile не меняются.
- Документация: косметическая итерация, долговременное product/architecture решение не меняется; сведения о текущем Bootstrap в существующем prototype doc уточняются.

**Проверки и результат**

- Все три Bootstrap-варианта просмотрены после browser reload. DOM: centerOffset логотипа 0px во всех трёх вариантах; horizontal overflow отсутствует. Две indeterminate-линии в loading/retry, в error индикатора нет.
- Старый spinner удалён; reduced-motion CSS отключает animation новой линии. Это структурная проверка fallback, не runtime-эмуляция настройки ОС.
- Rules checker: 15 leaf/2 группы; diff-check без ошибок. Главная/профиль не изменены, build/commit не выполнялись. Stage VERIFYING → DONE, вкладка оставлена открытой.

### Итерация 3 — 2026-10-14

**Prompt пользователя**

> мне нравилоьс лого слева это необычно.
> а еще нет согласованности между экранами. сначала подсказка сверху потом снизу

**План и решения**

- Вернуть асимметричный wordmark слева. Сохранить единые вертикальные точки начала логотипа и текстового состояния в loading/error/retry; текст всегда перед линией, действия всегда внизу.
- Только Bootstrap HTML/CSS; home/profile не меняются. TestGate NOT_REQUIRED, применимые core rules те же. Проверки: замер одинаковых anchors трёх состояний, overflow и визуальный просмотр, rules/diff checks.

**Изменения и проверки**

- Введены proposal tokens boot-brand-top/height, убрано вертикальное центрирование группы переменной высоты. Логотип, текст и линия выровнены слева; состояние всегда после логотипа, линия всегда после текста.
- После reload все три logoTop = 237.73px, statusTop = 417.76px относительно phone; left = 25.80px (браузерный zoom). Horizontal overflow отсутствует. Просмотрены три состояния; ошибка больше не поднимает логотип.
- Rules checker: 15 leaf/2 группы; git diff --check без ошибок. Docs обновлены, вкладка перезагружена и сохранена для просмотра. Без build/commit; VERIFYING → DONE.

### Итерация 4 — 2026-10-14

**Prompt пользователя**

> а контент тоже сместился, а согласованность так и не появилась. положи подсказку под прогрес индикатор

**План**

- Логотип слева без изменения позиции; центрировать только boot-state. Линия перед подсказкой в loading/retry, не наоборот. Ошибка в той же зоне, центрированная; bottom action без изменений.
- Чистый визуал, TestGate NOT_REQUIRED; CSS/DOM проверка порядка, центров и сохранения логотипа, browser preview, diff-check. Исправление продолжает задачу 37.

**Изменения и проверки**

- Центрирован только boot-state; убран CSS order индикатора, поэтому линия предшествует подсказке в loading/retry, как в DOM. Логотип не перемещён.
- Browser reload + DOM: hintBelow=true и indicatorCentered=true в обоих loading-вариантах; logoTop=237.73px, logoLeft=25.80px во всех состояниях, как до правки; horizontal overflow нет. Error остаётся без progress.
- git diff --check и rules checker успешны (15 leaf/2 группы). Docs уточнены, вкладка обновлена. Home/profile/Flutter не менялись, build/commit не выполнялись. Stage DONE.

### Итерация 5 — 2026-10-14

**Prompt пользователя**

> экран ошибки bootstrap какой то странный и слигком много текста

**План**

- Только error-вариант: сократить текст до «Не удалось запустить» / «Попробуй ещё раз», использовать спокойный title вместо heading40 и уменьшить внутренний gap. Лого, loading/retry и кнопка остаются без изменений.
- TestGate NOT_REQUIRED, прежние core rules. Browser render/DOM: отсутствие overflow, неизменные anchors логотипа, короткая копия. Проверки rules и diff-check. Косметическое решение, без изменений контрактов/правил бизнеса.

**Результат и проверки**

- Текст сокращён, убраны принудительные переносы и дублирующее объяснение причины. Error title использует Inter26/600; локальный gap16. Позиции других элементов сохранены.
- После reload просмотрены три варианта: error title26px, copy соответствует плану, overflow=false, logoTop=237.73px сохранён. Browser tab оставлен открытым. Rules checker 15 leaf/2 группы и diff-check успешны.
- Docs актуализированы, business logic/Flutter/build/commit не затронуты. VERIFYING → DONE.

### Итерация 6 — 2026-10-14

**Prompt пользователя**

> делай

**Контекст согласования и план**

- Подтверждено предложение из чата: символ ошибки на месте индикатора, под ним «Не удалось запустить», внизу «Повторить». Убрать «Попробуй ещё раз».
- Ввести общую визуальную cue-зону для progress/error symbol, чтобы сообщение начиналось на одной высоте. Логотип/кнопки не перемещать. Чистый визуал, TestGate NOT_REQUIRED; применимые core rules прежние.
- Проверки: DOM text/cue/message anchors, horizontal overflow и browser render; rules checker/diff-check. Только HTML proposal, не Flutter.

**Результат и проверки**

- Добавлен outline alert-symbol в общей cue-зоне, удалена повторная подсказка, error copy приведён к body18. Лого и bottom-actions не менялись.
- Browser reload/DOM: cueTop=417.76px, messageTop=465.71px одинаковы во всех трёх состояниях; error имеет символ и единственный текст «Не удалось запустить». После завершения рендера horizontal overflow=false во всех трёх. Макет просмотрен, вкладка сохранена для пользователя.
- git diff --check / rules checker успешны (15 leaf/2 группы). Документация обновлена. Flutter/build/commit не затронуты. VERIFYING → DONE.

### Итерация 7 — 2026-10-14

**Prompt пользователя**

> давай поиграемс с размером иконки ошибки и прогрес индикатором. А может прогрес индикатор сделать вообще волнистым как у гугла? Посмотри как правильно строитс прогресс

**Исследование и план**

- Изучена официальная документация Material Components ProgressIndicator: active indicator/track, determinate vs indeterminate, wave parameters, rounded strokes и увеличенная высота wavy component. Ссылка/границы адаптации в prototype docs.
- Bootstrap — неизвестный прогресс: без процентов/фальшивого completion. SVG гладкая периодическая кривая + бегущая фаза и отдельный indeterminate-сегмент, тихий track, reduced-motion fallback.
- Proposal: width160, stroke4, wavelength32, amplitude4 (от оси), error icon40, общая cue-зона48. Сохранять позицию wordmark и одинаковую высоту подсказок. Это HTML-адаптация принципов, не точная реализация Google timings.
- TestGate NOT_REQUIRED, scope/core rules прежние. Проверки: SVG refs, browser layout/motion, text anchors, animation CSS и reduced-motion structural check, rules/diff checks. Flutter не меняется.

**Изменения и проверки**

- Добавлен общий Bézier path периода32; SVG active wave сдвигается на один период, отдельное clipping-окно расширяет и перемещает сегмент. Это визуальная интерпретация M3 Expressive, не нативный компонент. Error icon24→40, progress120×3→160×24 со stroke4, cue24→48; новые proposal-параметры в tokens.css.
- Browser reload: width160px, error40px, messageTop=489.72px одинаков во всех состояниях; overflow=false, aria-valuenow отсутствует. Missing SVG refs=0. Два замера transform/clip-path различаются, подтверждая обе анимации; screenshot просмотрен.
- Reduced-motion CSS отключает обе animation: структурно проверено, OS-emulation не выполнялась. Rules checker15 leaf/2 группы и diff-check успешны. Docs содержат источник и параметры/ограничения адаптации.
- Вкладка обновлена и оставлена открытой; без Flutter/build/commit. VERIFYING → DONE.

### Итерация 8 — 2026-10-14

**Prompt пользователя**

> так забиваем идем к главной. Уже слишком много текста, я не хочу читать, хочу видеть что происходит, а еще ооочень много кнопок снизу это странное решение почитай об этих проблемах и измени подход

**Исследование и план**

- Apple Buttons: множество prominent buttons увеличивает cognitive load. NN/G minimalist design: убрать элементы без ценности для задачи, не заменять ясные подписи неоднозначными значками.
- Главная: убрать рекламные слоганы и пояснения, оставить состояние. Empty-state + «Создать турнир»; active — компактная карточка с форматом/участниками/этапом и «Продолжить» непосредственно в ней. История/профиль сверху, создание нового активного турнира отдельным компактным действием возле заголовка.
- Только визуальные fixture-экраны, без новых business rules или интерактивного приложения. TestGate NOT_REQUIRED. Проверки: browser layout, overflow, сохранение доступности действий; rules/diff. Bootstrap не меняется.

**Результат и проверки**

- Главная переработана, explanatory/promotional copy удалена, история перенесена вверх, продолжение встроено в карточку. Empty-state содержит один CTA. В активном состоянии «Новый» — compact secondary возле заголовка. Bootstrap/profile не изменены.
- Browser reload/DOM: по одному primary-action в обоих вариантах, bottomButtons=0, horizontal overflow=false. Действия история/профиль/создание/продолжение доступны, fixture-полосы не объявлены расчётом прогресса. Docs уточняют границы.
- Rules/diff проверки по завершении, без Flutter/build/commit. Stage VERIFYING → DONE.

### Итерация 9 — 2026-10-14

**Prompt пользователя**

> так ну теперь пустой главный экран слишком пустой...

**План**

- Только empty-home: заменить маленький trophy крупной декоративной схемой турнира (пустые формы сетки → кубок). Без фиктивных игроков/счёта, дополнительных текстов/кнопок или изменений active-home/Bootstrap.
- Прежние core rules, TestGate NOT_REQUIRED. Проверки: browser render, overflow, один primary CTA; refs/rules/diff. Декоративная композиция не обещает уже созданную сетку.

**Результат и проверки**

- Крупная SVG-композиция заменяет маленькую иконку, использует palette tokens; illustration-size в tokens.css. Текст/кнопки не добавлены. Документирована декоративная, не доменная семантика.
- После browser reload: artHeight200px, primaryCount1, overflow=false, brokenRefs0. Rules15 leaf/2 группы и diff-check успешны. Снимок браузера показал другую область страницы, поэтому отдельная визуальная приёмка artwork по screenshot не заявляется; DOM/render geometry проверены.
- Active-home, Bootstrap и Flutter не менялись; без build/commit. Stage DONE.

### Итерация 10 — 2026-10-14

**Prompt пользователя**

> отступы не верны

**Диагностика и план**

- Empty-state flex:1/justify-content:center растягивал расстояние после заголовка; перед CTA суммировались gap24 и margin16. Несколько старых home-selectors затрудняли чтение каскада.
- Только layout главной: outer24, основные gaps24, внутри16, перед CTA явный margin32 без суммирования; убрать flex-центрирование пустого блока и неиспользуемые старые home-selectors. Выравнять высоту heading-row обоих вариантов (48).
- TestGate NOT_REQUIRED, применимые core rules прежние. Browser computed spacing/overflow и screenshot при доступности, rules/diff. Состав экранов/Bootstrap/profile не меняются.

**Результат и проверки**

- Удалены старые неиспользуемые home-intro/heading/note/inline-secondary selectors. Empty-state больше не растягивается/центрируется; задан gap0 и явные margins16/32. Общие section-gaps24, heading-zone48; active-card gap16, до CTA суммарно32.
- Browser reload computed: padding24px, gap24px, artToText16, textToAction32, justifyContent normal, overflow=false. Rules15 leaf/2 группы и diff-check успешны. Docs обновлены, вкладка перезагружена.
- Только HTML/CSS; без Flutter/build/commit. VERIFYING → DONE.

### Итерация 11 — 2026-10-14

**Prompt пользователя**

> а добавь вариант с floating nav

**План и уточнение scope**

- Добавить третий вариант главной (empty-state) с непрозрачной floating-капсулой «Главная / История / Профиль». Два прежних варианта без nav сохраняются для сравнения. Это пользовательское уточнение первоначального запрета navbar, не глобальный переход приложения на nav.
- Создание турнира отдельно в контенте; не дублировать историю/профиль сверху. Выделить нижнюю safe-зону для nav, чтобы не перекрывать CTA/scroll-content. Только preview, история пока не реализована, профиль связан существующим якорем.
- TestGate NOT_REQUIRED, прежние core rules. Проверки: 9 previews, 3 nav items и один primary CTA, no overlap/overflow, local anchors/refs, rules/diff. Flutter не меняется.

**Результат и проверки**

- Добавлен отдельный home-floating с общей empty-иллюстрацией и непрозрачной навигацией, активный пункт имеет aria-current. Исходные home-варианты сохранены. Верхняя навигация в альтернативе не дублируется.
- Browser reload/DOM: previews9, navItems3, primary1, noOverlap=true, overflow=false, brokenRefs0. Высота nav≈72px. Вкладка оставлена на #home-floating. Rules/diff проверки успешны (15 leaf/2 группы).
- Scope/doc уточняют пользовательское исключение первоначального «без nav»: это сравниваемый вариант, не смена всей архитектуры/навигации. Без Flutter/build/commit; Stage DONE.

### Итерация 12 — 2026-10-14

**Prompt пользователя**

> не он не нужен, убери этот вариант. Есть варианты как еще поиграть с главной?

**План**

- Удалить отклонённый home-floating и исключительно его CSS/tokens/icon. Сохранить две исходные главные и историю эксперимента.
- TestGate NOT_REQUIRED. Проверить восемь previews, отсутствие сломанных якорей и overflow; rules/diff. Предложить композиционные направления в чате, не реализовывать их без выбора пользователя.

**Результат и проверки**

- Отклонённый вариант удалён вместе с отдельными CSS/tokens/home-icon. Остальные экраны не менялись; документация отражает отказ, прежняя история сохранена.
- Browser reload на #home: previews8, homeVariants2, removed=true, brokenRefs0, overflow=false. Rules checker: 15 leaf/2 группы; git diff --check успешен.
- Без Flutter/build/commit. Новые направления обсуждаются в чате; Stage DONE.

### Итерация 13 — 2026-10-14

**Prompt пользователя**

> используем второй и третий вариант

**Решения и план**

- Подтверждены единый турнирный блок (создание или текущая схватка/продолжение) и короткая история ниже. Асимметрия не реализуется. Сохраняем восемь previews: empty без истории, active с двумя завершёнными турнирами.
- Общая оболочка блока/CTA в обоих состояниях. Убрать декоративный псевдопрогресс. История показывает название и победителя без дополнительных абзацев/кнопок; верхнее действие открывает всю историю только в будущем приложении.
- В assets пока нет портретов: нейтральные SVG placeholders рядом с именами персонажей и участников, не выдаём их за готовые аватары. Все данные — fixtures, история/результаты/матч не вычисляются.
- TestGate NOT_REQUIRED, прежние core rules; browser DOM/overflow/refs, rules/diff. Flutter и Bootstrap/profile не меняются.

**Результат и проверки**

- Общая оболочка турнирного блока и CTA реализованы в обоих состояниях; вместо псевдопрогресса active показывает пару с персонажами. Ниже две краткие записи истории, в empty без истории раздел отсутствует. Placeholder-портреты документированы, данные fixtures.
- Browser reload/DOM: previews8, brokenRefs0; оба блока424px, по одному primary, recent0/2, horizontalOverflow=false. Screen-content overflow:auto: нижняя история доступна вертикальной прокруткой, не сжимается ради помещения в frame. Точный 320px screenshot в этой итерации не выполнялся; проверка ширины текущего phone≈386px.
- node tools/check_rules.cjs: 15 leaf/2 группы. git diff --check успешен. Docs обновлены; без Flutter/build/commit. Stage DONE.

### Итерация 14 — 2026-10-14

**Prompt пользователя**

> ой не верни как было

**План**

- Отменить только визуальную итерацию13: вернуть empty-иллюстрацию200, исходную active-card с этапом и декоративными полосами, убрать пару и последние турниры, их CSS/tokens. Floating nav не возвращать.
- Прежние core rules и TestGate NOT_REQUIRED. Browser reload: восемь previews, отсутствие новых секций/сломанных refs/overflow; rules/diff. Документация возвращается к текущему макету, история сохраняется.

**Результат и проверки**

- Вернулась композиция итерации12: empty без общей карточки, illustration200; active с названием/этапом/fixture-полосами и продолжением. Пара, история и их отдельные styles/tokens удалены. Bootstrap/profile не менялись.
- Browser reload: previews8, recent/match/shared-block0, floating-nav0, artHeight200px, activeRestored=true, brokenRefs0, overflow=false. Rules checker15 leaf/2 группы, git diff --check успешен. Без Flutter/build/commit; Stage DONE.

### Итерация 15 — 2026-10-14

**Prompt пользователя**

> хочу поиграть с пустым состоянием главной

**Ответ на интерактивный выбор**

> сделай все три варианта для сравнения, текущие не заменяй

**План и решения**

- Отдельная группа сравнения: крупная графическая композиция со встроенным CTA; незаполненная сетка; типографическая композиция. Исходная empty/active группа, Bootstrap/profile и общие styles остаются неизменными.
- Новые формы — декоративные SVG/HTML без фиктивных участников и результатов. Один primary CTA на вариант, история/профиль сохраняются сверху; без nav/glass/редактора.
- TestGate NOT_REQUIRED; применимые core rules прежние, conditional отсутствуют. Проверки: сохранность исходной группы, 11 previews, refs/ID, browser overflow/размеры; rules/diff. Только HTML, без Flutter/build/commit.

**Результат и проверки**

- Добавлена отдельная группа home-experiments с тремя композициями и scoped CSS/tokens. Исходная группа home посимвольно совпадает с состоянием перед итерацией (сравнение секции после нормализации CRLF/краевых пробелов).
- Browser DOM: previews11, brokenRefs0, duplicates0; у каждого нового макета primary1, ширина386, horizontalOverflow=false, scrollHeight=clientHeight744. Точный320px capture не выполнялся. Screenshot API показал верх страницы вместо целевой группы: визуальную screenshot-приёмку новых вариантов не заявляем; геометрия и DOM проверены.
- node tools/check_rules.cjs:15 leaf/2 группы; git diff --check успешен. Docs обновлены, вкладка на #home-experiments. Без Flutter/build/commit. Stage DONE.

### Итерация 16 — 2026-10-14

**Prompt пользователя**

> давай остановимс на варианте Д замени текущий лишине удали

**План**

- Перенести типографический вариант Д в home-empty. Удалить старую пустую композицию, сравнения В/Г и отдельный дубль Д, их SVG/styles/tokens. Сохранить active, Bootstrap/profile и историю задачи.
- Прежние core rules, conditional нет, TestGate NOT_REQUIRED. Проверки: 8 previews, сохранность active, refs/ID и overflow, rules/diff; документация фиксирует выбор. Без Flutter/build/commit.

**Результат и проверки**

- Типографический вариант перенесён в home-empty, удалены сравнительная группа, старая пустая схема и неиспользуемые styles/tokens/SVG. Active сохранён посимвольно после нормализации CRLF.
- Первый browser reload выявил оставшуюся группу из-за несовпадения indentation; исправлено. Финальный reload: previews8, experiments=false, выбран type-title, brokenRefs0, overflow=false. Один primary CTA. Точный320px screenshot не выполнялся.
- Docs фиксируют выбор Д. Rules checker15 leaf/2 группы; git diff --check успешен. Без Flutter/build/commit; Stage DONE.

### Итерация 17 — 2026-10-14

**Prompt пользователя**

> давай посмотрим испрвленный вариант рядом не удаляй текущие

**План и решения**

- Отдельная группа рядом по порядку галереи: крупное имя, спокойный аватар, «Изменить имя»; информация о приложении второстепенно. Редактирование и ошибка — static bottom-sheet snapshots поверх этого профиля.
- Связать preview-якорями, фон sheet inert/aria-hidden, без рабочего сохранения/JS/реальной modal state machine. Постоянная label «Имя», сохранённый ввод в ошибке, краткая ошибка сохранения, не invalid-field. Keyboard/focus lifecycle будущего приложения не реализуется.
- Основание: исследование Apple HIG Settings и NN/G grouping/error guidelines из предыдущего обсуждения; решение — наш proposal, не буквальное требование источников.
- Core R-001/002/004/007 прежние, conditional нет; TestGate NOT_REQUIRED. Проверки: прежняя profile-группа неизменна, previews11, уникальные IDs/refs, browser геометрия/overflow, rules/diff. Без Flutter/build/commit.

**Результат и проверки**

- Добавлена отдельная profile-refined группа с тремя previews и scoped CSS/tokens. Существующая profile-секция посимвольно сохранена после нормализации CRLF/краевых пробелов. Home/Bootstrap не менялись.
- Browser: previews11, brokenRefs0, duplicates0, horizontalOverflow=false при phone386px; оба sheet внутри phone, высоты≈325/370px, primaryCount1, background inert/aria-hidden=true, dialog label связан. В обоих inputs сохранено «Иван М.». Точный320px capture, software keyboard и настоящий modal focus lifecycle не проверялись/не реализованы.
- node tools/check_rules.cjs:15 leaf/2 группы, git diff --check успешен. Docs содержат источники/границы proposal; вкладка на #profile-refined. Без Flutter/build/commit. Stage DONE.

### Итерация 18 — 2026-10-14

**Prompt пользователя**

> так возьмем прошлый вариант вместо кнопки сохранить добавляем галочку сверху справа и примени наши принципы и добавим блок статистики. все это делаем вместо блока "новый вариант" старый пока храним ка историю

**План**

- Заменить только profile-refined группу переработкой исходного full-screen профиля: краткий заголовок, имя/аватар, блок статистики; edit/error отдельными экранами с галочкой сверху справа вместо нижнего CTA. Существующую profile-группу сохранить как историю.
- Статистика — визуальные fixtures «Турниры / Победы в турнирах / Схватки», не вычисление и не утверждённый business-контракт. Убрать sheet/scrim и неиспользуемые стили/токены. Preview сохраняет readonly inputs и не выполняет сохранение.
- Core rules прежние, conditional нет; TestGate NOT_REQUIRED. Проверить сохранность истории, previews11, refs, верхние actions, overflow; rules/diff и docs. Без Flutter/build/commit.

**Результат и проверки**

- Profile-refined заменён тремя full-screen previews на основе прежнего профиля. Краткая композиция просмотра со статистикой; save/retry — галочки сверху справа. Sheet/scrim/styles/tokens/close-icon удалены. Историческая profile-секция посимвольно сохранена после нормализации CRLF/краевых пробелов.
- Browser reload: previews11, sheets0, stats3, brokenRefs0, horizontalOverflow=false при386px; statsFits=true, bottomButtons0, labels save/retry заданы. Ввод в ошибке сохранён. Точный320px capture/keyboard не проверялись; данные fixture, расчётов нет.
- Docs актуализированы; node tools/check_rules.cjs15 leaf/2 группы, git diff --check успешен. Без Flutter/build/commit; Stage DONE.

### Итерация 19 — 2026-10-14

**Prompt пользователя**

> оп приложении как будто хочется сделать прям блоком а не footer и с самим профилем ннадо еще поиграть по стандартам apple

**Исследование и план**

- Apple HIG Layout: иерархия, достаточно пространства у controls, логическая группировка. Lists and tables: grouped-style разделяет связанные данные. Полные HIG страницы web open требуют JS; использованы индексируемые выдержки официальных страниц. Центрирование профиля — наше предложение, не обязательный стандарт Apple.
- Только актуальный просмотр: круглый аватар/имя по центру, спокойный заголовок в верхнем ряду; статистика единым inset-блоком с разделителями; «О приложении» отдельной surface-секцией в обычном потоке, без margin-top:auto/привязки к низу. Edit/error и история сохраняются.
- Прежние core rules/NOT_REQUIRED, conditional нет. Проверки: refs/11 previews, overflow, расположение блока, неизменность исторической секции; rules/diff. Нет Flutter/build/commit.

**Результат и проверки**

- Актуальный просмотр: centered avatar96/name40, спокойный header, единый stats-block, отдельная about-surface без auto-margin. Сохранены цвета/шрифты и editing/check-actions; история посимвольно неизменна после нормализации CRLF/краевых пробелов.
- Browser reload: previews11, brokenRefs0, aboutMargin0/background surface/height≈153px; identity column, avatar96. После корректировки vertical padding профиль помещается: scrollHeight=clientHeight744, horizontalOverflow=false. Точный320px screenshot/Dynamic Type не проверялись.
- node tools/check_rules.cjs15 leaf/2 группы; git diff --check успешен. Docs содержат источники и границу адаптации Apple. Без Flutter/build/commit; Stage DONE.

### Итерация 20 — 2026-10-14

**Prompt пользователя**

> давай уберем подписи "профиль" и "статистика" мы должны понимать это по блокам и редактирование уберем лишние текста из контента и перенесем на верх по типу "Профиль" только будет действие "Редактирование"

**План**

- Только актуальная группа: убрать видимые заголовки просмотра «Профиль»/«Статистика», сохранить semantics статистики через aria-label. В edit/error вместо контентного «Изменить имя» поставить «Редактирование» по центру верхнего ряда. Label «Имя» и полезную ошибку сохранить.
- Не меняем историю, данные или действия. Core rules прежние, conditional нет, TestGate NOT_REQUIRED. Browser refs/геометрия/overflow и наличие нужных labels; rules/diff/docs. Без Flutter/build/commit.

**Результат и проверки**

- Видимые «Профиль»/«Статистика» удалены из актуального просмотра; aria-label статистики сохранён. Edit/error имеют верхний заголовок «Редактирование», поле «Имя» и нужную ошибку; контентный заголовок удалён. Все предыдущие секции HTML неизменны после нормализации CRLF.
- Browser reload: viewHeaders0, editHeaders «Редактирование»/«Редактирование», fieldLabels «Имя»/«Имя», statsLabel «Статистика», brokenRefs0, horizontalOverflow=false. Точный320px screenshot не выполнялся.
- Docs обновлены, rules checker15 leaf/2 группы и git diff --check успешны. Без Flutter/build/commit; Stage DONE.

### Итерация 21 — 2026-10-14

**Prompt пользователя**

> давай контент на профиле поднимем выше

**План**

- Только актуальный просмотр: section-gap24→16, верхний padding identity16→0; нижний padding16 сохраняется. Без отрицательных offsets, перестановки элементов или изменений edit/error/истории.
- Core rules прежние, conditional нет, TestGate NOT_REQUIRED. Проверить browser before/after и overflow, rules/diff. Косметическая правка: новые требования/архитектура не меняются, отдельный docs-update не нужен по исключению R-002. Без Flutter/build/commit.

**Результат и проверки**

- Scoped gap16 и padding-top0 подняли актуальный просмотр без отрицательных offsets. Остальные selectors/HTML/edit/error/история не менялись.
- Browser before/after: avatar выше≈24px, stats≈32px, about≈40px; horizontalOverflow=false. Вкладка обновлена. Rules checker15 leaf/2 группы, git diff --check успешен. Без Flutter/build/commit; Stage DONE.

### Итерация 22 — 2026-10-14

**Prompt пользователя**

> давай два макета с 1 и 2 вариантами. а подпись "организатор" уберем впринципе

**План**

- Добавить два view-previews на основе актуального профиля: свободная строка трёх метрик без подложки; достижение (кубок/победы в турнирах) + две второстепенные цифры. Не заменять текущую статистику до выбора пользователя, не дублировать edit/error.
- Удалить только отображаемую подпись «Организатор» во всех profile previews, включая исторический по прямому уточнению. Общее понятие роли проекта/документация продукта не меняются.
- Все цифры12/3/28 — те же fixtures, не расчёты. Что именно учитывается в метриках, не утверждено этой визуальной задачей. Прежние core rules/NOT_REQUIRED, conditional нет; refs/ID/overflow/browser, rules/diff/docs. Без Flutter/build/commit.

**Результат и проверки**

- Добавлены два scoped статистических view-previews, без замены текущего и дублирования edit/error. Удалены отображаемые роли из обоих прежних просмотров, остальные данные сохранены.
- Browser reload: previews13, roles0, duplicates0, brokenRefs0; metrics12/3/28 и3/12/28, horizontalOverflow=false, scrollHeight=clientHeight744 у обоих. Точный320px screenshot не выполнялся.
- Docs содержат источники и границы fixture-статистики. Rules checker15 leaf/2 группы, git diff --check успешен. Без Flutter/build/commit; Stage DONE.

## Итог

### Итерация 24 — 2026-10-14

**Prompt пользователя**

> убери остальные варианты профиля и оставь актуальный вариант реально единственным актуальным

**Изменения и решения**

- Продолжение37, CODE, TestGate NOT_REQUIRED. Прочитаны core R-001/002/004/007 и workflow; scope только HTML-галерея, Flutter/conditional rules неприменимы. R-001: удалены дубли композиции; R-002: актуализирован docs/design/html-prototype.md; R-004: якоря остаются HTML-навигацией; R-007: структурная проверка удаления/ссылок соразмерна правке.
- Удалены три старых состояния профиля и два сравнения статистики. Единственная группа содержит основной профиль «Главное достижение», его редактирование и ошибку сохранения. Главная и navigation ведут к этому профилю; подписи А/Б/В актуализированы.
- История вариантов сохранена в append-only changelog и Git. Другие экраны не изменены.

**Проверки и итог**

- Node structural check:8 previews, legacy IDs отсутствуют, уникальные IDs, все anchors/ARIA/SVG targets существуют. Rules checker:15 leaf/2 группы; git diff --check успешен.
- Browser screenshot не выполнялся: ранее доступ к file:// заблокирован URL policy. Для применения HTML нужно обновить открытую вкладку. Build/commit не выполнялись.
- Stage VERIFYING → DONE. Актуальный профиль теперь единственный в галерее.

### Итерация 23 — 2026-10-14

**Prompt пользователя**

> по экрану профиля оставляем вариант "Главное достижение" замени основной вариант им и давай дальше прорабатывать блоки. Мы настройки хотим в профиле оставить? Может давай сделаем вниу списочек из кнопок где будет кнопка "О приложении", "Настройки" и "Связь"? только не просто три кнопки а что то типо ListItem клкабельный?

**План и изменения**

- Продолжение37, CODE, TestGate NOT_REQUIRED: только HTML/CSS визуальная композиция. Core R-001/002/004/007 прочитаны, прежнее влияние сохранено; Flutter/conditional rules неприменимы.
- Основная статистика заменена выбранным achievement-блоком с прежними fixture3/12/28. Раскрытая about-card заменена общим списком трёх button-строк с иконками/chevrons, hover/active/focus. Исторические макеты и редактор не изменялись.
- Долговременное решение и границы статичных действий описаны в docs/design/html-prototype.md.

**Проверки**

- Локальная структурная проверка выбранного блока, трёх строк, уникальных ID и SVG-ссылок; rules checker и diff-check.
- Browser observation file:// отклонена URL policy; альтернативным способом ограничение не обходилось. Screenshot/геометрия не проверены; пользователь обновляет открытую вкладку вручную.

**Итог итерации**

- Главное достижение — основной вариант, настройки остаются в списке профиля. Следующий шаг — проработка содержимого разделов. Runtime-действия не заявляются.

Создана просматриваемая HTML-галерея; актуальный состав уточняется следующими итерациями. Нет редактора, JS и изменений Flutter. Дизайн пока proposal; полная реализация приложения не заявляется.

### Итерация 25 — 2026-10-15

**Prompt пользователя**

> да давай профиль новичка и профиль с последним результатом
> и сдлеай по общим принципам которые мы с тобой выявили остальные экраны которых нам не хватает для приложения и перед реализации каждого экрана читай гайдлайны Apple и других крутых дизайнеров

**Scope и план**

- Продолжение37: CODE/NOT_REQUIRED, только статичные HTML-состояния и ссылки между ними, без прикладной логики. Scope расширен явным запросом: профили novice/recent, history/loading/setup/lobby/distribution/live/bracket/result/finish; utility-пункты профиля и read-only spectator. Существующие8 previews сохраняются, только входы получают якоря.
- До реализации изучены Apple ContentUnavailable/Lists/Progress/Sheets/Alerts/Settings/Scroll views/Designing for games и NN/G Empty states/Forms/Visibility/Hierarchy/Progressive disclosure/Errors. Карта конкретных экранов и решений будет в docs/design/full-flow-prototype.md; источники не диктуют наш фирменный стиль.
- Сначала общие flow-примитивы/CSS с token-параметрами, затем группы в порядке flow. Минимум текста, крупная типографика, один главный CTA, непрозрачные floating-actions, все упоминания игроков после раздачи с персонажем и avatar-placeholder. Нет портретных assets — не выдавать условные знаки за готовый арт.
- Правила из docs/source/mk11_tournament_rules_ru.md: DE reset всегда, SE3–4 совместные, RR FT2/3–2–1–0 и miniRR при равенстве; no draw/Cancelled, техрезультат без2:0, no edit после зависимого сыгранного матча. Состав/матчи/статистика fixtures, бизнес-правила не утверждаем заново.
- Проверки: structural refs/ARIA/IDs/resources и сохранность принятых экранов, browser desktop/narrow geometry при доступности, сравнение семантики fixtures с MK11, rules/diff. Ограничения проверок записать честно. Нет Flutter/build/commit; UI не объявляется production.

**Промежуточный статус**

Исследование завершено до новых экранов, реализация начата.

**Результат итерации25**

- Добавлены38 previews: два состояния профиля, история/пустота, открытие/ошибка, DE/SE/RR-настройка, гости/добавление, раздача/готовность, проведение/RR/miniRR, две сетки, результаты DE/RR/исправление/ошибка/технический, чемпион/три итоговых рейтинга, utility-разделы, spectator/потеря связи и подтверждения. Всего46, без возвращения отклонённых альтернатив профиля.
- Общие flow-примитивы вынесены в flow.css; цвета/размеры используют CSS-токены. Сетки имеют линии и собственный горизонтальный scroll. На очень узком home-active найдены тесные header/actions: разрешён перенос, адаптивный padding, без перерисовки принятого desktop/mobile390 дизайна. У портретных placeholders сохранена квадратная пропорция при сужении.
- docs/design/full-flow-prototype.md содержит таблицу всех38 новых состояний с Apple/NNG-ссылками и применённым решением. README/html-prototype обновлены. Прочитанные общие принципы не выдаются за обязательный Apple-макет или утверждение новых business rules.

**Проверки**

- Node structural:46 figure/46 article,0 duplicate IDs,0 missing anchor/ARIA/SVG refs,0 missing HTML resources,0 scripts. Все figure внутри variants. Пять CSS-файлов:0 undefined CSS tokens,0 отсутствующих font assets.
- Browser: галерея открыта через ограниченный read-only Node HTTP preview127.0.0.1:8095. Выполнены reload/якорная навигация, screenshot-осмотр новых профилей, sheets, проведения, итогов и spectator. Геометрия всех screen-content/sheets/alerts проверена на desktop и фактических узких ширинах317/291px: horizontal overflow страницы/контента отсутствует;9 модальных контейнеров не выходят за phone. Запрошенные349/320px backend отображает как317/291px — точный320px screenshot не заявляется. Проверены квадратные портреты и4 результата RR, console errors отсутствуют; native goldens не выполнялись.
- Проверка fixtures по MK11: FT2 и3/2/1/0 для RR; miniRR по победам без пересчёта основной таблицы; общий3–4 SE; reset DE указан как обязательное условие; tech без искусственного счёта; запрет исправления после сыгранного зависимого матча. Это проверка визуального содержания, не тест расчётов.
- Rules checker:15 leaf/2 группы; git diff --check без ошибок (только предупреждение будущего LF→CRLF в tokens.css). Build/commit/push не выполнялись.

**Ограничения и итог**

- Галерея статична, не полное приложение: переходы не сохраняют значения, preview-состояния независимы; загрузки не завершаются сами. Реальные портреты пока заменены буквенными marks, канал связи/адрес spectator демонстрационные, полного графа DE/Bye для всех размеров нет. Эти ограничения подробно вынесены в docs, а не замаскированы fake-логикой.
- Stage IMPLEMENTING → VERIFYING → DONE. Задача37 закрыта в рамках HTML-прототипа; принятие/перенос каждого экрана в Flutter остаётся отдельной работой.

### Итерация 26 — 2026-10-15

**Prompt пользователя**

> обьедени пункт 03 и 04 и давай блок с последним турниром внесем переред статистикой

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: HTML-композиция без логики. Core R-001/002/004/007 прочитаны: единая группа/без дублирующего просмотра, актуализация docs, без предметных моделей, структурная и browser-проверка. Flutter/conditional неприменимы; workflow прочитан.
- Объединить03/04 в один раздел: основной профиль с последним турниром перед статистикой, новичок, редактор и ошибка. Удалить отдельный дублирующий recent-preview, сохранить его якорь на блоке результата; убрать повторный пункт меню. Сохранить данные и остальные экраны; номера последующих разделов сдвинуть на один.
- Проверить порядок блоков/групп, ссылки/IDs и responsive overflow, просмотреть профиль в браузере. Без сборок/коммита.

**Результат и проверки**

- Раздел03 содержит основной профиль (последний турнир → статистика), новичка, редактор и ошибку. Отдельная группа04 и дублирующий recent-preview убраны; оба прежних якоря сохранены в объединённом разделе. Следующие номера сдвинуты на один. Docs обновлены; теперь45 previews.
- Browser desktop: порядок identity → last-result → stats → menu подтверждён, duplicate IDs0, brokenRefs0, profile overflow0. Screenshot объединённой группы просмотрен. При фактической ширине317px profile/page horizontal overflow отсутствует; override сброшен, вкладка сохранена.
- Rules checker и git diff --check пройдены. Нет Flutter/build/commit/push. Итерация26 завершена, Stage DONE.

### Итерация 27 — 2026-10-16

**Prompt пользователя**

> 05 выровни компоненты, текста сьезжают

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: только HTML/CSS раздела05 «Открытие турнира». Core R-001/002/004/007 перечитаны: scoped layout без влияния на другие состояния, косметическая правка не требует нового product-документа, предметные данные не меняются, проверка browser-геометрии/overflow и rules/diff. Flutter/conditional неприменимы; workflow прочитан.
- Причина: flex-центрирование loading/error зависит от доступной высоты, а у error нижний CTA занимает дополнительное место. Высота cue тоже различается. Ввести общие позиции cue/заголовка/подписи, не меняя текстов, кнопок и других экранов.
- Проверить совпадение относительных координат в обоих состояниях на desktop/узкой ширине, отсутствие overflow, визуальный просмотр. Без build/commit.

**Результат и проверки**

- Только раздел05: убрано зависимое от CTA flex-центрирование, задан общий отступ состояния и cue48px. Под заголовок выделены две строки на широком frame и три на узком, чтобы подписи не смещались из-за переноса. Волнистый progress и error-symbol используют одну cue-зону; тексты/действия сохранены.
- Browser desktop после fonts.ready: cue/header/caption на одинаковых координатах297/369/485px от начала phone в обоих состояниях. На фактической ширине317px —297/369/531px в обоих, horizontal overflow отсутствует. Screenshot просмотрен; viewport override сброшен, вкладка оставлена на разделе05.
- node tools/check_rules.cjs:15 leaf/2 группы; git diff --check успешен, только предупреждение LF→CRLF. Косметический layout, отдельное обновление product docs не требуется. Без Flutter/golden/build/commit. Stage DONE.
