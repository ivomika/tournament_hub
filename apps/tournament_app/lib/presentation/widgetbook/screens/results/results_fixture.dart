import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/models/player_display.dart';
import 'package:tournament_app/presentation/design_system/widgets/ranking_row/app_ranking_row.dart';
import 'package:tournament_app/presentation/screens/results/results_screen.dart';
import 'package:tournament_app/presentation/screens/results/results_screen_state.dart';

enum ResultsSample { de, se, rr }

class ResultsFixture extends StatelessWidget {
  const ResultsFixture({required this.sample, super.key});
  final ResultsSample sample;
  static void action() {}

  String _resolveMeta() {
    if (sample == ResultsSample.rr) return 'RR · FT2 · 3 участника';
    if (sample == ResultsSample.se) return 'SE · 4 участника';
    return 'DE · 4 участника';
  }

  List<RankingGroup> _resolveGroups(bool rr, bool se) {
    if (rr) {
      return [
        RankingGroup(
          layout: RankingGroupLayout.paired,
          entries: const [
            RankingEntry(
              player: PlayerDisplay(
                character: 'Scorpion',
                name: 'Алексей',
                initials: 'SC',
              ),
              value: '3',
            ),
            RankingEntry(
              player: PlayerDisplay(
                character: 'Kitana',
                name: 'Мария',
                initials: 'KT',
              ),
              value: '0',
            ),
          ],
        ),
      ];
    }
    return [
      RankingGroup(
        layout: RankingGroupLayout.paired,
        entries: [
          const RankingEntry(
            player: PlayerDisplay(
              character: 'Sub-Zero',
              name: 'Иван',
              initials: 'SZ',
            ),
            value: '2',
          ),
          RankingEntry(
            player: const PlayerDisplay(
              character: 'Scorpion',
              name: 'Алексей',
              initials: 'SC',
            ),
            value: se ? '3–4' : '3',
          ),
        ],
      ),
      RankingGroup(
        layout: RankingGroupLayout.single,
        entries: [
          RankingEntry(
            player: const PlayerDisplay(
              character: 'Raiden',
              name: 'Олег',
              initials: 'RD',
            ),
            value: se ? '3–4' : '4',
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = FoundationLocalizations.of(context),
        rr = sample == ResultsSample.rr,
        se = sample == ResultsSample.se;
    return ResultsScreen(
      state: ResultsScreenState(
        title: 'Пятничный турнир',
        meta: _resolveMeta(),
        featured: rr
            ? const RankingEntry(
                player: PlayerDisplay(
                  character: 'Sub-Zero',
                  name: 'Иван',
                  initials: 'SZ',
                ),
                value: '6',
              )
            : const RankingEntry(
                player: PlayerDisplay(
                  character: 'Kitana',
                  name: 'Мария',
                  initials: 'KT',
                ),
                value: '1',
              ),
        valuePlacement: rr
            ? AppRankValuePlacement.trailing
            : AppRankValuePlacement.leading,
        hasBracket: !rr && !se,
        groups: _resolveGroups(rr, se),
        explanation: se
            ? ResultsExplanation(
                title: localizations.screenThirdPlaces,
                text: localizations.screenThirdPlacesCopy,
                expanded: false,
                onToggle: action,
              )
            : null,
      ),
      onBack: action,
      onShare: action,
      onBracket: action,
      onHome: action,
    );
  }
}
