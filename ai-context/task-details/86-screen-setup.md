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

2026-11-10. Уточнение пользователя (дословно):
1) match result - растягивается stepper при этом контент степера прижат к левому краю, ограничь его чтобы он не растягивался
2) distribution working должно быть не состоянием экрана, это отдельный utility экран который уже есть.
3) у выбора формата не видно контейнера
4) home - empty не соответсвует прототипу на desktop кнопка слишком прижата, иконка слишком маленькая
5) на bootstrap кнопка должна быть прижата к нижнему краю контейнера
6) Техническое поажение не влазиет
7) на просмотре сетки есть отступы по краям всего экрана, а для фона и сетки его не должно быть, этот отступ должен быть только для кнопок
8) Странный hover эффект при наведении на последний турнир в профиле, а так же надпись "Место" рядом с цифрой смотриться странно, не уверен что она должна быть такой точно так же на desktop
9) на мобильом варианте кнопка на bootstrap тоже должна быть снизу
10) на экране loading должно быть все прижато к левому краю
Plan: исправить относящиеся к экрану пункты, сохранить theme/state contracts; native Mobile/Desktop goldens, actual Widgetbook normal/1.6, визуальная сверка. TestGate NOT_REQUIRED: layout, visual states/composition only.

Итог уточнения: контрастный контейнер выбора формата и рост панели при увеличении текста. Проверки: 63 screen/DS tests passed, 6 actual Widgetbook bootstrap tests passed, Mobile/Desktop/Short Desktop matrix normal/1.6 passed; analyzer clean; architecture-check passed. Нативные снимки изменённого оформления сверены. No push.
