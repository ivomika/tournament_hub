import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/score_choice/app_score_choice_theme.dart';

class AppScoreOption<T extends Object> {
  const AppScoreOption({required this.value, required this.label});
  final T value;
  final String label;
}

class AppScoreChoice<T extends Object> extends StatelessWidget {
  const AppScoreChoice({
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
  });
  final String label;
  final List<AppScoreOption<T>> options;
  final T value;
  final ValueChanged<T>? onChanged;
  @override
  Widget build(BuildContext context) {
    final t = AppScoreChoiceTheme.of(context);
    return Semantics(
      label: label,
      container: true,
      child: Row(
        children: [
          for (final (index, option) in options.indexed) ...[
            if (index > 0) SizedBox(width: t.gap),
            Expanded(
              child: _ScoreOption<T>(
                option: option,
                selected: option.value == value,
                onSelected: onChanged,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ScoreOption<T extends Object> extends StatefulWidget {
  const _ScoreOption({
    required this.option,
    required this.selected,
    required this.onSelected,
  });
  final AppScoreOption<T> option;
  final bool selected;
  final ValueChanged<T>? onSelected;
  @override
  State<_ScoreOption<T>> createState() => _ScoreOptionState<T>();
}

class _ScoreOptionState<T extends Object> extends State<_ScoreOption<T>> {
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
  void _choose() => widget.onSelected?.call(widget.option.value);
  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppScoreChoiceTheme.of(context),
        color = widget.onSelected == null
            ? t.disabled
            : widget.selected
            ? t.selected
            : t.foreground;
    return Semantics(
      selected: widget.selected,
      inMutuallyExclusiveGroup: true,
      child: CustomPaint(
        foregroundPainter: _focus.hasFocus ? _ChoiceFocusPainter(t) : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: t.background,
            borderRadius: t.radius,
            border: Border.all(
              color: widget.selected ? t.selected : t.border,
              width: t.borderWidth,
            ),
          ),
          child: TextButton(
            focusNode: _focus,
            onPressed: widget.onSelected == null ? null : _choose,
            style: ButtonStyle(
              minimumSize: WidgetStatePropertyAll(t.minimumSize),
              padding: WidgetStatePropertyAll(t.padding),
              shape: WidgetStatePropertyAll(t.shape),
              overlayColor: WidgetStatePropertyAll(t.transparent),
            ),
            child: Text(
              widget.option.label,
              style: t.style.copyWith(color: color),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChoiceFocusPainter extends CustomPainter {
  const _ChoiceFocusPainter(this.theme);
  final AppScoreChoiceTheme theme;
  @override
  void paint(Canvas canvas, Size size) => canvas.drawRRect(
    RRect.fromRectAndRadius(
      (Offset.zero & size).inflate(
        theme.focusOffset + theme.focusWidth * theme.half,
      ),
      Radius.circular(theme.radius.topLeft.x + theme.focusOffset),
    ),
    Paint()
      ..color = theme.focusColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = theme.focusWidth,
  );
  @override
  bool shouldRepaint(covariant _ChoiceFocusPainter old) => old.theme != theme;
}
