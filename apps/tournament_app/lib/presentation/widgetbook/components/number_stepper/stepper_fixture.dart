import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/number_stepper/app_number_stepper.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

enum StepperSample { minimum, intermediate, maximum }

class StepperFixture extends StatefulWidget {
  const StepperFixture({
    this.kind = AppStepperKind.output,
    this.sample = StepperSample.minimum,
    super.key,
  });
  final AppStepperKind kind;
  final StepperSample sample;
  @override
  State<StepperFixture> createState() => _StepperFixtureState();
}

class _StepperFixtureState extends State<StepperFixture> {
  final _controller = TextEditingController();
  late int _value;
  bool _initialized = false;
  int get _min => widget.kind == AppStepperKind.output ? 1 : 0;
  int get _max => widget.kind == AppStepperKind.output ? 10 : 2;
  void _reset() {
    _value = switch (widget.sample) {
      StepperSample.minimum => _min,
      StepperSample.intermediate =>
        widget.kind == AppStepperKind.output ? 5 : 1,
      StepperSample.maximum => _max,
    };
    _controller.text = FoundationLocalizations.of(context)
        .stepperNumber(_value);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _reset();
      _initialized = true;
    }
  }

  @override
  void didUpdateWidget(covariant StepperFixture old) {
    super.didUpdateWidget(old);
    if (old.kind != widget.kind || old.sample != widget.sample) _reset();
  }

  void _decrease() {
    _value--;
    _update();
  }

  void _increase() {
    _value++;
    _update();
  }

  void _update() {
    _controller.text = FoundationLocalizations.of(context)
        .stepperNumber(_value);
    setState(_rebuild);
  }

  void _rebuild() {}
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context),
        label = widget.kind == AppStepperKind.output
            ? l.stepperFormatLabel
            : l.stepperScoreLabel;
    return widget.kind == AppStepperKind.output
        ? AppNumberStepper.output(
            label: label,
            valueLabel: l.stepperFt(_value),
            decreaseLabel: l.stepperDecrease(label),
            increaseLabel: l.stepperIncrease(label),
            onDecrease: _value > _min ? _decrease : null,
            onIncrease: _value < _max ? _increase : null,
          )
        : AppNumberStepper.input(
            label: label,
            controller: _controller,
            decreaseLabel: l.stepperDecrease(label),
            increaseLabel: l.stepperIncrease(label),
            onDecrease: _value > _min ? _decrease : null,
            onIncrease: _value < _max ? _increase : null,
          );
  }
}
