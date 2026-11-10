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
      final localizations = FoundationLocalizations.of(context);
      _controller.text = _resolveSampleText(localizations);
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback(_apply);
    }
  }

  @override
  void didUpdateWidget(covariant FieldFixture old) {
    super.didUpdateWidget(old);
    if (old.kind != widget.kind || old.sample != widget.sample) {
      final localizations = FoundationLocalizations.of(context);
      _controller.text = _resolveSampleText(localizations);
      _focus.unfocus();
      WidgetsBinding.instance.addPostFrameCallback(_apply);
    }
  }

  String _resolveSampleText(FoundationLocalizations localizations) {
    if (widget.sample == FieldSample.empty) return '';
    if (widget.kind == AppFieldKind.multiline) {
      return localizations.fieldMessageSample;
    }
    return localizations.fieldNameSample;
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
    final localizations = FoundationLocalizations.of(context);
    return AppField(
      controller: _controller,
      focusNode: _focus,
      label: widget.kind == AppFieldKind.multiline
          ? localizations.fieldMessageLabel
          : localizations.fieldNameLabel,
      kind: widget.kind,
      enabled: widget.sample != FieldSample.disabled,
      readOnly: widget.sample == FieldSample.readOnly,
      errorText: widget.sample == FieldSample.invalid
          ? localizations.fieldErrorSample
          : null,
    );
  }
}
