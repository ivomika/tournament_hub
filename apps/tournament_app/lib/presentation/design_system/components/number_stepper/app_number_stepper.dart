import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_painter.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_theme.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/number_stepper/app_number_stepper_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

enum AppStepperKind { output, input }

class AppNumberStepper extends StatelessWidget {
  const AppNumberStepper.output({
    required this.label,
    this.showLabel = true,
    required this.valueLabel,
    required this.decreaseLabel,
    required this.increaseLabel,
    required this.onDecrease,
    required this.onIncrease,
    super.key,
  }) : kind = AppStepperKind.output,
       controller = null,
       onChanged = null,
       onSubmitted = null;
  const AppNumberStepper.input({
    required this.label,
    this.showLabel = true,
    required this.controller,
    required this.decreaseLabel,
    required this.increaseLabel,
    required this.onDecrease,
    required this.onIncrease,
    this.onChanged,
    this.onSubmitted,
    super.key,
  }) : kind = AppStepperKind.input,
       valueLabel = null;
  final AppStepperKind kind;
  final String label, decreaseLabel, increaseLabel;
  final bool showLabel;
  final String? valueLabel;
  final TextEditingController? controller;
  final VoidCallback? onDecrease, onIncrease;
  final ValueChanged<String>? onChanged, onSubmitted;
  @override
  Widget build(BuildContext context) {
    if (!showLabel) {
      return _StepperBody(spec: this);
    }
    final appearance = AppNumberStepperTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth <= appearance.labelStackWidth
          ? SizedBox(
              width: appearance.fullWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: appearance.start,
                children: [
                  Text(label, style: appearance.labelStyle),
                  SizedBox(height: appearance.smallGap),
                  _StepperBody(spec: this),
                ],
              ),
            )
          : Row(
              mainAxisAlignment: appearance.spaceBetween,
              children: [
                Flexible(child: Text(label, style: appearance.labelStyle)),
                SizedBox(width: appearance.gap),
                _StepperBody(spec: this),
              ],
            ),
    );
  }
}

class _StepperBody extends StatelessWidget {
  const _StepperBody({required this.spec});
  final AppNumberStepper spec;
  @override
  Widget build(BuildContext context) {
    final appearance = AppNumberStepperTheme.of(context);
    return Align(
      alignment: appearance.center,
      widthFactor: appearance.contentHeightFactor,
      heightFactor: appearance.contentHeightFactor,
      child: Semantics(
        label: spec.label,
        container: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: appearance.background,
            borderRadius: appearance.radius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepperAction(
                glyph: AppGlyph.minus,
                label: spec.decreaseLabel,
                onPressed: spec.onDecrease,
                fadeDisabled: spec.kind == AppStepperKind.output,
              ),
              SizedBox(
                width: spec.kind == AppStepperKind.output
                    ? appearance.outputExtent(context, spec.valueLabel!)
                    : appearance.inputWidth,
                child: spec.kind == AppStepperKind.output
                    ? Center(
                        heightFactor: appearance.contentHeightFactor,
                        child: Text(
                          spec.valueLabel!,
                          style: appearance.valueStyle,
                          softWrap: false,
                          maxLines: appearance.singleLine,
                        ),
                      )
                    : Semantics(
                        label: spec.label,
                        child: TextField(
                          controller: spec.controller,
                          onChanged: spec.onChanged,
                          onSubmitted: spec.onSubmitted,
                          style: appearance.valueStyle,
                          textAlign: appearance.textAlign,
                          maxLines: appearance.singleLine,
                          cursorColor: appearance.foreground,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
              ),
              _StepperAction(
                glyph: AppGlyph.plus,
                label: spec.increaseLabel,
                onPressed: spec.onIncrease,
                fadeDisabled: spec.kind == AppStepperKind.output,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperAction extends StatefulWidget {
  const _StepperAction({
    required this.glyph,
    required this.label,
    required this.onPressed,
    required this.fadeDisabled,
  });
  final AppGlyph glyph;
  final String label;
  final VoidCallback? onPressed;
  final bool fadeDisabled;
  @override
  State<_StepperAction> createState() => _StepperActionState();
}

class _StepperActionState extends State<_StepperAction> {
  final _focus = FocusNode();
  @override
  void initState() {
    super.initState();
    _focus.addListener(_changed);
  }

  void _changed() {
    setState(_rebuild);
  }

  void _rebuild() {}
  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  Color _background(Set<WidgetState> states) {
    final appearance = AppNumberStepperTheme.of(context);
    return states.contains(WidgetState.hovered) && widget.onPressed != null
        ? appearance.hoverBackground
        : appearance.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final appearance = AppNumberStepperTheme.of(context),
        disabled = widget.onPressed == null && widget.fadeDisabled;
    return CustomPaint(
      foregroundPainter: _focus.hasFocus
          ? AppFocusRingPainter(
              AppFocusRingTheme(
                color: appearance.focusColor,
                width: appearance.focusWidth,
                offset: appearance.focusOffset,
                radius: null,
                capsule: true,
                half: appearance.half,
              ),
            )
          : null,
      child: Opacity(
        opacity: disabled
            ? appearance.disabledOpacity
            : appearance.enabledOpacity,
        child: SizedBox.square(
          dimension: appearance.height,
          child: IconButton(
            focusNode: _focus,
            onPressed: widget.onPressed,
            tooltip: widget.label,
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(appearance.padding),
              fixedSize: WidgetStatePropertyAll(appearance.buttonSize),
              minimumSize: WidgetStatePropertyAll(appearance.buttonSize),
              maximumSize: WidgetStatePropertyAll(appearance.buttonSize),
              shape: WidgetStatePropertyAll(appearance.buttonShape),
              backgroundColor: WidgetStateProperty.resolveWith(_background),
              overlayColor: WidgetStatePropertyAll(appearance.transparent),
            ),
            icon: AppIcon(
              widget.glyph,
              color: disabled ? appearance.disabled : appearance.foreground,
            ),
          ),
        ),
      ),
    );
  }
}
