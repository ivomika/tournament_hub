import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_painter.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_theme.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
export 'package:tournament_app/presentation/design_system/components/field/app_field_theme.dart'
    show AppFieldKind;

/// Edits supplied text and delegates changes; validation belongs to the consumer.
class AppField extends StatefulWidget {
  const AppField({
    required this.label,
    required this.controller,
    this.kind = AppFieldKind.singleLine,
    this.enabled = true,
    this.readOnly = false,
    this.errorText,
    this.supportingText,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });
  final String label;
  final TextEditingController controller;
  final AppFieldKind kind;
  final bool enabled, readOnly;
  final String? errorText, supportingText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged, onSubmitted;
  @override
  State<AppField> createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  final _ownedFocus = FocusNode();
  FocusNode get _focus => widget.focusNode ?? _ownedFocus;
  @override
  void initState() {
    super.initState();
    _focus.addListener(_changed);
  }

  @override
  void didUpdateWidget(covariant AppField old) {
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
    final t = AppFieldTheme.of(
          context,
          widget.kind,
          widget.enabled,
          widget.errorText != null,
        ),
        multiline = widget.kind == AppFieldKind.multiline;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: t.crossAxis,
      children: [
        ExcludeSemantics(child: Text(widget.label, style: t.labelStyle)),
        SizedBox(height: t.gap),
        CustomPaint(
          foregroundPainter: _focus.hasFocus && widget.enabled
              ? AppFocusRingPainter(
                  AppFocusRingTheme(
                    color: t.focusColor,
                    width: t.focusWidth,
                    offset: t.focusOffset,
                    radius: t.radius,
                    capsule: false,
                    half: t.half,
                  ),
                )
              : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: t.background,
              borderRadius: t.radius,
              border: Border.all(color: t.border, width: t.borderWidth),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: t.minHeight),
              child: Padding(
                padding: t.padding,
                child: Align(
                  alignment: t.align,
                  heightFactor: multiline ? null : t.half + t.half,
                  child: Semantics(
                    label: widget.label,
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focus,
                      enabled: widget.enabled,
                      readOnly: widget.readOnly,
                      onChanged: widget.onChanged,
                      onSubmitted: widget.onSubmitted,
                      maxLines: multiline ? null : t.singleLine,
                      minLines: t.singleLine,
                      style: t.inputStyle,
                      cursorColor: t.foreground,
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                      ),
                      keyboardType: multiline
                          ? TextInputType.multiline
                          : TextInputType.text,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null || widget.supportingText != null) ...[
          SizedBox(height: t.gap),
          Semantics(
            liveRegion: widget.errorText != null,
            child: Row(
              crossAxisAlignment: t.supportingCrossAxis,
              children: [
                if (widget.errorText != null) ...[
                  AppIcon(AppGlyph.alert, color: t.errorColor),
                  SizedBox(width: t.gap),
                ],
                Expanded(
                  child: Text(
                    widget.errorText ?? widget.supportingText!,
                    style: widget.errorText != null
                        ? t.errorStyle
                        : t.labelStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
