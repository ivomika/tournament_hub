import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../design_system/design_system.dart';
import '../screens/screen_registry.dart';

class TournamentWidgetbook extends StatelessWidget {
  const TournamentWidgetbook({super.key});

  @override
  Widget build(BuildContext context) => Widgetbook.material(
    directories: buildTournamentCatalog(),
    darkTheme: TournamentTheme.dark,
    themeMode: ThemeMode.dark,
    addons: [
      MaterialThemeAddon(
        themes: [
          WidgetbookTheme(name: 'Tournament dark', data: TournamentTheme.dark),
        ],
      ),
      ViewportAddon([
        IosViewports.iPhone13,
        AndroidViewports.mediumTablet,
        WindowsViewports.desktop,
      ]),
    ],
  );
}

List<WidgetbookNode> buildTournamentCatalog() => [
  WidgetbookCategory(
    name: 'Design system',
    children: [
      WidgetbookComponent(
        name: 'Tokens',
        useCases: [_useCase('Manifest', const TokenShowcase())],
      ),
      WidgetbookComponent(
        name: 'Typography',
        useCases: [
          _useCase(
            'Scale',
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DsText('Display', variant: DsTextVariant.display),
                DsText('Heading', variant: DsTextVariant.heading),
                DsText('Title', variant: DsTextVariant.title),
                DsText('Body'),
                DsText('Secondary', variant: DsTextVariant.secondary),
                DsText('Label', variant: DsTextVariant.label),
              ],
            ),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Actions and fields',
        useCases: [
          WidgetbookUseCase(
            name: 'States',
            builder: (_) => DsPagePadding(
              child: DsFlow(
                children: [
                  DsAction(label: 'Primary', onPressed: () {}),
                  DsAction(
                    label: 'Secondary',
                    kind: DsActionKind.secondary,
                    onPressed: () {},
                  ),
                  const DsAction(label: 'Disabled'),
                  const DsTextField(label: 'Tournament name'),
                ],
              ),
            ),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Tournament components',
        useCases: [
          _useCase(
            'Identity / Compact',
            ParticipantIdentity(
              participant: previewParticipants.first,
              artworkVariant: FighterArtworkVariant.compact,
            ),
          ),
          _useCase(
            'Identity / Standard',
            ParticipantIdentity(participant: previewParticipants.first),
          ),
          _useCase(
            'Identity / Matchup',
            ParticipantIdentity(
              participant: previewParticipants.first,
              artworkVariant: FighterArtworkVariant.matchup,
            ),
          ),
          _useCase(
            'Identity / Hero',
            ParticipantIdentity(
              participant: previewParticipants.first,
              artworkVariant: FighterArtworkVariant.hero,
            ),
          ),
          _useCase(
            'Match card / Current',
            TournamentMatchCard(
              title: 'Матч 07 · Верхняя сетка',
              first: previewParticipants.first,
              second: previewParticipants[1],
              isCurrent: true,
            ),
          ),
          _useCase(
            'Tournament summary / Active',
            TournamentSummary(
              tournamentName: 'Friday Fight Night',
              stage: 'Double Elimination · Верхняя сетка · Раунд 2',
              first: previewParticipants.first,
              second: previewParticipants[1],
              onContinue: () {},
            ),
          ),
          _useCase(
            'Outcome picker',
            OutcomePicker(
              first: previewParticipants.first,
              second: previewParticipants[1],
              onFirstSelected: () {},
              onSecondSelected: () {},
            ),
          ),
          _useCase(
            'Champion hero',
            ChampionHero(champion: previewParticipants.first),
          ),
          _useCase(
            'Identity / Missing artwork',
            const ParticipantIdentity(
              participant: PreviewParticipant(
                nickname: 'Очень длинный никнейм участника',
                fighterId: 'missing-fighter',
                fighterName: 'Неизвестный боец',
              ),
              artworkVariant: FighterArtworkVariant.standard,
            ),
          ),
          _useCase(
            'Standings',
            TournamentStandings(participants: previewParticipants),
          ),
          _useCase('Bracket', const TournamentBracketPreview()),
          _useCase('Confirmation', const TournamentConfirmationPreview()),
        ],
      ),
    ],
  ),
  WidgetbookCategory(
    name: 'Screens',
    children: [
      WidgetbookComponent(
        name: 'Application cycle',
        useCases: [
          for (final screen in ScreenPreviewKind.values)
            WidgetbookUseCase(
              name: screen.catalogName,
              builder: (_) => TournamentScreenPreview(kind: screen),
            ),
        ],
      ),
    ],
  ),
];

WidgetbookUseCase _useCase(String name, Widget child) => WidgetbookUseCase(
  name: name,
  builder: (_) => SingleChildScrollView(child: DsPagePadding(child: child)),
);
