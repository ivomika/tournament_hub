import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_text/ds_text.dart';
import '../responsive_actions/responsive_actions.dart';
import 'confirmation_theme.dart';

enum TournamentConfirmationStatus { idle, loading, success }

Future<T?> showTournamentConfirmationDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  final previousFocus = FocusManager.instance.primaryFocus;
  final result = await showDialog<T>(context: context, builder: builder);
  if (previousFocus?.canRequestFocus ?? false) previousFocus!.requestFocus();
  return result;
}

class TournamentConfirmationPreview extends StatelessWidget {
  const TournamentConfirmationPreview({
    this.status = TournamentConfirmationStatus.idle,
    super.key,
  });

  final TournamentConfirmationStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ConfirmationTheme>()!;
    return Dialog(
      backgroundColor: theme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(theme.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DsText('Отменить турнир?', variant: DsTextVariant.title),
            SizedBox(height: theme.gap),
            const DsText(
              'Активный турнир будет завершён как отменённый. Это действие нельзя отменить.',
              variant: DsTextVariant.secondary,
            ),
            SizedBox(height: theme.gap),
            ResponsiveActions(
              primary: DsAction(
                label: status == TournamentConfirmationStatus.success
                    ? 'Турнир отменён'
                    : 'Отменить турнир',
                kind: DsActionKind.danger,
                status: switch (status) {
                  TournamentConfirmationStatus.idle => DsActionStatus.idle,
                  TournamentConfirmationStatus.loading =>
                    DsActionStatus.loading,
                  TournamentConfirmationStatus.success =>
                    DsActionStatus.success,
                },
                onPressed: status == TournamentConfirmationStatus.success
                    ? null
                    : () {},
              ),
              secondary: [
                DsAction(
                  label: 'Назад',
                  kind: DsActionKind.text,
                  autofocus: true,
                  onPressed: status == TournamentConfirmationStatus.loading
                      ? null
                      : () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DsConfirmationDialog extends StatelessWidget {
  const DsConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel = 'Назад',
    this.loading = false,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ConfirmationTheme>()!;
    return Dialog(
      backgroundColor: theme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(theme.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DsText(title, variant: DsTextVariant.title),
            SizedBox(height: theme.gap),
            DsText(message, variant: DsTextVariant.secondary),
            SizedBox(height: theme.gap),
            ResponsiveActions(
              primary: DsAction(
                label: confirmLabel,
                kind: DsActionKind.danger,
                status: loading ? DsActionStatus.loading : DsActionStatus.idle,
                onPressed: loading ? null : onConfirm,
              ),
              secondary: [
                DsAction(
                  label: cancelLabel,
                  kind: DsActionKind.text,
                  autofocus: true,
                  onPressed: loading ? null : () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
