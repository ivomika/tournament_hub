import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_painter.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tournament_app/presentation/design_system/components/segmented_choice/app_segmented_choice_theme.dart';

class AppSegment<T extends Object> {
  const AppSegment({required this.value, required this.label});
  final T value;
  final String label;
}

/// Controlled visual selection. Values have no domain meaning to this control.
class AppSegmentedChoice<T extends Object> extends StatefulWidget {
  const AppSegmentedChoice({
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.focusNode,
    this.nested = false,
    super.key,
  });
  final String label;
  final bool nested;
  final List<AppSegment<T>> options;
  final T value;
  final ValueChanged<T>? onChanged;
  final FocusNode? focusNode;
  @override
  State<AppSegmentedChoice<T>> createState() => _SegmentedState<T>();
}

class _SegmentMoveIntent extends Intent {
  const _SegmentMoveIntent(this.forward);
  final bool forward;
}

class _SegmentedState<T extends Object> extends State<AppSegmentedChoice<T>> {
  final _ownedFocus = FocusNode();
  FocusNode get _focus => widget.focusNode ?? _ownedFocus;
  @override
  void initState() {
    super.initState();
    _focus.addListener(_changed);
  }

  @override
  void didUpdateWidget(covariant AppSegmentedChoice<T> old) {
    super.didUpdateWidget(old);
    if (old.focusNode != widget.focusNode) {
      (old.focusNode ?? _ownedFocus).removeListener(_changed);
      _focus.addListener(_changed);
    }
  }

  void _changed() {
    setState(_rebuild);
  }

  void _rebuild() {}
  @override
  void dispose() {
    _focus.removeListener(_changed);
    _ownedFocus.dispose();
    super.dispose();
  }

  void _choose(T value) {
    _focus.requestFocus();
    widget.onChanged?.call(value);
  }

  Object? _move(_SegmentMoveIntent intent) {
    if (widget.onChanged == null || widget.options.isEmpty) return null;
    final current = widget.options.indexWhere((o) => o.value == widget.value),
        rtl = Directionality.of(context) == TextDirection.rtl;
    final next =
        (current + ((intent.forward != rtl) ? 1 : -1) + widget.options.length) %
        widget.options.length;
    widget.onChanged!(widget.options[next].value);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppSegmentedChoiceTheme.of(context, nested: widget.nested),
        enabled = widget.onChanged != null;
    return Semantics(
      label: widget.label,
      container: true,
      child: FocusableActionDetector(
        enabled: enabled,
        focusNode: _focus,
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.arrowLeft): _SegmentMoveIntent(
            false,
          ),
          SingleActivator(LogicalKeyboardKey.arrowRight): _SegmentMoveIntent(
            true,
          ),
        },
        actions: {
          _SegmentMoveIntent: CallbackAction<_SegmentMoveIntent>(
            onInvoke: _move,
          ),
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: t.background,
            borderRadius: t.radius,
          ),
          child: Padding(
            padding: t.padding,
            child: Row(
              children: [
                for (final (index, option) in widget.options.indexed) ...[
                  if (index > 0) SizedBox(width: t.gap),
                  Expanded(
                    child: _Segment<T>(
                      option: option,
                      selected: option.value == widget.value,
                      focused: _focus.hasFocus && option.value == widget.value,
                      onSelected: enabled ? _choose : null,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Segment<T extends Object> extends StatelessWidget {
  const _Segment({
    required this.option,
    required this.selected,
    required this.focused,
    required this.onSelected,
  });
  final AppSegment<T> option;
  final bool selected, focused;
  final ValueChanged<T>? onSelected;
  void _choose() => onSelected?.call(option.value);
  @override
  Widget build(BuildContext context) {
    final t = AppSegmentedChoiceTheme.of(context);
    return Semantics(
      checked: selected,
      inMutuallyExclusiveGroup: true,
      enabled: onSelected != null,
      button: true,
      child: GestureDetector(
        onTap: onSelected == null ? null : _choose,
        child: CustomPaint(
          foregroundPainter: focused
              ? AppFocusRingPainter(
                  AppFocusRingTheme(
                    color: t.focusColor,
                    width: t.focusWidth,
                    offset: t.focusOffset,
                    radius: null,
                    capsule: true,
                    half: t.half,
                  ),
                )
              : null,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: t.height),
            child: Padding(
              padding: t.selectedInset,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? t.selectedBackground : t.transparent,
                  borderRadius: t.radius,
                ),
                child: Center(
                  heightFactor: t.contentHeightFactor,
                  child: Text(
                    option.label,
                    style: (selected ? t.selectedStyle : t.normalStyle)
                        .copyWith(
                          color: onSelected == null
                              ? t.disabled
                              : selected
                              ? t.foreground
                              : t.secondary,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
