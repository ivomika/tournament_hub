# 86. Настройка турнира

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

Итог: Setup DE/SE/RR: внешний nameController, typed selected format, готовые подписи/controls/notice и callbacks. Не вычисляет FT, ограничения или переходы.6 native PNG,3 tests PASS без update, analyzer no issues. Source/native просмотрены; отдельные FT-плитки и группы format header/title восстановлены. No push.

Аудит реального Widgetbook: подтверждено переполнение при textScale1.6 (Setup: рабочая область свободного viewport). Исправление ограничений/прокрутки, без изменения presentation-контракта или бизнес-логики. Повторить native goldens и реальный viewport audit.

Уточнение пользователя (дословно): «продолжи».
Исправление: Desktop controls scroll within their bounded pane at narrower actual workbench width. Проверки: 12 targeted native tests, 152 full DS/screens/real Widgetbook tests, all-screen Mobile/Desktop audit textScale1.6 passed; analyzer clean. No push.
