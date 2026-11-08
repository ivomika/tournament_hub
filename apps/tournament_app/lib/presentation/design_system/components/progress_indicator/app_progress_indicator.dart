import 'package:flutter/material.dart';
import 'package:m3e_progress_indicator/m3e_progress_indicator.dart';
import 'package:tournament_app/presentation/design_system/components/progress_indicator/app_progress_indicator_theme.dart';

/// Presentation adapter to M3 Expressive; no package types in the public API.
class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({required this.semanticLabel, super.key});
  final String semanticLabel;
  @override
  Widget build(BuildContext context) {
    final t = AppProgressIndicatorTheme.of(context);
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          width: t.metrics.width,
          height: t.metrics.height,
          child: TickerMode(
            enabled: !reduced,
            child: M3ELinearWavyProgressIndicator(
              key: ValueKey(reduced),
              value: reduced ? t.metrics.staticValue : null,
              width: t.metrics.width,
              height: t.metrics.height,
              gapSize: t.gap,
              stopSize: t.gap,
              color: t.color,
              backgroundColor: t.track,
              strokeWidth: t.metrics.strokeWidth,
              trackStrokeWidth: t.metrics.trackStrokeWidth,
              wavelength: t.metrics.wavelength,
              waveSpeed: t.metrics.waveSpeed,
            ),
          ),
        ),
      ),
    );
  }
}
