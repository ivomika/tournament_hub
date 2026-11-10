import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

enum AppNoticeKind { information, operationError, inlineError }

class AppNoticeTheme {
  AppNoticeTheme.of(BuildContext context, AppNoticeKind kind) {
    final runtimeTheme = Theme.of(context);
    error = kind != AppNoticeKind.information;
    color = error
        ? runtimeTheme.colorScheme.error
        : runtimeTheme.colorScheme.onSurfaceVariant;
    style = AppTextStyles(runtimeTheme).caption.copyWith(color: color);
    gap = runtimeTheme.extension<AppSpacing>()!.space8;
    start = runtimeTheme.extension<AppFieldMetrics>()!.start;
    glyph = error ? AppGlyph.alert : AppGlyph.info;
  }
  late final bool error;
  late final Color color;
  late final TextStyle style;
  late final double gap;
  late final CrossAxisAlignment start;
  late final AppGlyph glyph;
}
