import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.kind = AppButtonKind.primary,
    this.glyph,
    this.fill = true,
    this.statesController,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });
  final String label;
  final VoidCallback? onPressed;
  final AppButtonKind kind;
  final AppGlyph? glyph;
  final bool fill, autofocus;
  final WidgetStatesController? statesController;
  final FocusNode? focusNode;
  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  late WidgetStatesController _states;
  bool get _owns => widget.statesController == null;
  @override
  void initState() {
    super.initState();
    _states = widget.statesController ?? WidgetStatesController();
    _states.addListener(_changed);
  }

  @override
  void didUpdateWidget(covariant AppButton old) {
    super.didUpdateWidget(old);
    if (old.statesController != widget.statesController) {
      _states.removeListener(_changed);
      if (old.statesController == null) _states.dispose();
      _states = widget.statesController ?? WidgetStatesController();
      _states.addListener(_changed);
    }
  }

  @override
  void dispose() {
    _states.removeListener(_changed);
    if (_owns) _states.dispose();
    super.dispose();
  }

  void _changed() => setState(_empty);
  void _empty() {}
  void _hover(bool value) => _states.update(WidgetState.hovered, value);
  void _focus(bool value) => _states.update(WidgetState.focused, value);
  void _down(TapDownDetails details) =>
      _states.update(WidgetState.pressed, true);
  void _up(TapUpDetails details) => _states.update(WidgetState.pressed, false);
  void _cancel() => _states.update(WidgetState.pressed, false);
  Object? _activate(ActivateIntent intent) {
    widget.onPressed?.call();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final states = {
      ..._states.value,
      if (widget.onPressed == null) WidgetState.disabled,
    };
    final theme = AppButtonTheme.of(
      context,
      widget.kind,
      states,
      label: widget.label,
    );
    return Semantics(
      button: true,
      enabled: widget.onPressed != null,
      label: widget.label,
      onTap: widget.onPressed,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: widget.onPressed != null,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
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
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          onTapDown: widget.onPressed == null ? null : _down,
          onTapUp: widget.onPressed == null ? null : _up,
          onTapCancel: _cancel,
          child: CustomPaint(
            foregroundPainter: states.contains(WidgetState.focused)
                ? _FocusPainter(theme)
                : null,
            child: SizedBox(
              width:
                  theme.width ??
                  (widget.fill
                      ? Theme.of(context)
                            .extension<FoundationLayout>()!
                            .fullWidth
                      : null),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.background,
                  shape: theme.circular ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: theme.circular ? null : theme.radius,
                  boxShadow: theme.shadows,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: theme.height),
                  child: Padding(
                    padding: theme.padding,
                    child: Row(
                      mainAxisSize: widget.fill
                          ? MainAxisSize.max
                          : MainAxisSize.min,
                      mainAxisAlignment: theme.justify,
                      crossAxisAlignment: theme.cross,
                      children: [
                        if (!theme.circular)
                          Flexible(
                            child: Text(widget.label, style: theme.text),
                          ),
                        if (widget.glyph != null) ...[
                          if (!theme.circular) SizedBox(width: theme.gap),
                          AppIcon(widget.glyph!, color: theme.foreground),
                        ],
                      ],
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

class _FocusPainter extends CustomPainter {
  const _FocusPainter(this.theme);
  final AppButtonTheme theme;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).inflate(
      theme.focusOffset + theme.focusWidth * theme.half,
    );
    final paintCorner = theme.circular
        ? size.shortestSide * theme.half
        : theme.radius.topLeft.x;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        rect,
        Radius.circular(paintCorner + theme.focusOffset),
      ),
      Paint()
        ..color = theme.focusColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = theme.focusWidth,
    );
  }

  @override
  bool shouldRepaint(covariant _FocusPainter old) => old.theme != theme;
}
