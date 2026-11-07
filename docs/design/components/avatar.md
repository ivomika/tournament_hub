# Avatar

AppAvatar — самостоятельное отображение переданных инициалов. Размеры28/40/48/64/96/112/128 задаются AppAvatarSize; формы tile/round — AppAvatarShape. Размер не изменяется при переходе между mobile/desktop. Border отсутствует. Цвет можно передать как runtime presentation data из текущей темы; отдельные классы для персонажей не создаются.

AppAvatarTheme.of(context,size,shape) получает extent из AppResponsive, font/radius/alignment/leading из AppAvatarMetrics, типографическую основу из текущей TextTheme.headlineLarge, фон из surfaceContainerHigh; tile foreground — onSurfaceVariant, round — primary. Это соответствует измеренному текущему UI kit. Никаких primitive imports или raw Colors/TextStyle/числовых style literals внутри компонента нет.

Все исходные размеры представлены отдельными Widgetbook use cases с двумя формами. Дополнительный use case показывает пустые/двухбуквенные инициалы и themed foreground data. Общая AvatarFixture используется Widgetbook и visual tests. Инициалы сами не вычисляются, валидации имени нет; image/loading/disabled/hover API в исходнике отсутствуют и не добавлялись. Имя/подпись рядом относятся к Identity/другим композициям, без временных заглушек.

По умолчанию Avatar декоративный, как aria-hidden в web. При необходимости потребитель передаёт локализованный semanticsLabel. Компонент не интерактивен.

[Отчёт web ↔ Flutter](../prototype/comparison/avatar/index.html) содержит28 пар, overlay/diff, точные измерения и intentional text-shift control.24/28 integer glyph bounds совпадают;112px имеет1px raster edge difference при baseline delta0.171875px. Остаток явно виден в отчёте. [Harness и воспроизведение](../../../tools/visual-comparison/README.md).
