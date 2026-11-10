import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_painter.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_theme.dart';
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
    final appearance = AppScoreChoiceTheme.of(context);
    return Semantics(
      label: label,
      container: true,
      child: Row(
        children: [
          for (final (index, option) in options.indexed) ...[
            if (index > 0) SizedBox(width: appearance.gap),
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
  Color _resolveColor(AppScoreChoiceTheme theme) {
    if (widget.onSelected == null) return theme.disabled;
    if (widget.selected) return theme.selected;
    return theme.foreground;
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appearance = AppScoreChoiceTheme.of(context),
        color = _resolveColor(appearance);
    return Semantics(
      selected: widget.selected,
      inMutuallyExclusiveGroup: true,
      child: CustomPaint(
        foregroundPainter: _focus.hasFocus
            ? AppFocusRingPainter(
                AppFocusRingTheme(
                  color: appearance.focusColor,
                  width: appearance.focusWidth,
                  offset: appearance.focusOffset,
                  radius: appearance.radius,
                  capsule: false,
                  half: appearance.half,
                ),
              )
            : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: appearance.background,
            borderRadius: appearance.radius,
            border: Border.all(
              color: widget.selected ? appearance.selected : appearance.border,
              width: appearance.borderWidth,
            ),
          ),
          child: TextButton(
            focusNode: _focus,
            onPressed: widget.onSelected == null ? null : _choose,
            style: ButtonStyle(
              minimumSize: WidgetStatePropertyAll(appearance.minimumSize),
              padding: WidgetStatePropertyAll(appearance.padding),
              shape: WidgetStatePropertyAll(appearance.shape),
              overlayColor: WidgetStatePropertyAll(appearance.transparent),
            ),
            child: Text(
              widget.option.label,
              style: appearance.style.copyWith(color: color),
            ),
          ),
        ),
      ),
    );
  }
}
