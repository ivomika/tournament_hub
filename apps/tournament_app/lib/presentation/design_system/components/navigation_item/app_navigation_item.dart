import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_painter.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/navigation_item/app_navigation_item_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

class AppNavigationItem extends StatefulWidget {
  const AppNavigationItem({
    required this.label,
    required this.glyph,
    required this.onPressed,
    this.statesController,
    this.focusNode,
    super.key,
  });
  final String label;
  final AppGlyph glyph;
  final VoidCallback? onPressed;
  final WidgetStatesController? statesController;
  final FocusNode? focusNode;
  @override
  State<AppNavigationItem> createState() => _NavigationState();
}

class _NavigationState extends State<AppNavigationItem> {
  final _ownedStates = WidgetStatesController();
  WidgetStatesController get _states => widget.statesController ?? _ownedStates;
  @override
  void initState() {
    super.initState();
    _states.addListener(_changed);
  }

  @override
  void didUpdateWidget(covariant AppNavigationItem old) {
    super.didUpdateWidget(old);
    if (old.statesController != widget.statesController) {
      (old.statesController ?? _ownedStates).removeListener(_changed);
      _states.addListener(_changed);
    }
  }

  void _changed() {
    setState(_rebuild);
  }

  void _hover(bool value) => _states.update(WidgetState.hovered, value);
  void _focus(bool value) => _states.update(WidgetState.focused, value);
  Object? _activate(ActivateIntent intent) {
    widget.onPressed?.call();
    return null;
  }

  void _rebuild() {}
  @override
  void dispose() {
    _states.removeListener(_changed);
    _ownedStates.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final states = {
          ..._states.value,
          if (widget.onPressed == null) WidgetState.disabled,
        },
        appearance = AppNavigationItemTheme.of(context, states);
    return Semantics(
      button: true,
      enabled: widget.onPressed != null,
      child: FocusableActionDetector(
        enabled: widget.onPressed != null,
        focusNode: widget.focusNode,
        onShowHoverHighlight: _hover,
        onShowFocusHighlight: _focus,
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _activate),
        },
        child: GestureDetector(
          onTap: widget.onPressed,
          child: CustomPaint(
            foregroundPainter: states.contains(WidgetState.focused)
                ? AppFocusRingPainter(
                    AppFocusRingTheme(
                      color: appearance.focusColor,
                      width: appearance.focusWidth,
                      offset: appearance.focusOffset,
                      radius: appearance.focusRadius,
                      capsule: false,
                      half: appearance.half,
                    ),
                  )
                : null,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: appearance.background,
                borderRadius: appearance.radius,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: appearance.minHeight),
                child: Padding(
                  padding: appearance.padding,
                  child: Row(
                    children: [
                      AppIcon(
                        widget.glyph,
                        size: appearance.iconSize,
                        color: appearance.iconColor,
                      ),
                      SizedBox(width: appearance.gap),
                      Expanded(
                        child: Text(widget.label, style: appearance.labelStyle),
                      ),
                      SizedBox(width: appearance.gap),
                      AppIcon(
                        AppGlyph.chevron,
                        size: appearance.chevronSize,
                        color: appearance.chevronColor,
                      ),
                    ],
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
