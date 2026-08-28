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
            'Match card',
            TournamentMatchCard(
              title: 'Round 1',
              first: previewParticipants.first,
              second: previewParticipants[1],
              score: '2:1',
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
  builder: (_) => DsPagePadding(child: child),
);
