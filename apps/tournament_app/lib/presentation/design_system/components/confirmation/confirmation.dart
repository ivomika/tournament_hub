import 'package:flutter/material.dart';

import '../ds_action/ds_action.dart';
import '../ds_text/ds_text.dart';
import 'confirmation_theme.dart';

class TournamentConfirmationPreview extends StatelessWidget {
  const TournamentConfirmationPreview({super.key});

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
            Wrap(
              alignment: WrapAlignment.end,
              spacing: theme.gap,
              children: [
                DsAction(
                  label: 'Назад',
                  kind: DsActionKind.text,
                  onPressed: () {},
                ),
                DsAction(label: 'Отменить турнир', onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
