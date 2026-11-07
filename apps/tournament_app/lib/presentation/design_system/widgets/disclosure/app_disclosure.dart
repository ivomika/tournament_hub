import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/disclosure/app_disclosure_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

class AppDisclosure extends StatefulWidget {
  const AppDisclosure({
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.focusNode,
    super.key,
  });
  final String title;
  final bool expanded;
  final VoidCallback? onToggle;
  final Widget child;
  final FocusNode? focusNode;
  @override
  State<AppDisclosure> createState() => _DisclosureState();
}

class _DisclosureState extends State<AppDisclosure> {
  final _ownedFocus = FocusNode();
  FocusNode get _focus => widget.focusNode ?? _ownedFocus;
  @override
  void initState() {
    super.initState();
    _focus.addListener(_changed);
  }

  @override
  void didUpdateWidget(covariant AppDisclosure old) {
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

  @override
  Widget build(BuildContext context) {
    final t = AppDisclosureTheme.of(context);
    return Padding(
      padding: t.padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: t.stretch,
        children: [
          Semantics(
            expanded: widget.expanded,
            child: CustomPaint(
              foregroundPainter: _focus.hasFocus
                  ? _DisclosureFocusPainter(t)
                  : null,
              child: TextButton(
                focusNode: _focus,
                onPressed: widget.onToggle,
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(t.buttonPadding),
                  minimumSize: WidgetStatePropertyAll(t.minSize),
                  overlayColor: WidgetStatePropertyAll(t.transparent),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(widget.title, style: t.titleStyle)),
                    SizedBox(width: t.gap),
                    RotatedBox(
                      quarterTurns: widget.expanded
                          ? t.turns
                          : t.turns - t.turns,
                      child: AppIcon(
                        AppGlyph.chevron,
                        color: t.titleStyle.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.expanded)
            Padding(
              padding: t.bodyPadding,
              child: DefaultTextStyle(style: t.bodyStyle, child: widget.child),
            ),
        ],
      ),
    );
  }
}

class _DisclosureFocusPainter extends CustomPainter {
  const _DisclosureFocusPainter(this.theme);
  final AppDisclosureTheme theme;
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
  bool shouldRepaint(covariant _DisclosureFocusPainter old) =>
      old.theme != theme;
}
