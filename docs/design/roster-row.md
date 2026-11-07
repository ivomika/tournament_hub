# Строка участников — AppRosterRow

Source: `prototype/ui-kit.html#c-row`, первые две доски Roster row/Card. Это самостоятельная композиция общих AppSurface → AppIdentity → AppAvatar и AppButton → AppIcon. Assignment/ranking/history не входят в этот контракт.

Mobile: минимальная высота72, inset8×16, Avatar48 круглый, имя Inter18/1.4. Свайп влево открывает справа область88 на полную фактическую высоту строки. Отмена pointer возвращает исходное положение; обратный свайп закрывает. Порог24 и анимация160ms/ease проходят через AppRosterMetrics основной темы. Reduce animations учитывается. Left раскрывает; Right/Escape закрывают и возвращают фокус строке. Скрытая кнопка исключена из focus/pointer/semantics; доступен custom semantics remove intent.

Desktop: минимальная высота208, inset24, Avatar64 с corner22, gap16 до имени Inter22/1.4. Кнопка40×40 постоянно видна справа сверху с inset24. Enter/Space выполняют callback; свайп отсутствует. В hover используются danger roles. Длинные имена увеличивают высоту при необходимости.

`name`/`initials` — presentation data. `onRemove` — nullable intent; widget не удаляет участника и не открывает бизнес-подтверждение. Disabled callback исключает исполнение действия. Текущий main ThemeData/ThemeExtension → AppRosterRowTheme/темы зависимостей → Widget. Primitives доступны только assembly основной темы, AST checker проверяет границу.

Одна команда: `node tools/visual-comparison/compare.mjs roster-row`. Отчёт: `prototype/comparison/roster-row/index.html`. Четыре исходных сценария: Mobile default/revealed и Desktop default/focus. Контрольные узлы: frame, avatar geometry/style, initials, name geometry/typography/baseline, action geometry/style, trash/label. При совпадении shell неверное положение имени всё равно даёт failure: pipeline обнаружил8px ошибку desktop gap и подтвердил исправление по финальному CSS.

Geometry tolerance0.5px учитывает округление дробных строк; baseline1px — оценку browser DOM Range/Canvas. Одна явная разница: `.kit-focus` в HTML-demo рисует3px, тогда как действительный desktop `:focus-visible` исходного прототипа использует2px. Flutter повторяет2px; это отмечено прямо в отчёте, diff остаётся видимым. PASS означает совпадение объявленных контролей, не идентичность каждого raster pixel.

Дополнительные native macOS goldens: mobile/desktop × long/disabled/text-scale1.6 при width240. Scoped Widgetbook использует те же fixtures. Тесты проверяют swipe/reclose/cancel, keyboard/focus, custom semantics action, делегирование/null callback, responsive размеры и реакцию на замену главной темы. Наборы Linux/Windows в этой задаче не создавались.
