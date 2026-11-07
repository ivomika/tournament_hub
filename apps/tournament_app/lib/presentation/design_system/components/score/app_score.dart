import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/score/app_score_theme.dart';
export 'package:tournament_app/presentation/design_system/components/score/app_score_theme.dart'
    show AppScoreKind;

class AppScore extends StatelessWidget {
  const AppScore.pair({
    required this.left,
    required this.right,
    required this.semanticLabel,
    required this.separator,
    super.key,
  }) : kind = AppScoreKind.pair;
  const AppScore.fixed({
    required this.left,
    required this.semanticLabel,
    super.key,
  }) : kind = AppScoreKind.fixed,
       right = null,
       separator = null;
  final AppScoreKind kind;
  final String left, semanticLabel;
  final String? right, separator;
  @override
  Widget build(BuildContext context) {
    final t = AppScoreTheme.of(context, kind);
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: t.center,
        children: [
          Text(left, style: t.valueStyle),
          if (kind == AppScoreKind.pair) ...[
            SizedBox(width: t.gap),
            Text(separator!, style: t.separatorStyle),
            SizedBox(width: t.gap),
            Text(right!, style: t.valueStyle),
          ],
        ],
      ),
    );
  }
}
