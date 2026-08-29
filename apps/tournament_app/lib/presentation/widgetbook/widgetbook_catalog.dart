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
        name: 'Page header',
        useCases: [
          _useCase(
            'Standard',
            PageHeader(
              sectionLabel: 'HOST · RUNNING',
              title: 'Friday Fight Night',
              subtitle: 'Double Elimination · Верхняя сетка',
              trailing: const StatusBadge(
                label: 'LIVE',
                kind: StatusKind.warning,
              ),
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
                  DsAction(
                    label: 'Destructive',
                    kind: DsActionKind.danger,
                    onPressed: () {},
                  ),
                  const DsAction(label: 'Disabled'),
                  const DsTextField(label: 'Tournament name'),
                ],
              ),
            ),
          ),
          WidgetbookUseCase(
            name: 'Responsive hierarchy',
            builder: (_) => DsPagePadding(
              child: ResponsiveActions(
                primary: DsAction(label: 'Продолжить', onPressed: () {}),
                secondary: [
                  DsAction(
                    label: 'Сохранить черновик',
                    kind: DsActionKind.secondary,
                    onPressed: () {},
                  ),
                ],
                destructive: DsAction(
                  label: 'Удалить',
                  kind: DsActionKind.danger,
                  onPressed: () {},
                ),
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
            'History snapshot / Finished',
            HistorySnapshotCard(
              tournamentName: 'Friday Fight Night',
              summary: 'Double Elimination · 8 участников · сегодня, 22:14',
              champion: previewParticipants.first,
              onOpen: () {},
            ),
          ),
          _useCase(
            'Connection / Connected',
            const ConnectionBanner(
              message: 'Подключено · данные актуальны',
              kind: StatusKind.success,
            ),
          ),
          _useCase(
            'Connection / Reconnecting',
            ConnectionBanner(
              message: 'Переподключение к хосту',
              kind: StatusKind.info,
              actionLabel: 'Отменить',
              onAction: () {},
            ),
          ),
          _useCase(
            'Connection / Stale',
            ConnectionBanner(
              message: 'Связь потеряна · показаны последние данные',
              kind: StatusKind.warning,
              actionLabel: 'Переподключиться',
              onAction: () {},
            ),
          ),
          _useCase(
            'Connection / Incompatible',
            ConnectionBanner(
              message: 'Несовместимая версия протокола',
              kind: StatusKind.danger,
              actionLabel: 'Проверить снова',
              onAction: () {},
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
            'Profile summary',
            const ProfileSummary(
              nickname: 'Очень длинный никнейм локального игрока',
              tournaments: 12,
              victories: 4,
            ),
          ),
          _useCase(
            'Danger zone',
            DangerZone(
              title: 'Сброс локальных данных',
              message: 'Профиль, активный турнир и история будут удалены с устройства.',
              actionLabel: 'Сбросить данные',
              onAction: () {},
            ),
          ),
          _useCase(
            'Empty tournament state',
            TournamentEmptyState(
              title: 'Арена пока пуста',
              message:
                  'Создай первый турнир или присоединись к локальной игре.',
              actionLabel: 'Создать турнир',
              onAction: () {},
            ),
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
          _useCase(
            'Structure / Double Elimination',
            const TournamentBracketPreview(),
          ),
          _useCase(
            'Structure / Single Elimination',
            const TournamentBracketPreview(
              format: TournamentStructureFormat.singleElimination,
            ),
          ),
          _useCase(
            'Structure / Round Robin',
            const TournamentBracketPreview(
              format: TournamentStructureFormat.roundRobin,
            ),
          ),
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
