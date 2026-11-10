# 88. Подключение участников

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

Итог: ParticipantAccess: только переданные QR payload и display code, без создания/подключения сессии. Генерация остаётся в существующем AppQrCode. Mobile vertical composition/Desktop intro+QR panes,2 native PNG,1 test PASS без update; source/native просмотрены. Headline цельный, scanner hint следует финальным CSS overrides. No push.

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
Дополнительная проверка короткого Desktop800×500 выявила overflow в этом экране. Plan: общий desktop canvas с прокруткой минимального themed content extent, без изменения normal1440×900/mobile и без app logic; повторить native goldens и viewport audit. TestGate NOT_REQUIRED: responsive layout only.

Итог уточнения: короткий desktop прокручивает содержимое без overflow. Проверки: 63 screen/DS tests passed, 6 actual Widgetbook bootstrap tests passed, Mobile/Desktop/Short Desktop matrix normal/1.6 passed; analyzer clean; architecture-check passed. Нативные снимки изменённого оформления сверены. No push.
