import 'package:flutter/material.dart';
import 'package:m3e_progress_indicator/m3e_progress_indicator.dart';
import 'package:tournament_app/presentation/design_system/components/progress_indicator/app_progress_indicator_theme.dart';

/// Presentation adapter to M3 Expressive; no package types in the public API.
class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({required this.semanticLabel, super.key});
  final String semanticLabel;
  @override
  Widget build(BuildContext context) {
    final appearance = AppProgressIndicatorTheme.of(context);
    final reduced = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          width: appearance.metrics.width,
          height: appearance.metrics.height,
          child: TickerMode(
            enabled: !reduced,
            child: M3ELinearWavyProgressIndicator(
              key: ValueKey(reduced),
              value: reduced ? appearance.metrics.staticValue : null,
              width: appearance.metrics.width,
              height: appearance.metrics.height,
              gapSize: appearance.gap,
              stopSize: appearance.gap,
              color: appearance.color,
              backgroundColor: appearance.track,
              strokeWidth: appearance.metrics.strokeWidth,
              trackStrokeWidth: appearance.metrics.trackStrokeWidth,
              wavelength: appearance.metrics.wavelength,
              waveSpeed: appearance.metrics.waveSpeed,
            ),
          ),
        ),
      ),
    );
  }
}
