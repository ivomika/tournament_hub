import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/dialog/app_dialog.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class DialogFixture extends StatelessWidget {
  const DialogFixture({
    this.disabled = false,
    this.cancelFocus,
    this.onConfirm,
    this.onCancel,
    super.key,
  });
  final bool disabled;
  final FocusNode? cancelFocus;
  final VoidCallback? onConfirm, onCancel;
  void _confirm() {}
  void _cancel() {}
  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context);
    return AppDialog(
      title: localizations.dialogTitle,
      content: localizations.dialogContent,
      confirmLabel: localizations.dialogConfirm,
      cancelLabel: localizations.dialogCancel,
      onConfirm: disabled ? null : onConfirm ?? _confirm,
      onCancel: onCancel ?? _cancel,
      cancelFocus: cancelFocus,
    );
  }
}
