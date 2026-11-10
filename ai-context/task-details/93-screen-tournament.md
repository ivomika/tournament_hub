# 93. Проведение турнира

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

Итог: DE/SE/RR/tiebreak: 8 native viewport goldens; 11 screen/button/avatar tests passed; analyzer clean. Round label and desktop side panels visually corrected against source. No push.

2026-11-10. Prompt пользователя (дословно): «разблокировал». После разблокировки визуально подтвержден overflow76 в текущем матче при коротком Desktop-окне Widgetbook. Plan: сохранить центрирование при достаточной высоте, добавить прокрутку внутреннего содержимого при недостаточной высоте; regression800×500 для всех форматов; native goldens и визуальная проверка окна. TestGate NOT_REQUIRED: только layout, контракт данных/callbacks неизменен.

Итог 2026-11-10: центрированное содержимое карточки матча прокручивается при недостаточной высоте. До изменения тест800×500 воспроизводил overflow117; после — все четыре формата доступны без overflow, счёт достигается ensureVisible. 5 screen tests passed, существующие 8 PNG неизменны. Targeted actual Widgetbook Mobile/Desktop audit1.6: 2 passed; analyzer clean, architecture533 files passed. Выполнены native debug build и hot restart. В свежем окне визуально подтверждены отсутствие overflow и доступность счёта прокруткой, Mobile390×844 без дефекта. Из-за коллизии bundle id оконная проверка выполнена во временной копии сборки /tmp/TournamentHubWidgetbookReview.app с отдельным идентификатором; production macOS config не изменён. No push.
