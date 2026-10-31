# Задача 37. HTML-прототип экранов

## Changelog — итерация69, 2026-10-31

**Prompt пользователя**

> текста не выровняны по высоте

**Изменения и проверки**

- Продолжение37 CODE/NOT_REQUIRED: utility loading/error получили одинаковую content-height и зарезервированную dock-зону независимо от кнопки повтора. Двухстрочный title/caption имеют одинаковые min-height, cue высотой progress сохраняется.
- Scoped CSS, core applicability прежняя; косметическое выравнивание R-002 без отдельного docs, Flutter/conditional нет. Diff-check PASS; точная browser geometry NOT_RUN (file:// policy). Без build/commit, Stage DONE.

## Changelog — итерация68, 2026-10-31

**Prompt пользователя**

> утилитарные экраны не совподают по лейаутам. Посмотри первый экран распределение. Один в один должен быть утилитарный

**Изменения и проверки**

- Продолжение37 CODE/NOT_REQUIRED: loading скопирован из distribution-working с заменой только fixture labels/back. Возвращён header, убрана opening-cue обёртка. Error на той же композиции, с символом вместо progress/повтором в dock.
- Core применимость прежняя: общий layout/docs/без business logic/source verification. Flutter/conditional нет. Source structure и diff-check; browser geometry NOT_RUN (file:// policy). Без build/commit, Stage DONE.

## Changelog — итерация67, 2026-10-31

**Prompt пользователя**

> давай выделим утилитарные экраны. Например загрузка явлется общей для всех экранов и становится между экранами. Не будем ее присваевать какомоу конкретному flow

**Изменения и проверки**

- Продолжение37 CODE/NOT_REQUIRED: прежнее открытие турнира стало00 utility-loading/error без tournament copy/header; группа перед Bootstrap. Все старые ссылки заменены. Bootstrap и distribution progress остаются предметными состояниями запуска/раздачи. Runtime lifecycle не меняется.
- Core R-001/002/004/007: общая композиция/docs/статичные anchors/structural verification; Flutter/conditional нет. IDs/anchors/utility group и diff-check PASS. Browser screenshot NOT_RUN (file:// policy). Без build/commit, Stage DONE.

## Changelog — итерация66, 2026-10-31

**Prompt пользователя**

> так теперь сделай экраны близкие по смыслу рядом, а то профиль у нас раскидан по всему прототипу по немного

**Изменения и проверки**

- Продолжение37 CODE/NOT_REQUIRED: порядок галереи по смыслу. Profile sections рядом с profile; access рядом с distribution; withdraw/locked рядом с running; forfeit рядом с result. Группа общих dialogs убрана, IDs figures сохранены. Подписи групп профиля/access согласованы с соседями.
- Core R-001/002/004/007: композиция/docs/HTML anchors/structural checks; Flutter/conditional неприменимы. IDs/anchors и diff-check PASS. Визуальные компоненты не менялись, browser render не выполнялся. Без build/commit, Stage DONE.

## Changelog — итерация65, 2026-10-31

**Prompt пользователя**

> убери из прототта экран спектатор

**Изменения и проверки**

- Продолжение37 CODE/NOT_REQUIRED: удалена группа16 с2 screens spectator-live/offline; Host QR access и кнопки сохранены. Удаление восстановимо через Git. Core applicability прежняя: scoped composition/docs/без business logic/structural checks; Flutter/conditional нет.
- Node: spectator IDs отсутствуют, tournament-share сохранён, anchors PASS; diff-check PASS. Визуальный render не требуется для удаления целых figures, остальные не менялись. Без build/commit, Stage DONE.

## Changelog — итерация64, 2026-10-31

**Prompt пользователя**

> делаем

**Контекст, план и изменения**

- Подтверждён аудит dialogs в чате: компактные alerts, единый порядок, inline-причина blocked correction; result entry остаётся sheet. Продолжение37 CODE/NOT_REQUIRED: визуальный HTML без новой предметной логики.
- Core/router/workflow прочитаны; R-001 общая alert-композиция, R-002 docs с первичными Apple/W3C sources, R-004 причины/fixtures без новых бизнес-правил, R-007 структурные проверки. Flutter/conditional неприменимы.
-3 alerts: короткие вопросы, action выше Cancel, без icons в кнопках; спокойные общие размеры/радиусы без floating shadows. Guest-remove получил dialog semantics. Result-locked стал обычным screen с disabled correction и причиной.

**Проверки и границы**

- Node:3 confirmations action order/no SVG/roles PASS; restriction не modal, disabled PASS; unique IDs/anchors PASS. Rules15 leaf2 группы и diff-check PASS.
- Browser screenshot NOT_RUN: file:// observation ранее отклонена политикой браузера; геометрия не заявляется проверенной. Focus trap/Escape/return focus не добавлены в статичную галерею; production-модальность не заявляется. Без Flutter/build/commit.
- Stage IMPLEMENTING → VERIFYING → DONE, визуальный scope завершён.

## Changelog — итерация63, 2026-10-31

**Prompt пользователя**

> иконка не shared

**Изменения и проверки**

- Косметическое продолжение37 CODE/NOT_REQUIRED: share-link заменён с export-arrow на три соединённые точки (share). Путь/контракт кнопки не менялся. Core scope прежний; по исключению R-002 отдельный docs-update не нужен. Flutter/conditional нет.
- SVG source и diff-check PASS. Browser NOT_RUN (file:// policy), без build/commit. Stage DONE.

## Changelog — итерация62, 2026-10-31

**Prompt пользователя**

> на экране зрительского просмотра должна быть ссылка которую можно будет скопировать кнопкой shared и qr как для подключения участников а кнопки предосмотр не должно быть

**Изменения и проверки**

- Визуальное продолжение37 CODE/NOT_REQUIRED: tournament-share получил существующий spectator QR в общем оформлении participant QR, прямую ссылку и copy affordance с share-icon; предпросмотр удалён. Encoded QR fixture и адрес совпадают (host.local/spectator). Copy пока visual-only по scope prototype, Clipboard/Share logic не добавлялась.
- Core R-001/002/004/007: reuse QR, docs, без новых предметных данных, structural checks. Flutter/conditional нет. Node QR/link/button/no-preview/unique IDs/anchors и diff-check PASS; browser NOT_RUN (file:// policy). Без build/commit, Stage DONE.

## Changelog — итерация61, 2026-10-31

**Prompt пользователя**

> неправильно. Номер мест убераем. А очки оставляем просто без подписи

**Изменения и проверки**

- Исправление итерации60 в37: удалены видимые place1/2/3, восстановлены score6/3/0 без очк.; RR row grid теперь identity+score без пустой колонки места. Docs синхронизирован.
- CODE/NOT_REQUIRED, core применимость прежняя; Flutter/conditional нет. Scoped source/diff-check; browser NOT_RUN (file:// policy). Без build/commit, Stage DONE.

## Changelog — итерация60, 2026-10-31

**Prompt пользователя**

> давай на итогах RR уберем цифры победителей и подписи "очк."

**Изменения и проверки**

- Визуальное продолжение37 CODE/NOT_REQUIRED: из tournament-results-rr удалены3 score-блока6/3/0 и подписи очк.; места/участники сохранены. Таблица проведения не менялась.
- Core R-001/002/004/007: scoped HTML, docs, без изменения расчётов, source/diff-check PASS. Flutter/conditional неприменимы. Browser screenshot NOT_RUN (file:// policy). Без build/commit, Stage DONE.

## Changelog — итерация59, 2026-10-31

**Prompt пользователя**

> FT2 тоже будет выбираться таким же способом. Только FT1 будет выбираться нашими селекторами

**Изменения и проверки**

- Продолжение37 CODE/NOT_REQUIRED: FT2 normal/correction/error приведены к общему визуальному вводу FT3/10. Победитель слева,2:1, numeric range0–1; FT1 selectors сохранены. Это fixtures без новой логики выбора/валидации.
- Core R-001/002/004/007: переиспользование разметки/styles, docs, данные без business logic, structural verification. Flutter/conditional неприменимы.
- Node:3 FT2 cases имеют stepper/max1 без score-options; FT1 selectors сохранены PASS. Diff-check PASS. Browser screenshot NOT_RUN (file:// policy). Без build/commit, Stage DONE.

## Changelog — итерация58, 2026-10-31

**Prompt пользователя**

> нормально размести рядом с основным экрано, остальные эксперементы убери

**Изменения и проверки**

- Продолжение37, визуальная CODE/NOT_REQUIRED: FT3/FT10 перемещены непосредственно после основного result в группе11; отдельные экспериментальные группы удалены вместе с4 выбор/confirmation-копиями. Другие действия ведут к прежним technical/withdraw fixtures. Core R-001/002/004/007 — композиция/docs/без business logic/structural; Flutter/conditional неприменимы.
- Node: adjacency, unique IDs, anchors PASS; diff-check PASS. Browser screenshot NOT_RUN (file:// policy). Удалённые варианты восстановимы из Git/истории задачи. Без build/commit, Stage DONE.

## Changelog — итерация57, 2026-10-31

**Prompt пользователя**

> че то селекторы выглядят не так

**Изменения и проверки**

- Продолжение37, CODE/NOT_REQUIRED. У score-stepper оставались текстовые +/- и уменьшенные кнопки: заменены на те же SVG minus/plus и control-size, что FT-компонент. Общая капсула/фон/font сохранены. Core применимы как в56; косметическое уточнение R-002 без нового контракта, Flutter/conditional нет.
- Diff-check PASS, наличие общих SVG проверено по source. Browser geometry NOT_RUN (file:// policy); узкая ширина остаётся ограничением проверки. Без build/commit, Stage DONE.

## Changelog — итерация56, 2026-10-31

**Prompt пользователя**

> Слово победитель точно лишнее. Персонажи должны быть на одном уровне. А для +- у нас был класный компонент

**Изменения и проверки**

- CODE/NOT_REQUIRED, continuation37: удалена winner-label из2 examples, выравнивание пары восстановлено одинаковым составом карточек. Степпер переиспользует CSS существующего FT-компонента (единая капсула/кнопки), без подключения FT-JS к score.
- Core R-001/002/004/007: общие styles, docs, fixture без логики, scoped checks. Flutter/conditional неприменимы. Diff-check/rules15 leaf2 группы PASS; browser geometry NOT_RUN (file:// restriction). Без build/commit, Stage DONE.

## Changelog — итерация55, 2026-10-31

**Prompt пользователя**

> покажи пример

**Изменения и проверки**

- Визуальное продолжение предложения FT3/FT10:2 статичных макета3:1/10:7, победитель слева отмечен, под проигравшим numeric field/stepper. Без JS/изменения результатов; readonly честно фиксирует визуальный scope. Основные sheets сохранены.
- CODE/NOT_REQUIRED; core R-001/002/004/007 текущего scope: общая композиция, docs, fixture-данные, structural checks. Flutter/conditional неприменимы.
- Node:2 examples, winner/stepper/actions, unique IDs и anchors PASS; diff-check PASS. Browser screenshot NOT_RUN (file:// policy). Stage DONE, без build/commit.

## Changelog — итерация54, 2026-10-31

**Prompt пользователя**

> ладно оставляем другие действия как сейчас есть. Давай лучше уберем определение FT А еще нужно подумать как отображать счет при разном FT. на FT2 выглядит норм, но что делать при FT3 или вообще FT10

**Изменения и проверки**

- CODE/NOT_REQUIRED: только убрать FT-caption из4 result sheets. «Другие действия» и score choices сохранены. Большие FT обсуждаются, реализации нового ввода пока нет.
- Core/router/workflow прочитаны; R-001 scoped HTML, R-002 docs, R-004 без новых данных/логики, R-007 структурная проверка4 sheets, наличия действий/IDs/anchors и diff-check PASS. Flutter/conditional неприменимы.
- Browser render NOT_RUN (file:// policy). Без build/commit. Stage IMPLEMENTING → VERIFYING → DONE.

## Changelog — итерация53, 2026-10-31

**Prompts пользователя**

> работаем над вводом результата. Убераем режим, надпись vs , подпись счет и галочку рядом с счетом, еще надо определиться как по другому вводить рещультат формата "Исключить игрока"

> не понимаю как это покажи

**Изменения и проверки**

- CODE/NOT_REQUIRED, визуальное продолжение37. Core R-001/002/004/007: scoped общие styles, docs, статичные typed-by-markup fixtures, structural verification. Flutter/conditional неприменимы.
- Из result sheets убраны режим/VS/«Счёт»/check у score; сохранение в header осталось. Другие действия ведут к2 новым selection-макетам. Оба игрока ведут к соответствующему подтверждению снятия или сдачи; добавлены2 confirmation-fixtures для Ивана, существующие для Алексея сохранены.
- ID/anchors, rules checker15 leaf/2 группы и diff-check PASS. Browser screenshot NOT_RUN из-за file:// policy. Никакой реальной result/domain логики, build/commit нет. Stage DONE.

## Changelog — итерация52, 2026-10-31

**Prompt пользователя**

> выровней цвет контейнера для заголовка с кнопками

**Изменения и проверки**

- Продолжение37, CODE/NOT_REQUIRED, косметическая CSS-правка: фон header-title surface → raised, как у orb. Core rules сохраняют применимость; Flutter/conditional неприменимы. По исключению R-002 отдельный docs-update не требуется для выравнивания цвета без нового контракта.
- Проверено соответствие CSS token фону orb; git diff --check PASS. Browser screenshot NOT_RUN (file:// policy). Без build/commit; Stage DONE.

## Changelog — итерация51, 2026-10-31

**Prompt пользователя**

> кнопка настроек снизу выбивается из стиля приложения. А еще давай турнирная сетка будет под хеадером и тд. Просто названию в header дадим свой ливитирующий контейнер

**Изменения и проверки**

- Продолжение37, CODE/NOT_REQUIRED, scoped CSS карты. Core R-001/002/004/007 применены: общие визуальные tokens/orb, docs, без предметных данных, структурная проверка. Flutter/conditional неприменимы.
- Header absolute над картой; название в непрозрачной pill, ограничено средней колонкой с ellipsis. Back/QR сохранены, пустое пространство header пропускает pointer events. Нижняя кнопка имеет тот же control-size/raised/circle/shadow, что orb; panel radius/spacing из общих tokens.
- JS syntax и diff-check PASS. Browser geometry NOT_RUN: ранее установлен запрет observation file://. Без Flutter/build/commit. Stage IMPLEMENTING → VERIFYING → DONE.

## Changelog — итерация50, 2026-10-31

**Prompt пользователя**

> давай не контейнер, а весь экран отдадим сетке

**Изменения и проверки**

- Продолжение37, CODE/NOT_REQUIRED: только scoped CSS обоих map-экранов. Core R-001/002/004/007 из текущей работы: единая map-композиция, docs обновлён, данных/логики нет, проверки по визуальному scope; Flutter/conditional неприменимы.
- Убраны padding/gap content, рамка/радиус карты, пустой dock; карта заполняет всё пространство под header. Сохранены header/back/QR, плавающее управление поднято над home-indicator.
- JS syntax и git diff --check PASS; browser geometry NOT_RUN из-за ранее установленного запрета file:// observation. Без Flutter/build/commit. Stage IMPLEMENTING → VERIFYING → DONE.

## Changelog — итерация49, 2026-10-31

**Prompt пользователя**

> кнопки управления и подсказки мешают

**Изменения и проверки**

- Продолжение37, CODE/NOT_REQUIRED, core/router/workflow из текущей итерации применены: R-001 scoped map, R-002 docs, R-004 без предметной логики, R-007 syntax/structure. Flutter/conditional неприменимы.
- Управление обоих полотен в native details с одной плавающей кнопкой. Панель раскрывается по нажатию; обзор/переход/выбор закрывают её. Видимая нижняя подсказка убрана, aria-live остаётся для выбранного матча. Карта не резервирует место под панель.
- JS syntax, rules15 leaf/2 группы и diff-check PASS. Browser render NOT_RUN: ранее file:// observation запрещена политикой браузера. Без build/commit. Stage IMPLEMENTING → VERIFYING → DONE.

## Changelog — итерация48, 2026-10-31

**Prompts пользователя**

> нравится все кроме SE - оно должно отображаться так же, просто у него не будет нижней сетки

> делаем

**План и изменения**

- CODE / TestGate NOT_REQUIRED: визуальная карта, zoom/scroll/selection без предметных изменений. Core R-001/002/004/007 и workflow прочитаны; Flutter/conditional неприменимы. Отдельные map CSS/JS, общий подход SE/DE, docs и проверки связей.
- Группа10 заменена полотном8 участников:7 верхних матчей, DE плюс6 нижних, Grand Final/условный Reset. Current выделен золотой рамкой. Scroll по двум осям, zoom buttons, fit/current, native fullscreen и выбор матча с подробностью. QR и back сохранены.
- Старт current, SE использует ту же карту без нижней ветки. Pinch, поиск и трассировка полного пути игрока остаются дальнейшей доработкой.

**Проверки и ограничения**

- JS syntax, rules checker15 leaf/2 группы и diff-check PASS. Структурно:2 карты, IDs уникальны, anchors существуют. Scope только2 figures и новые map assets/docs/task.
- Browser screenshot и проверка реальных жестов NOT_RUN: file:// observation ранее отклонена browser policy. Fit/zoom/fullscreen пока не подтверждены браузерным прогоном; успех runtime не заявляется. Без Flutter/build/commit.
- Stage IMPLEMENTING → VERIFYING → DONE; поставлен визуальный prototype с указанными ограничениями проверки.

## Changelog — итерация47, 2026-10-31

**Prompt пользователя**

> на всех экранах турнрина (кроме экранов ввода данных) начиная с 09 должен быть qr для spectator

**План и изменения**

- CODE, TestGate NOT_REQUIRED: визуальные HTML-ссылки. Core/router/workflow перечитаны, Flutter/conditional неприменимы. R-001: существующая orb/QR-композиция; R-002: docs обновлён; R-004: HTML-якоря без предметной логики; R-007: проверка охвата и ссылок.
- В11 Host-headers проведения, сеток, переигровки, чемпиона/рейтингов — одна QR-кнопка на существующий tournament-share. Result entry/correction и диалоги без дополнительных действий. Профиль/read-only Spectator не менялись. Экран доступа уже содержит сам QR.
- Stage IMPLEMENTING → VERIFYING → DONE, задача переоткрыта и закрыта в реестре.

**Проверки**

- Node:11 headers имеют ровно одну ссылку Spectator и QR-icon; unique IDs и anchors PASS. Rules checker15 leaf/2 группы и git diff --check PASS.
- Screenshot не выполнялся из-за ранее установленного запрета browser observation file://. Обновить открытую вкладку вручную. Без Flutter/build/commit.

## Статус и этап

### Итерация46 — 2026-10-31

**Prompt пользователя**

> 09 - давай подписи "Пятничный турнир · DE" и тд вынесем в заголовок, DE не будем указывать. Уберем "vs" это и так понятно. Кто далее должно быть сразу под теми кто сейчас и должно быть на всех режимах, а не только DE

**Изменения и проверки**

- CODE, TestGate NOT_REQUIRED; визуальная правка группы09, Stage IMPLEMENTING → VERIFYING → DONE. Core/router/workflow перечитаны; Flutter/conditional неприменимы. R-001: scoped styles; R-002: docs обновлён; R-004: статичные fixtures; R-007: structural checks.
- Название перенесено в header без режима; VS удалён, пара имеет две колонки. «Кто далее» непосредственно после текущего матча во всех DE/SE/RR/miniRR. Добавлен SE preview; FT/стадия сохранены.
- Node: четыре текущих матча PASS (header/noVS/next order),49 figures, unique IDs и anchors PASS. Rules15 leaf/2 группы и diff-check PASS.
- Screenshot не выполнялся: file:// observation ранее заблокирована URL policy. Геометрия новой композиции не подтверждена. Без Flutter/build/commit; обновить открытую вкладку вручную.


✅ Завершена

- Mode: CODE.
- TestGate: NOT_REQUIRED — HTML/CSS-прототип с локальным визуальным взаимодействием FT и ссылками между демонстрационными состояниями; без бизнес-логики или сохранения.
- Stage: DONE; specification/plan 44, test set 1.
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

### Итерация 28 — 2026-10-18

**Prompt пользователя**

> Так смотри по поводу 06 экрана, Я вижу label полей абсолютна разные. Нужно унифицировать? А так же нужно чтобы все инпуты были одной высоты 56px так же кнопки

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: HTML/CSS прототип, без Flutter/прикладной логики. Core R-001/002/004/007 и workflow перечитаны; conditional нет. Общая геометрия контролов и labels вместо локальных дубликатов, решение в docs, предметные данные без изменений, browser-замеры и rules/diff.
- На06 DE/SE/RR унифицировать подписи названия/формата/FT: размер, начертание, цвет, отступ, размещение над контролом. FT-selects полной ширины, как input. Общий control56px для однострочных inputs/selects и обычных кнопок/ссылок-действий по галерее; многострочная textarea и карточки-ссылки не сжимаются до56.
- Проверки: browser высот/стилей labels, desktop/narrow overflow, сохранение label-for/IDs/refs, visual review. Без сборок/коммита.

**Результат и проверки**

- Общий control56 применён к однострочным inputs/selects, стандартным кнопкам, segmented choices, вторичным действиям и строкам меню. Убраны вертикальные padding, из-за которых двухстрочный CTA на узкой ширине разрастался до80px. Многострочная textarea/карточки-ссылки сохранены.
- Label-токены общие: Inter14/400/21, secondary, gap8 над контролом. DE/SE/RR используют одинаковую подпись «Формат», FT-selects полноширинные с той же высотой/типографикой значения, что input. Решение записано в docs/design/html-prototype.md, Flutter не менялся.
- Browser desktop: все labels DE имеют одинаковые font/color и gap8, высоты контролов56, brokenRefs0, overflow0. Проверены также контролы SE/RR. При фактической ширине317px все130 стандартных контролов галереи имеют56px (погрешность округления<1px), horizontal overflow0. Итоговый screenshot06 просмотрен; viewport сброшен и вкладка оставлена пользователю.
- Локальный read-only preview8095 восстановлен после connection refused; доступ только к прототипу и font assets. node tools/check_rules.cjs:15 leaf/2 группы; git diff --check успешен (LF→CRLF warnings). Без build/golden/commit/push. Stage DONE.

### Итерация 29 — 2026-10-18

**Prompts пользователя**

> селектор раньше выглядил куда лучше

Уточнение, какой именно selector:

> **DE / SE / RR**

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: только оформление segmented selector, без изменения FT-selects, labels, данных или логики. Core R-001/002/004/007 и workflow перечитаны; Flutter/conditional неприменимы.
- Вернуть inset-внешний вид: общая подложка, внутренние отступы8 и отдельная активная капсула. Внешний control и область нажатия каждого сегмента остаются56px; активная декоративная подложка меньше, через pseudo-element. Внешний вид один для DE/SE/RR-вариантов.
- Browser desktop/narrow: геометрия56/8, активный сегмент, overflow и визуальный просмотр; rules/diff. Косметическое восстановление без изменения контракта, новый product doc не требуется. Без build/commit.

**Результат и проверки**

- Возвращены внутренние отступы и отдельная округлая подложка активного сегмента. Только flow-options CSS; остальные контролы и labels не изменены.
- Browser desktop: все3 selector высотой56, каждый сегмент56, padding/inset8, текущие DE/SE/RR сохранены; screenshot просмотрен. При фактической ширине317px высоты те же, overflow selectors/screens0. Viewport сброшен, вкладка сохранена.
- node tools/check_rules.cjs успешен (15 leaf/2 группы); git diff --check без ошибок, только LF→CRLF warnings ранее затронутых CSS. Без build/commit. Stage DONE.

### Итерация 30 — 2026-10-18

**Prompt пользователя**

> давай просто общую высоту сделаем 64 пикселя и посмотрим как это выглядит

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: только высота переключателя формата DE/SE/RR. Core R-001/002/004/007 и workflow перечитаны; отдельный token селектора, документированное исключение из56px, без бизнес-логики, browser-замеры и rules/diff. Flutter/conditional неприменимы.
- Увеличить общий selector до64px, отступы8 оставить: активная капсула48px. Остальные поля/кнопки сохраняют56px. Показать в действующей галерее, без изменения inline-сравнения.
- Проверить все3 варианта на desktop/narrow:64/48, overflow, остальные контролы56; без сборок/коммита.

**Результат и проверки**

- Добавлен отдельный token format-control-height64; только сегменты формата стали выше. Active pseudo-element с inset8 теперь48px. Документация обозначает исключение; остальные контролы не менялись.
- Browser: DE/SE/RR64px, active48px; inputs/selects/CTA56px. На фактической ширине317px все3 selector64px без overflow. Screenshot просмотрен, override сброшен, вкладка оставлена для оценки. Первый замер исправлен после ошибки ограниченного evaluate parseFloat; повторный замер успешен.
- Rules checker15 leaf/2 группы, git diff --check успешен (LF→CRLF warnings). Без build/commit. Stage DONE в пределах пробного визуального изменения, выбор финальных пропорций остаётся за пользователем.

### Итерация 31 — 2026-10-26

**Prompt пользователя**

> делаем степером

**Решение, scope и проверки**

- Продолжение37: CODE/NOT_REQUIRED, выбор пользователем варианта «Степпер» из6 демонстраций. Только HTML-preview: четыре FT-контрола DE/SE (основная сетка/финал), без Flutter, турнировых расчётов, routing или persistence. R-001/002/004/007 и workflow перечитаны, conditional/Flutter неприменимы. Общая визуальная механика, docs решения, DOM-атрибуты не предметная модель, executable/browser-проверка взаимодействия.
- Label слева, справа компактная капсула «− FT1 +», высотой56. На узкой ширине label над контролом. Формат DE/SE/RR64 остаётся; RR FT2 не редактируется. Значения FT1/2/3 — прежние варианты preview, не утверждение максимального FT в бизнес-правилах; defaults FT1 сохранены. Изменение каждого preview локально, не сохраняется и не управляет другими экранами.
- Проверить независимость4 степперов, обе границы/disabled, keyboard-native buttons и live output, refs/ARIA/ресурсы, desktop/narrow layout, rules/diff. Без сборки/коммита. Прикладная логика не добавляется; локальное переключение демонстрационного текста относится к визуальным взаимодействиям по workflow.

**Результат и проверки**

- Четыре FT-select заменены на общие степперы56px; label слева/адаптивно сверху, svg +/- из общего набора, output с aria-live, disabled на границах. Единственный inline script переключает только текст preview, никакой реальной настройки турнира; решения и ограничения отражены в обоих prototype docs. RR не менялся.
- Executable Node/vm check фактического inline script:4 контрола, FT1→FT2→FT3 и обратно, обе границы и disabled, независимость, уникальные IDs и все refs — PASS. Это проверка UI-механики, не бизнес-расчётов.
- Browser click и Enter: изменяется только выбранная основная сетка; верхняя граница FT3 блокирует плюс, возврат FT1 блокирует минус. Четыре степпера56px, RR0 степперов. При фактической ширине317px все56×160px, переполнение всех screen-content/sheets/alerts0, broken ARIA0, console errors0. Screenshot просмотрен; viewport сброшен, вкладка оставлена на06. Проверена адаптивная композиция.
- Preview127.0.0.1:8095 восстановлен (только HTML/CSS/fonts). Rules checker15 leaf/2 группы, git diff --check успешен с LF→CRLF warnings. Без Flutter/build/golden/commit/push. Stage DONE.

### Итерация 32 — 2026-10-26

**Prompt пользователя**

> давай пернем заголовок профиля в верху, сделаем это более унифицировано

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: верхняя строка профиля в HTML. Core R-001/002/004/007 и workflow перечитаны; Flutter/conditional неприменимы. Общая сетка заголовка вместо отдельной компоновки просмотра, тексты/ARIA без модели, docs и browser/structural checks.
- Основной профиль и новичок получают «Профиль» между круглыми back/edit. Редактор и ошибка сохраняют «Редактирование». Общие размеры/центровка/типографика header; контент ниже не перестраивается. Проверить4 состояния на desktop/narrow, refs и overflow. Без build/commit.

**Результат и проверки**

- Вернули заголовок «Профиль» в просмотр и состояние новичка. Все четыре состояния используют центрированный Inter16/600 и верхнюю строку56px между круглыми кнопками. В редакторе/ошибке сохранено «Редактирование». Общая сетка и токены, без перестройки контента; решение отражено в документации прототипа.
- Browser: все4 заголовка высотой56px, отклонение от центра0px, горизонтального переполнения нет — на desktop и фактической узкой ширине317px. Неразрешённых ссылок-якорей0. Screenshot просмотрен; временный viewport сброшен, вкладка оставлена на профиле.
- Rules checker:15 leaf/2 группы; git diff --check успешен с предупреждениями LF→CRLF. Без Flutter, сборок, golden, коммита и push. Stage DONE.

### Итерация 33 — 2026-10-26

**Prompt пользователя**

> давай плюс перенесем а bottom sheet пока не будем переносить

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: перенос действия добавления гостя в закреплённую верхнюю строку состава; только HTML/CSS. R-001/002/004/007 и workflow прочитаны; Flutter и conditional неприменимы. Общая геометрия header/orb, доступное имя ссылки, docs решения, browser и rules/diff checks. Без предметной логики.
- Плюс56px справа от «Участники», тот же якорь guest-add; убрать дублирующую кнопку после списка. Верхнюю строку вынести за прокручиваемый контент, нижнюю «Раздать персонажей» сохранить. Существующий макет добавления гостя не менять; bottom sheet/пакетный ввод не реализовывать.
- Проверить переход туда/обратно, отсутствие overflow desktop/narrow и доступность плюс/CTA после прокрутки длинного списка без изменения рабочего fixture; без build/commit.

**Результат и проверки**

- Плюс справа в заголовке,56×56px, с aria-label/title «Добавить гостя» и прежним якорем guest-add. Header вынесен за screen-content, нижняя CTA также остаётся вне scroll; дублирующая кнопка удалена. Существующая форма guest-add не изменена; docs обновлены.
- Browser: плюс открывает guest-add, «Назад» возвращает lobby-roster. Desktop и фактическая ширина317px — без горизонтального overflow; плюс56×56, broken anchors0. На узком экране есть scroll-range19px, header и CTA структурно вне scroll-контейнера и не прокручиваются с ним. Отдельный runtime fixture10+ гостей не добавлялся и не проверялся; независимость header от длины списка подтверждена DOM-компоновкой. Screenshot просмотрен, viewport сброшен, вкладка оставлена на составе.
- node tools/check_rules.cjs:15 leaf/2 группы, git diff --check без ошибок (предупреждения LF→CRLF). Без build/Flutter/golden/commit/push. Stage DONE.

### Итерация 34 — 2026-10-26

**Prompt пользователя**

> да давай примеми твои рекомендации. На этом списке можно только удалить участника. А еще слева от кнопки раздачи давай сделаем круглую кнопку с qr, она будет отвечать за показ qr кода для подключения сторонних пользователей. Проверь не протеворечит ли это гайдлайнам

**Уточнение**

> Для участников с устройств

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: статичный HTML UI; R-001/002/004/007 и workflow прочитаны, Flutter/conditional неприменимы. Локальные tokens/styles списка, доступные имена controls, docs, browser desktop/narrow и rules/diff. Без Flutter/build/commit.
- Инициалы вместо тире, Inter18/600 вместо display26, одна общая подпись о персонажах, разделители от текста. Семантический список без переходов в строках, отдельная корзина для удаления. Статичное подтверждение удаления, без удаления реальных данных.
- Круглая нейтральная QR56 слева, отдельная золотая CTA справа с gap16. QR — подключение участников с устройств, не spectator. Статичный preview доступа с явно обозначенным местом QR, без выдуманного URL/протокола и без реализации Participant. Форма добавления не меняется.
- Apple Toolbars: одно primary/trailing, отдельные symbol/text controls с промежутком; Lists/Material — короткие строки и согласованное выравнивание. Это адаптация, не сертификация нативного UI. Проверить переполнение, controls56, anchors, keyboard и неизменность прежней формы.

**Результат и проверки**

- Список ul/li: инициалы48, имя Inter18/600, строки72, divider от текста, одна общая подпись; отдельные корзины56 без действия по всей строке. Корзины открывают общий статичный preview подтверждения, удаление disabled, отмена возвращает состав. Макет не меняет предметные данные. Нейтральный QR56 слева, gap16, золотая CTA56 справа без стрелки.
- QR ведёт на participant-access для участников с устройств; место кода явно помечено как демонстрация, без фиктивного URL/рабочего QR. Это визуальное дополнение по запросу, не реализация Participant. guest-add побайтно на уровне нормализованной строки неизменён. Карта и docs обновлены до47 previews.
- Browser desktop screenshot просмотрен. QR → participant-access → назад; Enter на корзине → guest-remove → отмена — PASS. При фактической ширине317px:4 строки72, Inter18/600, корзины56; QR56×56, CTA150×56, gap16, overflow контента/кнопок/новых previews0, broken refs0. Временный viewport сброшен, вкладка оставлена на составе. Длинные имена/Dynamic Type нативного приложения здесь не тестировались.
- node tools/check_rules.cjs:15 leaf/2 группы; git diff --check без ошибок, предупреждения LF→CRLF. Apple страницы open требуют JS, Markdown fetch не поддержан web-инструментом; использованы индексируемые выдержки официальных HIG Lists/Toolbars/Buttons/Alerts и Material Lists. Без build/Flutter/golden/commit/push. Stage DONE.

### Итерация 35 — 2026-10-26

**Prompt пользователя**

> список кстати стал хуже. Мне не нравятся линии devider и иконка удаления
> пробуем

**Согласованный scope и план**

- Убрать разделители/корзины; «Удалить» раскрывается свайпом влево, на desktop — hover/focus. Сохранить инициалы, шрифт, QR/плюс и форму добавления. Это продолжение37, CODE/NOT_REQUIRED: только визуальная механика без удаления данных/изменения предметного состояния. R-001/002/004/007, router/workflow прочитаны; Flutter/conditional неприменимы.
- HTML/CSS и отдельный небольшой скрипт раскрытия строки: вертикальный scroll не перехватывать, вправо/Escape закрывать, reduced-motion без перехода. Подтверждение удаления остаётся прежним статичным preview. Логика хранения/состава не добавляется.
- Проверить desktop/narrow, hover/focus/Enter/Escape и executable gesture handlers, отсутствие divider/иконок и overflow; docs/rules/diff. Без build/commit.

**Результат и проверки**

- Удалены divider и SVG-корзины из4 строк; появилось скрытое текстовое «Удалить»88×56. Свайп влево/вправо переключает только CSS-класс раскрытия. Desktop hover, keyboard focus и Enter доступны, Escape снимает класс и фокус (hover продолжает действовать при оставшейся мыши). Переход160ms, reduced-motion отключает его. Вертикальный scroll нативный pan-y; данные не удаляются. Остальная композиция и QR/плюс сохранены, docs обновлены.
- Node/vm проверка реального roster-gestures.js: left/right, независимость строк, jitter, вертикальное намерение, pointercancel и Escape — PASS. node --check — PASS. Native touch-жест на устройстве не воспроизводился, это ограничение проверки; hover-правило проверено по CSS, не отдельным browser pointer-input.
- Browser: все4 строки border0/before:none, корзин0, в покое opacity0. Tab после плюса фокусирует «Удалить участника: Иван», раскрытие началось (замер сделан в переходе); Enter открывает guest-remove, отмена возвращает состав. Фактическая ширина317px: строки72, pan-y, overflow0, broken refs0, console errors0. Screenshot спокойного состояния просмотрен; viewport сброшен, вкладка оставлена на составе.
- Rules checker15 leaf/2 группы, git diff --check без ошибок с предупреждениями LF→CRLF. Без Flutter/build/golden/commit/push. Stage DONE.

### Итерация 36 — 2026-10-26

**Prompt пользователя**

> давай при свайпе должна появлятся не кнопка а весь фон на заднем фоне становится цветным

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: только CSS подложки удаления. R-001/002/004/007 и workflow прочитаны; Flutter/conditional неприменимы. Подложка на всю строку через существующую ссылку, без новых данных/механики.
- Убрать отдельную капсулу88×56, растянуть красный задний слой на всю ширину/высоту строки; текст справа. Передний слой покрывает всю высоту, сдвиг88 остаётся, без цветных полос сверху/снизу. Свайп/hover/focus и переход подтверждения не меняются.
- Проверить геометрию closed/revealed, desktop/narrow и Enter; docs/rules/diff. Без build/commit.

**Результат и проверки**

- Задняя ссылка удаления растянута inset0 на всю площадь строки, отдельные размеры/радиус капсулы убраны; надпись справа. Передний слой заполняет высоту72 и сдвигается на88, открывая красный задний фон. Механика жеста не менялась, docs обновлены.
- Browser desktop: все4 задние слои274×72 совпадают со строками, передний слой72, radius0, danger-surface; в раскрытом состоянии opacity1/translateX(-88). Screenshot просмотрен; Enter → подтверждение → отмена работает. При фактической ширине317px подложки также совпадают со строками, overflow0. Viewport сброшен, вкладка оставлена на составе. Сенсорный жест на устройстве не перепроверялся: JS не менялся.
- Rules checker15 leaf/2 группы; git diff --check без ошибок (LF→CRLF warnings). Без Flutter/build/golden/commit/push. Stage DONE.

### Итерация 39 — 2026-10-26

**Prompt пользователя**

> удали подписи снизу и происледуй вообще вопрос показа qr по гайдлайнам: а еще я хочу чтоб qr был округлый

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: статичный SVG/HTML preview. R-001/002/004/007 и workflow прочитаны; Flutter/conditional неприменимы. Убрать адрес/пояснение под QR, сохранить figcaption demo и доступный payload. Скруглить модули/угловые маркеры, не обрезать квадратную матрицу кругом, не менять payload и quiet zone4. Никакой сети/изменения моделей.
- DENSO WAVE margins/generate: quiet zone4, предупреждение об ухудшении чтения при декоре; Google ML Kit input guidelines: достаточно пикселей на модуль в захваченном изображении. Это требования считывания, не Apple-правило о форме экрана. Нельзя обещать совместимость стилизации без проверки; независимый decode288/240/222 и browser desktop/narrow.
- Проверить сохранённый SVG с rounded rect, контраст/поля, отсутствие нижних подписей/overflow; docs/rules/diff. Без build/commit.

**Результат и проверки**

- Адрес/пояснение под QR удалены, инструкция сверху и demo figcaption сохранены. Данные прежние; модули rx0.25, маркеры7/5/3 с rx1/0.65/0.5. SVG geometricPrecision, заполнение токенами ink/background. Матрица остаётся квадратной, quiet zone4 не обрезана. Docs содержат исследование DENSO/ML Kit и ограничения, без вымышленных Apple-предписаний.
- Независимая проверка сохранённых rounded rect: XML→raster32×→Lanczos→ZXing при288/240/222px,0/90 градусов — все6 точных payload PASS; quiet zone4 PASS. Это тестовое растровое представление SVG, не сканирование физической камерой.
- Browser screenshot просмотрен, под QR нет следующего элемента;479 скруглённых SVG-элементов. Фактическая ширина317px: QR222×222, overflow0. Viewport сброшен, вкладка оставлена на participant-access. Физические камеры/свет/расстояния не проверялись.
- Rules checker15 leaf/2 группы, git diff --check без ошибок (LF→CRLF warnings). Без Flutter/build/golden/commit/push. Stage DONE.

### Итерация 37 — 2026-10-26

**Prompt пользователя**

> давай у аватаров уберем обводку

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: убрать border только у аватаров текущего списка гостей, сохранить фон/инициалы/48px, другие экраны не затрагивать. R-001/002/004/007 и workflow прочитаны; Flutter/conditional неприменимы. Общий scoped style, без новых данных/абстракций. Косметика без изменения контракта: docs не требуют отдельного решения по исключению R-002.
- Проверить computed border/размеры всех4 аватаров, browser screenshot, rules/diff. Без build/commit.

**Результат и проверки**

- Scoped border:0 у аватаров списка гостей. Browser: все4 border0, размеры48×48, инициалы сохранены; screenshot просмотрен. Другие аватары не менялись.
- Rules checker15 leaf/2 группы, git diff --check без ошибок (LF→CRLF warnings). Без Flutter/build/golden/commit/push. Stage DONE.

### Итерация 38 — 2026-10-26

**Prompt пользователя**

> давай поиграемся с qr кодом для подключеня.. давай добавим реальный qr с каким нибудь фейк data на localhost/code=###########. QR должен быть контрастным и красивым

**План и правила**

- Продолжение37, CODE/NOT_REQUIRED: заменить placeholder статичным реальным QR fixture в HTML, без runtime-кодирования, сети/подключения или новых зависимостей приложения. R-001/002/004/007, router/workflow прочитаны; Flutter/conditional неприменимы. SVG native asset, существующие цвета/локальные токены, доступное описание и docs ограничения.
- Payload http://localhost/code=48271930615; это путь, не query-параметр. Фейковый адрес по запросу: localhost на телефоне указывает на телефон. Код локально сформировать библиотекой, независимо декодировать, в SVG сохранить квадратные модули, quiet zone4 со всех сторон, без логотипов/градиентов поверх матрицы. Светлая ink-подложка, background-модули, рамка288px адаптивно.
- Временные qrcode/ZXing/Pillow установлены только в TEMP после sandbox network failure/escalation, manifests проекта не меняются. Проверить декодирование, контраст, поля, SVG и browser desktop/narrow; docs/rules/diff. Без build/commit.

**Результат и проверки**

- Placeholder заменён inline SVG QR version4/Q,33×33+quiet zone4=41×41. Payload http://localhost/code=48271930615. Светлый ink-фон/тёмные background-модули, адаптивный блок до288px, существующий radius24; без украшений на матрице. Под кодом адрес и явное demo-ограничение. Docs/карта обновлены, сетевой контракт не добавлен.
- Независимый ZXing-C++ декодировал исходную матрицу и сохранённые SVG-пути после rasterization в памяти при288/240/222px: точный payload, quiet zone4 PASS. Это проверка артефакта, не физической камеры. Временные библиотеки qrcode8.2/ZXing3.1.1/Pillow13 вне проекта; после установки сначала учтено различие sandbox TEMP и пользовательского TEMP. Первый PowerShell one-liner проверки имел ошибку quoting; повторная проверка here-string успешна.
- Browser: фактические цвета rgb244/242/238 и14/16/20; QR288×288 на desktop,222×222 при фактической ширине317px. Overflow0, broken refs0; screenshot полного макета просмотрен, viewport сброшен, вкладка оставлена на participant-access. Контраст цветов около17:1. Сканирование телефоном/реальное подключение не заявляются; localhost указывает на сканирующее устройство.
- Rules checker15 leaf/2 группы; git diff --check без ошибок (LF→CRLF warnings). Без Flutter/build/golden/commit/push. Stage DONE.

### Итерация 40 — 2026-10-27

**Prompt пользователя**

> эталонный qr снзу можем показывать код сессии

**Референс, scope и план**

- Референс пользователя: цельный мягкий QR и код внутри светлой карточки снизу. Продолжение37, CODE/NOT_REQUIRED: HTML/CSS/SVG fixture, без runtime-генерации/сети/логики сессий. R-001/002/004/007, router/workflow прочитаны; Flutter/conditional неприменимы. Палитра/шрифт из tokens, доступный session label, docs и проверки.
- Убрать эффект отдельных бусин: соединённые соседние модули, скруглять только внешние свободные углы. Маркеры/матрица/payload/quiet zone4 сохраняются; не копировать Telegram logo/данные/действия. Под SVG внутри карточки показать 4827 1930 615, то же число48271930615 из URL. Это demo session, ручное подключение не реализуется. Остальные экраны не меняются.
- Проверить сохранённую геометрию через независимое декодирование288/240/222, соответствие подписи payload, browser desktop/narrow/overflow, docs/rules/diff. Без build/commit.

**Результат и проверки**

- По референсу: соединённые модули и мягкие свободные углыrx0.32; один compound path устраняет швы между соседями при SVG antialiasing. Маркеры/quiet zone4/payload сохранены. Светлая карточка radius32, внутри снизу Condensed26/700 «4827 1930 615», доступное имя «Код сессии48271930615». Нет логотипа Telegram или переноса чужих данных. Docs обновлены.
- Сохранённый SVG независимо растеризован и декодирован ZXing при288/240/222px,0/90:6/6 PASS; quiet zone4 и равенство кода сессии числу в URL PASS. Проверка камерой телефона не заявляется.
- Browser screenshot итогового compound-QR просмотрен: один path, подпись верная. На фактической ширине317px карточка222×277, подпись внутри под SVG, overflow подписи/карточки/контента0. Viewport сброшен, вкладка оставлена на participant-access. Session backend/manual join не реализованы.
- Rules/diff checks выполнены; без Flutter/build/golden/commit/push. Stage DONE.

### Итерация 41 — 2026-10-27

**Prompt пользователя**

> переходим к "состав готов", Убираем у аватаров бордер и галочку, а title и subtitle сделаем чуть ближе друг к другу

**Scope, правила и план**

- Продолжение37, CODE/NOT_REQUIRED: distribution-ready, только HTML/CSS. Убрать4 галочки и border аватаров, gap между персонажем и именем участника8→4 через отдельный token; размеры/цвета/состав/CTA сохранить. Остальные экраны не менять. R-001/002/004/007 и workflow прочитаны; Flutter/conditional неприменимы. Scoped styles и token, без предметной логики. Косметика: отдельный docs decision не нужен по исключению R-002.
- Проверить все4 border/gap/check icons, desktop/narrow/overflow, screenshot и rules/diff. Без build/commit.

**Результат и проверки**

- На distribution-ready удалены4 check-accessory, scoped border0 и новый token identity-gap4 вместо8. Имена/персонажи/цвета/64px аватары/CTA сохранены; общие стили других экранов не менялись.
- Browser: все4 border0/gap4, checks0; screenshot просмотрен. На фактической ширине317px все аватары64×64, gap4, overflow0; desktop без overflow. Viewport сброшен, вкладка оставлена на distribution-ready.
- Rules checker15 leaf/2 группы, git diff --check без ошибок (LF→CRLF warnings). Без Flutter/build/golden/commit/push. Stage DONE.

### Итерация 42 — 2026-10-27

**Prompt пользователя**

> добавь сверху справа qr для spectator

**Scope, правила и план**

- Продолжение37, CODE/NOT_REQUIRED: QR-кнопка56 в правой ячейке distribution-ready, отдельный статичный QR spectator с возвратом к готовому составу. Не направлять в participant-access. Payload — прежний демонстрационный http://host.local/spectator, не реальный endpoint; без сети/изменений transport/domain. R-001/002/004/007 и workflow прочитаны; Flutter/conditional неприменимы.
- Использовать существующие orb/QR-card/theme и мягкую геометрию QR, quiet zone4. Соседний preview distribution-share сохраняет корректный back, прежний tournament-share и его вызовы не меняются. На карточке «Только просмотр», не код участников. Docs/карта48 previews, decode и browser desktop/narrow/anchors, rules/diff. Без build/commit.

**Результат и проверки**

- QR56 в правой ячейке заголовка готового состава, aria-label «Показать QR для зрителей». Отдельный distribution-share с реальным статичным SVG на http://host.local/spectator и «Только просмотр»; back к distribution-ready. Переиспользованы существующие CSS/токены. Participant/tournament-share не менялись, сервис не запускается; docs/карта48 previews обновлены.
- Сохранённый зрительский SVG независимо rasterized→ZXing при288/240/222,0/90:6/6 точных payload PASS, quiet zone4 PASS. Browser QR→зрительский preview→back работает; фактическая ширина317: кнопка56×56, overflow0, broken refs0, previews48. Screenshot просмотрен, viewport сброшен, вкладка оставлена на готовом составе. Физическая камера и подключение не проверялись.
- Rules/diff checks выполнены, без Flutter/build/golden/commit/push. Stage DONE.

### Итерация 43 — 2026-10-27 · фиксация изменений

**Prompt пользователя**

> сделай коммит в стиле проекта

**Действия и проверки**

- Фиксация накопленных изменений HTML-прототипа задачи37, без новой реализации. Core rules/router/workflow и карточка перечитаны; Flutter/conditional неприменимы. Статус DONE сохраняется. Последние коммиты используют короткий английский subject с feat:; выбран «feat: refine tournament flow design prototypes».
- В коммит входят документы/история, общие размеры/labels, FT-степперы, заголовки профиля, список со свайпом, QR участников/зрителей и готовый состав, включая новый roster-gestures.js. До фиксации staged changes отсутствовали, посторонних путей в status нет.
- Node structural/syntax check:48 previews, unique IDs, anchors, script resources и синтаксис PASS. Rules checker15 leaf/2 группы, git diff --check без ошибок (LF→CRLF warnings). Browser/QR/gesture evidence сохранено в итерациях выше. Сборки и push не запускаются. Коммит явно разрешён этим запросом пользователя.

### Итерация 44 — 2026-10-27

**Prompt пользователя**

> для экранов 9-12 проведи отдельно иследование по гайдлайнам и как дизайнеры решают проблемы тких экранов и измени их, они сейчас вырывают глаза информацией

**Scope, критерии и план**

- Продолжение37, CODE/NOT_REQUIRED: визуальная переработка16 существующих previews в09/10/11/12, без изменения расчётов/правил/сохранения и без новых production screens. R-001/002/004/007, router/workflow и source MK11 прочитаны; Flutter/conditional неприменимы. Общие scoped-примитивы и токены, смысл моделей не меняется, docs исследования и проверка HTML/browser обязательны.
- Отдельное исследование09: Apple hierarchy/NNG progressive disclosure и Challonge reporting. Текущая пара/счёт/CTA первичны; таблица, очки и редкое управление остаются доступны через понятные disclosure. Идентификация персонаж+имя сохраняется.
- Отдельное исследование10: Apple scroll views/Toornament bracket readability. Уплотнить подписи, сохранить линии и горизонтальный scroll верхней/SE; вторичные ветки DE и правила раскрываются. Будущие участники обозначаются источником, не выдуманными именами. Reset обязателен по условию, SE без матча за3-е.
- Отдельное исследование11: Apple Sheets/Challonge confirmation. Одна пара, score-grid, выбор выражен не только цветом, отмена и единственное сохранение в header; ошибка не стирает выбор, техрезультат без fake2:0, RR technical back исправить на RR. Без интерактивного изменения результатов.
- Отдельное исследование12: Apple Feedback/NNG data tables. Чемпион визуально доминирует, без дублирования hero-заголовков; полный рейтинг всех участников, очки RR и совместные3–4 SE сохранены.
- Проверки AC: все16 ID/переходы сохранены,48 previews, без global изменений вне scope; все игроки с аватаром и именами, основные действия56, редкие данные доступны; desktop и фактическая narrow ширина, overflow, раскрытие details/отмена sheets. Структурные инварианты FT/очки/SE/tie/technical и script syntax, rules/diff, screenshots. Без build/commit/push.

**Результат и проверки итерации 44**

- Отдельное исследование каждого раздела сохранено в docs/design/research-screens-09-12.md с первичными источниками Apple, Challonge, Toornament и рекомендациями NN/G. Изменены16 существующих previews; остальные32 сохранены, всего48. Scoped competition.css и токены не затрагивают другие разделы.
- 09: текущая пара и результат первичны; таблица RR, правила и управление раскрываются. 10: линии и горизонтальная прокрутка сетки сохранены, вторичные ветки DE раскрываются. 11: одна пара, отмена/сохранение в header, редкие действия отдельно; отмена технического RR возвращает в RR. 12: крупный чемпион и полный рейтинг без дублирующего hero. FT, очки3/2/1/0, технические3/0, совместные места3–4 SE, miniRR и условный обязательный Reset сохранены.
- Node structural/syntax checks PASS:48 figures, unique IDs, ссылки, одна пара в каждом sheet, варианты FT1/FT2 и выбранный результат, инварианты правил. Сравнение32 остальных figures с HEAD PASS после нормализации CRLF/LF. Синтаксис inline/roster JS PASS. Rules checker15 leaf/2 группы и git diff --check PASS; только предупреждения LF→CRLF.
- Browser: все16 previews проверены на desktop и фактической узкой ширине317px; горизонтального overflow нет. Score/disclosure controls56px; таблица RR, ветки DE и отмена из ошибки проверены. Скриншоты09/10/11/12 просмотрены, перенос3–4 исправлен, ошибок console нет. Раскрытия после проверки закрыты.
- Ограничения: статичные независимые fixtures, не работающий турнир. Нет реального сохранения/пересчёта, native focus-trap/жестов sheet и usability-теста с пользователями. Переигровка использует общий демонстрационный result-sheet. Без Flutter/build/golden/commit/push. Stage DONE.

### Итерация 45 — 2026-10-27 · фиксация изменений

**Prompt пользователя**

> сделай коммит

**Действия и проверки**

- Явно разрешена фиксация переработки09–12 из итерации44. Новая реализация не добавляется, задача37 остаётся DONE/✅. Core/router/workflow перечитаны; Flutter/conditional неприменимы. В scope только HTML/CSS, исследование, связанные docs и история задачи; staged changes до работы отсутствовали.
- Проверки перед коммитом: node tools/check_rules.cjs —15 leaf/2 группы PASS; Node structural/syntax —48 previews, unique IDs, anchors, inline/roster JS PASS; git diff --check PASS (предупреждения LF→CRLF). Визуальные проверки сохранены в итерации44. Runtime/build не запускаются.
- Стиль последних коммитов: короткий английский subject feat:. Выбран «feat: simplify tournament screens and result flow». Без push.
