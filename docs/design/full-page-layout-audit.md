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

### P2 — desktop connection/open composition имеет большой QR-dependent rail

`Host Open` занимает 1548 px на desktop и 2462 px на mobile: roster и connection card последовательно видимы, но QR/address block становится длинным самостоятельным потоком. Это допустимо для scanner-first сценария, однако требует отдельной проверки при реальном адресе и разных размерах QR.

- [Host Open desktop](../../apps/tournament_app/test/goldens/full_page/host_open_desktop.png)
- [Host Open mobile](../../apps/tournament_app/test/goldens/full_page/host_open_mobile.png)

Рекомендация: сохранять QR и ручной адрес в одном interaction region, а не сокращать readable address ради высоты.

### P2 — короткие desktop screens визуально корректны, но full-page не должен маскировать canvas whitespace

`Bootstrap`, `Registration`, `Profile`, `Settings`, `Recoverable Error`, `Host Draft`, `Host Result Entry` и другие короткие desktop screens имеют высоту viewport либо близкую к ней. Это полезный сигнал: отсутствие scroll не означает, что canvas обязан заполняться декоративными карточками. Проблему пустоты следует решать только при наличии конкурирующего supporting content.

## Проверенные инварианты

- Full-page capture не дублирует fixed `ActionDock` или navigation внутри scrollable content.
- Все 20 screen previews имеют mobile и desktop full-page goldens.
- Обычная 40-case viewport golden matrix остаётся зелёной.
- `Structure` остаётся единым operational list на всех width/format; audit не возвращает graph/list branching.
- Typography и runtime font fallback в этот аудит не входили.

## Следующие задачи

1. Прототипировать flow/sticky strategy для длинных desktop supporting rails.
2. Добавить jump-to-current/progressive disclosure для длинных mobile tournament histories.
3. Отдельно проверить Host Open QR/address при реальном LAN URI и physical TV/mobile capture.
