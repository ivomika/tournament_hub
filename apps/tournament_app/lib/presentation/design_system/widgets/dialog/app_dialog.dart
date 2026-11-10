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
    this.leading,
    super.key,
  });
  final String title, content, confirmLabel, cancelLabel;
  final Widget? leading;
  final VoidCallback? onConfirm, onCancel;
  final FocusNode? confirmFocus, cancelFocus;
  @override
  Widget build(BuildContext context) {
    final appearance = AppDialogTheme.of(context);
    return Semantics(
      namesRoute: true,
      scopesRoute: true,
      explicitChildNodes: true,
      label: title,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: appearance.maxWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: appearance.background,
            borderRadius: appearance.radius,
            border: appearance.border,
            boxShadow: appearance.shadows,
          ),
          child: Padding(
            padding: appearance.padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: appearance.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(title, style: appearance.titleStyle),
                ),
                SizedBox(height: appearance.gap),
                if (leading != null) ...[
                  leading!,
                  SizedBox(height: appearance.gap),
                ],
                Text(content, style: appearance.bodyStyle),
                SizedBox(height: appearance.gap + appearance.actionGap),
                AppButton(
                  label: confirmLabel,
                  kind: AppButtonKind.dialogDestructive,
                  onPressed: onConfirm,
                  focusNode: confirmFocus,
                ),
                SizedBox(height: appearance.actionGap),
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
