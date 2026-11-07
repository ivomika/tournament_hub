import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

enum FieldSample { filled, empty, readOnly, focused, invalid, disabled }

class FieldFixture extends StatefulWidget {
  const FieldFixture({
    this.kind = AppFieldKind.singleLine,
    this.sample = FieldSample.filled,
    super.key,
  });
  final AppFieldKind kind;
  final FieldSample sample;
  @override
  State<FieldFixture> createState() => _FieldFixtureState();
}

class _FieldFixtureState extends State<FieldFixture> {
  final _controller = TextEditingController(), _focus = FocusNode();
  bool _initialized = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final l = FoundationLocalizations.of(context);
      _controller.text = widget.sample == FieldSample.empty
          ? ''
          : widget.kind == AppFieldKind.multiline
          ? l.fieldMessageSample
          : l.fieldNameSample;
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback(_apply);
    }
  }

  @override
  void didUpdateWidget(covariant FieldFixture old) {
    super.didUpdateWidget(old);
    if (old.kind != widget.kind || old.sample != widget.sample) {
      final l = FoundationLocalizations.of(context);
      _controller.text = widget.sample == FieldSample.empty
          ? ''
          : widget.kind == AppFieldKind.multiline
          ? l.fieldMessageSample
          : l.fieldNameSample;
      _focus.unfocus();
      WidgetsBinding.instance.addPostFrameCallback(_apply);
    }
  }

  void _apply(Duration elapsed) {
    if (mounted && widget.sample == FieldSample.focused) _focus.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context);
    return AppField(
      controller: _controller,
      focusNode: _focus,
      label: widget.kind == AppFieldKind.multiline
          ? l.fieldMessageLabel
          : l.fieldNameLabel,
      kind: widget.kind,
      enabled: widget.sample != FieldSample.disabled,
      readOnly: widget.sample == FieldSample.readOnly,
      errorText: widget.sample == FieldSample.invalid
          ? l.fieldErrorSample
          : null,
    );
  }
}
