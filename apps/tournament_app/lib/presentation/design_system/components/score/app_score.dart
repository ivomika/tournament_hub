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
    final appearance = AppScoreTheme.of(context, kind);
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: appearance.center,
        children: [
          Text(left, style: appearance.valueStyle),
          if (kind == AppScoreKind.pair) ...[
            SizedBox(width: appearance.gap),
            Text(separator!, style: appearance.separatorStyle),
            SizedBox(width: appearance.gap),
            Text(right!, style: appearance.valueStyle),
          ],
        ],
      ),
    );
  }
}
