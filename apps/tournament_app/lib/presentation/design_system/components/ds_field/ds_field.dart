import 'package:flutter/material.dart';

import 'ds_field_theme.dart';

enum DsFieldStatus { idle, loading, success }

enum DsTextInputAction { next, done }

class DsTextField extends StatelessWidget {
  const DsTextField({
    required this.label,
    this.controller,
    this.focusNode,
    this.helperText,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.status = DsFieldStatus.idle,
    this.enabled = true,
    this.autofocus = false,
    this.obscureText = false,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? helperText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final DsTextInputAction? textInputAction;
  final DsFieldStatus status;
  final bool enabled;
  final bool autofocus;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsFieldTheme>()!;
    final suffix = switch (status) {
      DsFieldStatus.idle => null,
      DsFieldStatus.loading => SizedBox.square(
        dimension: theme.indicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: theme.indicatorStrokeWidth,
        ),
      ),
      DsFieldStatus.success => Icon(Icons.check_circle, color: theme.success),
    };
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: status == DsFieldStatus.loading,
      autofocus: autofocus,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: switch (textInputAction) {
        null => null,
        DsTextInputAction.next => TextInputAction.next,
        DsTextInputAction.done => TextInputAction.done,
      },
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: theme.decoration.copyWith(
        labelText: label,
        helperText: helperText,
        errorText: errorText,
        suffixIcon: suffix,
      ),
    );
  }
}
