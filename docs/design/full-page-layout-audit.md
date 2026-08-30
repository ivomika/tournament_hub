# Full-page layout audit

Дата: 2026-08-30  
Источник: [TH-20260830-081](../../ai-context/tasks/TH-20260830-081.md)  
Объём: 20 Flutter screen previews × mobile/desktop; typography сознательно не оценивалась.

## Методика

`test/full_page_golden_test.dart` сначала рендерит экран в стандартном viewport, измеряет scrollable subtree и fixed region, затем повторно строит тот же экран на высоте полного контента. Получается один PNG от верхнего заголовка до последнего блока. Обычные viewport goldens продолжают проверять fold, fixed actions и navigation.

Полный набор находится в `apps/tournament_app/test/goldens/full_page/` и содержит 40 файлов. На коротких экранах высота остаётся viewport-limited; на длинных экранах capture показывает реальный scroll extent.

## Наблюдения

### P1 — desktop split/workspace оставляет пустой dominant-столбец

На `Host Running`, `Host Finished` и `History Detail` правый supporting rail значительно длиннее левой primary region. После завершения champion/current блока левая колонка остаётся пустой, пока справа продолжаются match/standing cards. Это не overflow, но нарушает композиционную связность и увеличивает визуальный путь до нижних данных.

- [Host Running desktop](../../apps/tournament_app/test/goldens/full_page/host_running_desktop.png) — primary заканчивается около первого экрана, supporting rail продолжается до 4264 px.
- [Host Finished desktop](../../apps/tournament_app/test/goldens/full_page/host_finished_desktop.png) — champion hero заканчивается существенно раньше ranking/structure rail (4504 px всего).
- [History Detail desktop](../../apps/tournament_app/test/goldens/full_page/history_detail_desktop.png) — snapshot header короткий, match history занимает весь scroll (4452 px).

Рекомендация: в отдельной задаче проверить sticky/flow composition для supporting rail или перевод части длинного rail в full-width continuation после dominant блока. Не растягивать primary card декоративной высотой.

### P1 — mobile tournament screens образуют очень длинные последовательные stacks

`Host Running` (6014 px), `Host Finished` (6786 px) и `History Detail` (6058 px) требуют большого числа экранов прокрутки. Контент не теряется и fixed dock не перекрывает последний блок, но current/next information быстро уходит выше fold.

- [Host Running mobile](../../apps/tournament_app/test/goldens/full_page/host_running_mobile.png)
- [Host Finished mobile](../../apps/tournament_app/test/goldens/full_page/host_finished_mobile.png)
- [History Detail mobile](../../apps/tournament_app/test/goldens/full_page/history_detail_mobile.png)

Рекомендация: следующей задачей проверить progressive disclosure для завершённых матчей и быстрый jump-to-current; не уменьшать touch targets и не скрывать identity.

### P2 — desktop connection/open composition имела большой QR-dependent rail

`Host Open` занимает 1548 px на desktop и 2462 px на mobile: roster и connection card последовательно видимы, но QR/address block становится длинным самостоятельным потоком. Это допустимо для scanner-first сценария, однако требует отдельной проверки при реальном адресе и разных размерах QR.

- [Host Open desktop](../../apps/tournament_app/test/goldens/full_page/host_open_desktop.png)
- [Host Open mobile](../../apps/tournament_app/test/goldens/full_page/host_open_mobile.png)

Рекомендация: сохранять QR и ручной адрес в одном interaction region, а не сокращать readable address ради высоты. В TH-20260830-082 QR-card оставлена самостоятельным верхним блоком, а connection summary и stage вынесены в full-width continuation: roster больше не соседствует с длинным пустым столбцом.

### P2 — page-level `AdaptiveSplit` скрывал общую модель композиции

`Registration`, `Join` и `Participant Lobby` визуально оставались сбалансированными, но собирали весь экран через локальный `AdaptiveSplit`. Это создавало второй неявный page-layout contract рядом с `PageLayout` и делало дальнейшую адаптацию экранов несогласованной.

В TH-20260830-082 эти экраны переведены на `PageLayout.workspace` или `PageLayout.flow`. `AdaptiveSplit` остаётся допустимым только внутри самостоятельного компонента, но не как каркас screen preview.

### P2 — короткие desktop screens визуально корректны, но full-page не должен маскировать canvas whitespace

`Bootstrap`, `Registration`, `Profile`, `Settings`, `Recoverable Error`, `Host Draft`, `Host Result Entry` и другие короткие desktop screens имеют высоту viewport либо близкую к ней. Это полезный сигнал: отсутствие scroll не означает, что canvas обязан заполняться декоративными карточками. Проблему пустоты следует решать только при наличии конкурирующего supporting content.

## Проверенные инварианты

- Full-page capture не дублирует fixed `ActionDock` или navigation внутри scrollable content.
- Все 20 screen previews имеют mobile и desktop full-page goldens.
- Обычная 40-case viewport golden matrix остаётся зелёной.
- `Structure` остаётся единым operational list на всех width/format; audit не возвращает graph/list branching.
- Typography и runtime font fallback в этот аудит не входили.

## Следующие задачи

1. Реализовано в TH-20260830-082: `flow` переносит длинный operational stream на всю ширину после короткой верхней hybrid-композиции.
2. Реализовано в TH-20260830-082: contextual jump использует существующий `ActionDock`, а completed disclosure сохраняет последние три матча.
3. Отдельно проверить Host Open QR/address при реальном LAN URI и physical TV/mobile capture.

## Повторная проверка после TH-20260830-082

- `Host Running`, `Host Finished` и `History Detail` больше не оставляют длинный пустой dominant-столбец: Structure/standings продолжаются на полную ширину desktop content area.
- `Host Open` использует короткую верхнюю пару roster/QR и full-width continuation для connection summary и stage; QR и ручной адрес остаются одной interaction region.
- `Host Running` возвращает current match одним contextual action из существующего fixed dock; новая панель поверх контента не добавлена.
- Terminal screens начинают поток с winner/result snapshot и не используют sticky current context.
- Participant Lobby/Running/Finished используют тот же `PageLayout.flow`, что соответствующие Host states, но не получают Host mutation actions.
- `Registration` и `Join` используют `PageLayout.workspace`; screen-level `AdaptiveSplit` во Flutter previews больше не осталось.
- Mobile full-page остаётся длинным как полная техническая история, но текущий Host-контекст доступен без ручного возврата наверх; старые completed matches имеют единый disclosure contract.
- `Host Distribution`, `History`, `Settings` и `Host Cancelled` сохраняют split/archive-композицию: соседние блоки сопоставимы по высоте и не создают пустой rail. `Main`, `Host Draft`, `Host Result Entry`, `Profile`, `Bootstrap` и recoverable states остаются компактными однонаправленными потоками без декоративного заполнения canvas.
- Обновлённые viewport и full-page goldens остаются отдельными regression artifacts.

## Уточнение desktop content frame после TH-20260830-083

На viewport шире `contentMaxWidth` header раньше продолжал занимать весь canvas, хотя body уже был ограничен. Из-за этого actions визуально отрывались вправо от последнего столбца content. Теперь `PageHeader` и body используют общий левый-aligned `AppShell` content frame: правый край toolbar совпадает с правым краем основной композиции. Отдельный `Host Open` wide-desktop golden 1800×1000 фиксирует поведение за пределами стандартного desktop viewport.
