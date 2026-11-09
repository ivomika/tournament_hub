import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/models/player_display.dart';
import 'package:tournament_app/presentation/design_system/widgets/data_table/app_table_models.dart';
import 'package:tournament_app/presentation/screens/tournament/tournament_screen.dart';
import 'package:tournament_app/presentation/screens/tournament/tournament_screen_state.dart';

enum TournamentSample { de, se, rr, tiebreak }

class TournamentFixture extends StatelessWidget {
  const TournamentFixture({required this.sample, super.key});
  final TournamentSample sample;
  static void action() {}
  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context);
    final rr = sample == TournamentSample.rr,
        tie = sample == TournamentSample.tiebreak;
    return TournamentScreen(
      state: TournamentScreenState(
        title: 'Пятничный турнир',
        roundLabel: switch (sample) {
          TournamentSample.de => 'Верхняя сетка · Раунд 1 · FT1',
          TournamentSample.se => 'Полуфинал · FT1',
          TournamentSample.rr => 'Сейчас · FT2',
          TournamentSample.tiebreak => 'Переигровка · За итоговое место · FT2',
        },
        left: const PlayerDisplay(
          character: 'Sub-Zero',
          name: 'Иван',
          initials: 'SZ',
        ),
        right: const PlayerDisplay(
          character: 'Scorpion',
          name: 'Алексей',
          initials: 'SC',
        ),
        leftScore: '0',
        rightScore: '0',
        leftPoints: rr ? '2 очка' : null,
        rightPoints: rr ? '0 очков' : null,
        hasBracket: !rr && !tie,
        nextPlayers: [
          const PlayerDisplay(
            character: 'Kitana',
            name: 'Мария',
            initials: 'KT',
          ),
          rr || tie
              ? const PlayerDisplay(
                  character: 'Sub-Zero',
                  name: 'Иван',
                  initials: 'SZ',
                )
              : const PlayerDisplay(
                  character: 'Raiden',
                  name: 'Олег',
                  initials: 'RD',
                ),
        ],
        details: rr
            ? [
                TournamentDetail(
                  title: l.screenStandings,
                  expanded: false,
                  onToggle: action,
                  content: TournamentTableContent(
                    caption: l.tableCaption,
                    columns: [
                      AppTableColumn(label: l.tableParticipant),
                      AppTableColumn(
                        label: l.tablePoints,
                        alignment: AppTableAlignment.trailing,
                      ),
                      AppTableColumn(
                        label: l.tableMatches,
                        alignment: AppTableAlignment.trailing,
                      ),
                    ],
                    rows: const [
                      AppTableRow([
                        AppTableIdentityCell(
                          primary: 'Sub-Zero',
                          secondary: 'Иван',
                          initials: 'SZ',
                        ),
                        AppTableTextCell('2'),
                        AppTableTextCell('1'),
                      ]),
                      AppTableRow([
                        AppTableIdentityCell(
                          primary: 'Scorpion',
                          secondary: 'Алексей',
                          initials: 'SC',
                        ),
                        AppTableTextCell('0'),
                        AppTableTextCell('1'),
                      ]),
                      AppTableRow([
                        AppTableIdentityCell(
                          primary: 'Kitana',
                          secondary: 'Мария',
                          initials: 'KT',
                        ),
                        AppTableTextCell('0'),
                        AppTableTextCell('0'),
                      ]),
                    ],
                  ),
                ),
                TournamentDetail(
                  title: l.screenMatchResults,
                  expanded: false,
                  onToggle: action,
                  content: TournamentTextContent(l.screenStandingsResultsNote),
                ),
              ]
            : tie
            ? [
                TournamentDetail(
                  title: l.screenHowPlaces,
                  expanded: false,
                  onToggle: action,
                  content: TournamentTextContent(l.screenTiebreakDetails),
                ),
              ]
            : [
                TournamentDetail(
                  title: l.screenManagement,
                  expanded: false,
                  onToggle: action,
                  content: TournamentActionsContent([
                    TournamentAction(
                      label: l.screenWithdrawAction,
                      onPressed: action,
                    ),
                    TournamentAction(
                      label: l.screenResultCorrect,
                      onPressed: action,
                    ),
                  ]),
                ),
              ],
      ),
      onBack: action,
      onShare: action,
      onBracket: action,
      onResult: action,
    );
  }
}
