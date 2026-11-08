# Линейный волнистый progress

По запросу8 ноября2026 AppProgressIndicator заменён на linear wavy Material3 Expressive. Установленный Flutter SDK содержит только flat LinearProgressIndicator: year2023:false меняет форму стандартного M3, но не добавляет волну. Не создаём проектный sine-wave painter и не объявляем внешний widget штатным SDK.

Допущен m3e_progress_indicator0.0.3 (MIT, pure Flutter), совместимый с текущим SDK. Пакет1.x требует Flutter3.47/material_ui и не используется; SDK не обновляется. Единственный runtime import пакета — owning AppProgressIndicator adapter, library types не выходят в публичный контракт. API/спецификация пакета: https://pub.dev/packages/m3e_progress_indicator/versions/0.0.3.

Исходный Material3 Expressive rendering/motion, track gaps и end stop выполняет пакет. Основная ProgressIndicatorThemeData задаёт color/linearTrackColor. AppProgressMetrics — width240,height10,stroke4,track4,wavelength20,waveSpeed10px/s; gap/stop — AppSpacing.space4. Primitive → AppTheme → typed WidgetTheme → adapter.

При MediaQuery.disableAnimations=true TickerMode выключен, показывается неподвижная волна в presentation-фазе.6; это не60% предметного процесса, semantics сообщает только локализованную загрузку. Смена режима пересоздаёт внутренний visual adapter для немедленного применения. Fixed-phase Widgetbook использует тот же reduced режим.

AppProgressIndicator используется и в Components, и в Foundation/Motion. Native start/mid/reduced/replacement-theme snapshots проверяют реальный component; reduced screenshot повторяется через1секунду и должен оставаться тем же. HTML waveform не является стандартом Material; comparison явно показывает различие высоты24/10 и сохраняет raster diff.
