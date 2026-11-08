# 79. Главная

## Статус
✅ Stage DONE; Mode CODE; TestGate NOT_REQUIRED: только декларативная композиция, состояние/данные и callbacks передаются снаружи, app logic отсутствует.

## Контракт и plan
Сверить соответствующие состояния index.html/desktop.html → immutable typed presentation contract → Stateless screen и runtime layout theme → общие fixtures, scoped Widgetbook → Mobile/Desktop native goldens, визуальная сверка и analyzer/architecture → отдельный local commit без push. Никаких router/services/usecases/controllers внутри экрана; editable controllers принадлежат caller. Геометрия/theme следует foundation; DS переиспользуется. Один экран — одна папка/единица, варианты остаются его сценариями.

## Применимые правила
Прочитаны core R-001/002/004/007; все обязательные Flutter R-003.a–g/R-005/R-006.a–d; router conditional scan: иных rules нет. Workflow visual NOT_REQUIRED. Оформление через runtime темы, intl, именованные callbacks, отсутствие Widget helpers. Shared screen frame — DS layout, не альтернативная реализация элементов.

## Acceptance
- [x] Плоский независимый экран, только переданное состояние/данные, callbacks.
- [x] Mobile/Desktop композиция исходных прототипов, scoped previews/goldens.
- [x] Проверки выполнены, отдельный коммит без push.

## Changelog
Prompt пользователя (дословно):
> отлично теперь собери экраны из прототипов. Экраны должны быть независимы и отображать только переданное состояние и данные, никакой логику внутри экранов. Они должны быть плоскими и повторять прототипы. Каждый экран атомарная еденица. Каждый экран сопровождается коммитом без пуш

Scope refinement: актуальный Home использует собственную home-bento-grid, не старый desktop-grid. Переносится непосредственно его иерархия. Недостающие shared DS presentation slots: StageProgress (только переданные boolean highlights) и leading glyph Button; ни расчётов стадии, ни доменных действий. Родные шрифты в штатном сервере подтверждены HTTP200; предыдущие screenshots с fallback заменены.

Итог: независимый Home empty/active, собственный desktop bento hierarchy и mobile card. Внешние immutable name/format/count/stage/highlights; navigation intents callbacks, без controllers/domain. Native4 PNG; Home2+Button4+Stage1 tests PASS без update; analyzer no issues. Source и native просмотрены после исправления font server. Leading Button variant сохраняет старые goldens; StageProgress имеет собственные golden/Widgetbook. No push.
