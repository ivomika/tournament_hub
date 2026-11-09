import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/data_table/app_table_models.dart';
import 'package:tournament_app/presentation/screens/tie/tie_screen.dart';
import 'package:tournament_app/presentation/screens/tie/tie_screen_state.dart';

class TieFixture extends StatelessWidget {
  const TieFixture({super.key});
  static void action() {}
  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context);
    return TieScreen(
      state: TieScreenState(
        note: l.screenReplayNote,
        rulesExpanded: false,
        columns: [
          AppTableColumn(label: l.tableParticipant),
          AppTableColumn(
            label: l.tablePoints,
            alignment: AppTableAlignment.trailing,
          ),
          AppTableColumn(
            label: l.tableMatches,
            alignment: AppTableAlignment.trailing,
            semanticLabel: l.tableMatchesFull,
          ),
        ],
        rows: const [
          AppTableRow([
            AppTableIdentityCell(
              primary: 'Sub-Zero',
              secondary: 'Иван',
              initials: 'SZ',
            ),
            AppTableTextCell('3'),
            AppTableTextCell('2'),
          ]),
          AppTableRow([
            AppTableIdentityCell(
              primary: 'Scorpion',
              secondary: 'Алексей',
              initials: 'SC',
            ),
            AppTableTextCell('3'),
            AppTableTextCell('2'),
          ]),
          AppTableRow([
            AppTableIdentityCell(
              primary: 'Kitana',
              secondary: 'Мария',
              initials: 'KT',
            ),
            AppTableTextCell('3'),
            AppTableTextCell('2'),
          ]),
        ],
      ),
      onBack: action,
      onShare: action,
      onToggleRules: action,
      onStart: action,
    );
  }
}
