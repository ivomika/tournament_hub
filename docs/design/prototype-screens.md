# Перенос экранов прототипов

49 состояний mobile/desktop переносятся в25 независимых Stateless screens. Контракт каждого экрана — immutable presentation data и явно переданные callbacks. Экран не вызывает сервисы, не вычисляет турнирные правила, не владеет editable controllers и не выполняет навигацию. Ветвления ограничены отображением переданного состояния и адаптивной компоновкой по runtime теме. Общие composition/layout widgets находятся в DS. Один экран с вариантами — одна атомарная единица и локальный коммит; данные fixtures общие между Widgetbook/golden. Device status/home indicator и галерейные подписи не входят в приложение. Desktop product brand остаётся в шапке.

Прототипный circular/custom progress заменён согласованным Material3 Expressive wave. TextField и Stepper сохраняют ранее согласованную унификацию. QR генерируется по переданным данным. Production routing/controller wiring в этот перенос не входит.
