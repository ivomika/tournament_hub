import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/dialog/app_dialog_theme.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
    this.confirmFocus,
    this.cancelFocus,
    super.key,
  });
  final String title, content, confirmLabel, cancelLabel;
  final VoidCallback? onConfirm, onCancel;
  final FocusNode? confirmFocus, cancelFocus;
  @override
  Widget build(BuildContext context) {
    final t = AppDialogTheme.of(context);
    return Semantics(
      namesRoute: true,
      scopesRoute: true,
      explicitChildNodes: true,
      label: title,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: t.maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: t.background,
            borderRadius: t.radius,
            border: Border.all(color: t.borderColor, width: t.borderWidth),
            boxShadow: t.shadows,
          ),
          child: Padding(
            padding: t.padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: t.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(title, style: t.titleStyle),
                ),
                SizedBox(height: t.gap),
                Text(content, style: t.bodyStyle),
                SizedBox(height: t.gap + t.actionGap),
                AppButton(
                  label: confirmLabel,
                  kind: AppButtonKind.dialogDestructive,
                  onPressed: onConfirm,
                  focusNode: confirmFocus,
                ),
                SizedBox(height: t.actionGap),
                AppButton(
                  label: cancelLabel,
                  kind: AppButtonKind.dialogCancel,
                  onPressed: onCancel,
                  focusNode: cancelFocus,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
