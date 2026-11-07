import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/score_choice/app_score_choice.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

enum ScoreChoiceValue { left, right }

class ScoreChoiceFixture extends StatefulWidget {
  const ScoreChoiceFixture({
    this.selected = ScoreChoiceValue.left,
    this.disabled = false,
    super.key,
  });
  final ScoreChoiceValue selected;
  final bool disabled;
  @override
  State<ScoreChoiceFixture> createState() => _ScoreChoiceFixtureState();
}

class _ScoreChoiceFixtureState extends State<ScoreChoiceFixture> {
  late ScoreChoiceValue _value = widget.selected;
  @override
  void didUpdateWidget(covariant ScoreChoiceFixture old) {
    super.didUpdateWidget(old);
    if (old.selected != widget.selected) _value = widget.selected;
  }

  void _choose(ScoreChoiceValue value) {
    _value = value;
    setState(_rebuild);
  }

  void _rebuild() {}
  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context);
    return AppScoreChoice<ScoreChoiceValue>(
      label: l.scoreChoiceLabel,
      value: _value,
      onChanged: widget.disabled ? null : _choose,
      options: [
        AppScoreOption(value: ScoreChoiceValue.left, label: l.scoreChoiceLeft),
        AppScoreOption(
          value: ScoreChoiceValue.right,
          label: l.scoreChoiceRight,
        ),
      ],
    );
  }
}
