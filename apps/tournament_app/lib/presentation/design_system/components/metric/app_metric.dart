import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/metric/app_metric_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
export 'package:tournament_app/presentation/design_system/components/metric/app_metric_theme.dart'
    show AppMetricKind;

class AppMetric extends StatelessWidget {
  const AppMetric({
    required this.value,
    required this.label,
    required this.semanticLabel,
    this.kind = AppMetricKind.plain,
    this.glyph = AppGlyph.trophy,
    super.key,
  });
  final String value, label, semanticLabel;
  final AppMetricKind kind;
  final AppGlyph glyph;
  @override
  Widget build(BuildContext context) {
    final t = AppMetricTheme.of(context, kind);
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(color: t.background, borderRadius: t.radius),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: t.minHeight,
            minWidth: t.fullWidth,
          ),
          child: Padding(
            padding: t.padding,
            child: t.achievement
                ? Row(
                    children: [
                      if (!t.desktop) ...[
                        _MetricIcon(theme: t, glyph: glyph),
                        SizedBox(width: t.gap),
                      ],
                      Expanded(
                        child: _MetricText(
                          theme: t,
                          value: value,
                          label: label,
                        ),
                      ),
                      if (t.desktop) ...[
                        SizedBox(width: t.gap),
                        _MetricIcon(theme: t, glyph: glyph),
                      ],
                    ],
                  )
                : _MetricText(theme: t, value: value, label: label),
          ),
        ),
      ),
    );
  }
}

class _MetricIcon extends StatelessWidget {
  const _MetricIcon({required this.theme, required this.glyph});
  final AppMetricTheme theme;
  final AppGlyph glyph;
  @override
  Widget build(BuildContext context) => Opacity(
    opacity: theme.iconOpacity,
    child: AppIcon(glyph, size: AppIconSize.hero, color: theme.foreground),
  );
}

class _MetricText extends StatelessWidget {
  const _MetricText({
    required this.theme,
    required this.value,
    required this.label,
  });
  final AppMetricTheme theme;
  final String value, label;
  @override
  Widget build(BuildContext context) {
    final t = theme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: t.desktop || t.achievement ? t.start : t.stretch,
      mainAxisAlignment: t.desktop && !t.achievement ? t.between : t.center,
      children: [
        Text(value, style: t.valueStyle, textAlign: t.textAlign),
        SizedBox(height: t.contentGap),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: t.desktop && t.achievement
                ? t.maxLabelWidth
                : t.unrestrictedWidth,
          ),
          child: Text(label, style: t.labelStyle, textAlign: t.textAlign),
        ),
      ],
    );
  }
}
