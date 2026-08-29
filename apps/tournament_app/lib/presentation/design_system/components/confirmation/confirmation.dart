import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_text/ds_text.dart';
import '../responsive_actions/responsive_actions.dart';
import 'confirmation_theme.dart';

enum TournamentConfirmationStatus { idle, loading, success }

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
