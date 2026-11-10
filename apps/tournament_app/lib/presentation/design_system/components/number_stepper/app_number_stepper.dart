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
    final t = AppNumberStepperTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) =>
          constraints.maxWidth <= t.labelStackWidth
          ? SizedBox(
              width: t.fullWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: t.start,
                children: [
                  Text(label, style: t.labelStyle),
                  SizedBox(height: t.smallGap),
                  _StepperBody(spec: this),
                ],
              ),
            )
          : Row(
              mainAxisAlignment: t.spaceBetween,
              children: [
                Flexible(child: Text(label, style: t.labelStyle)),
                SizedBox(width: t.gap),
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
    final t = AppNumberStepperTheme.of(context);
    return Align(
      alignment: t.center,
      widthFactor: t.contentHeightFactor,
      heightFactor:t.contentHeightFactor,
      child: Semantics(
        label: spec.label,
        container: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: t.background,
            borderRadius: t.radius,
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
                    ? t.outputExtent(context, spec.valueLabel!)
                    : t.inputWidth,
                child: spec.kind == AppStepperKind.output
                    ? Center(
                        heightFactor: t.contentHeightFactor,
                        child: Text(
                          spec.valueLabel!,
                          style: t.valueStyle,
                          softWrap: false,
                          maxLines: t.singleLine,
                        ),
                      )
                    : Semantics(
                        label: spec.label,
                        child: TextField(
                          controller: spec.controller,
                          onChanged: spec.onChanged,
                          onSubmitted: spec.onSubmitted,
                          style: t.valueStyle,
                          textAlign: t.textAlign,
                          maxLines: t.singleLine,
                          cursorColor: t.foreground,
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
    final t = AppNumberStepperTheme.of(context);
    return states.contains(WidgetState.hovered) && widget.onPressed != null
        ? t.hoverBackground
        : t.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppNumberStepperTheme.of(context),
        disabled = widget.onPressed == null && widget.fadeDisabled;
    return CustomPaint(
      foregroundPainter: _focus.hasFocus ? _StepperFocusPainter(t) : null,
      child: Opacity(
        opacity: disabled ? t.disabledOpacity : t.enabledOpacity,
        child: SizedBox.square(
          dimension: t.height,
          child: IconButton(
            focusNode: _focus,
            onPressed: widget.onPressed,
            tooltip: widget.label,
            style: ButtonStyle(
              padding: WidgetStatePropertyAll(t.padding),
              fixedSize: WidgetStatePropertyAll(t.buttonSize),
              minimumSize: WidgetStatePropertyAll(t.buttonSize),
              maximumSize: WidgetStatePropertyAll(t.buttonSize),
              shape: WidgetStatePropertyAll(t.buttonShape),
              backgroundColor: WidgetStateProperty.resolveWith(_background),
              overlayColor: WidgetStatePropertyAll(t.transparent),
            ),
            icon: AppIcon(
              widget.glyph,
              color: disabled ? t.disabled : t.foreground,
            ),
          ),
        ),
      ),
    );
  }
}

class _StepperFocusPainter extends CustomPainter {
  const _StepperFocusPainter(this.theme);
  final AppNumberStepperTheme theme;
  @override
  void paint(Canvas canvas, Size size) => canvas.drawRRect(
    RRect.fromRectAndRadius(
      (Offset.zero & size).inflate(
        theme.focusOffset + theme.focusWidth * theme.half,
      ),
      Radius.circular(size.shortestSide * theme.half + theme.focusOffset),
    ),
    Paint()
      ..color = theme.focusColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = theme.focusWidth,
  );
  @override
  bool shouldRepaint(covariant _StepperFocusPainter old) => old.theme != theme;
}
