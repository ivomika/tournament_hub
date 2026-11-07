import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/score/app_score.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

enum ScoreSample { initial, result, twoDigits }

class ScoreFixture extends StatelessWidget {
  const ScoreFixture({
    this.kind = AppScoreKind.pair,
    this.sample = ScoreSample.initial,
    super.key,
  });
  final AppScoreKind kind;
  final ScoreSample sample;
  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context);
    final left = switch (sample) {
          ScoreSample.initial => '0',
          ScoreSample.result => '2',
          ScoreSample.twoDigits => '10',
        },
        right = switch (sample) {
          ScoreSample.initial => '0',
          ScoreSample.result => '1',
          ScoreSample.twoDigits => '8',
        };
    return kind == AppScoreKind.pair
        ? AppScore.pair(
            left: left,
            right: right,
            separator: l.scoreSeparator,
            semanticLabel: l.scorePairLabel(left, right),
          )
        : AppScore.fixed(left: left, semanticLabel: l.scoreFixedLabel(left));
  }
}
