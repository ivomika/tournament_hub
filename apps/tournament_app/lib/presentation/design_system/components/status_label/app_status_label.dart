import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/status_label/app_status_label_theme.dart';
export 'package:tournament_app/presentation/design_system/components/status_label/app_status_label_theme.dart'
    show AppStatusKind, AppStatusTone;

class AppStatusLabel extends StatelessWidget {
  const AppStatusLabel({
    required this.text,
    this.textAlign,
    this.kind = AppStatusKind.live,
    this.tone = AppStatusTone.accent,
    super.key,
  });
  final String text;
  final TextAlign? textAlign;
  final AppStatusKind kind;
  final AppStatusTone tone;
  @override
  Widget build(BuildContext context) {
    final t = AppStatusLabelTheme.of(context, kind, tone);
    return kind == AppStatusKind.live
        ? SizedBox(
            width: t.fullWidth,
            child: Row(
              children: [
                SizedBox.square(
                  dimension: t.dot,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: t.color,
                      borderRadius: t.radius,
                    ),
                  ),
                ),
                SizedBox(width: t.gap),
                Flexible(child: Text(text, style: t.style)),
              ],
            ),
          )
        : Text(
            text,
            style: t.style,
            textAlign: textAlign,
            textHeightBehavior: t.heightBehavior,
          );
  }
}
