import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/data_table/app_data_table.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/app_status_colors.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class TableFixture extends StatelessWidget {
  const TableFixture({this.long = false, super.key});
  final bool long;
  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context),
        colors = Theme.of(context).extension<AppStatusColors>()!;
    return AppDataTable(
      caption: localizations.tableCaption,
      columns: [
        AppTableColumn(label: localizations.tableParticipant),
        AppTableColumn(
          label: localizations.tablePoints,
          alignment: AppTableAlignment.trailing,
        ),
        AppTableColumn(
          label: localizations.tableMatches,
          semanticLabel: localizations.tableMatchesFull,
          alignment: AppTableAlignment.trailing,
        ),
      ],
      rows: [
        for (final (primary, secondary, initials, color) in [
          ('Sub-Zero', 'Иван', 'SZ', colors.characterIce),
          ('Scorpion', 'Алексей', 'SC', Theme.of(context).colorScheme.primary),
          ('Kitana', 'Мария', 'KT', colors.characterFan),
        ])
          AppTableRow([
            AppTableIdentityCell(
              primary: primary,
              secondary: long ? '$secondary $secondary $secondary' : secondary,
              initials: initials,
              avatarForeground: color,
            ),
            const AppTableTextCell('3'),
            const AppTableTextCell('2'),
          ]),
      ],
    );
  }
}
