import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../design_system/design_system.dart';
import '../screens/host_open/host_open_screen.dart';
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
              sectionLabel: 'ОРГАНИЗАТОР · ТУРНИР ИДЁТ',
              title: 'Friday Fight Night',
              subtitle: 'Double Elimination · Верхняя сетка',
              trailing: const StatusBadge(
                label: 'ИДЁТ',
                kind: StatusKind.warning,
              ),
            ),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Tournament stage',
        useCases: [
          _useCase(
            'Stage / Panel',
            const TournamentStageHeader(
              stage: 'Верхняя сетка',
              progress: 'МАТЧ 7 ИЗ 15',
              detail: 'Полный stage summary как самостоятельный объект.',
            ),
          ),
          _useCase(
            'Stage / Strip',
            const TournamentStageHeader(
              variant: TournamentStageVariant.strip,
              stage: 'Верхняя сетка',
              progress: 'МАТЧ 7 ИЗ 15',
              detail: 'Компактный контекст рядом с dominant object.',
            ),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Page layouts',
        useCases: [
          for (final preset in PageLayoutPreset.values)
            _useCase('Layout / ${preset.name}', _pageLayoutPreview(preset)),
        ],
      ),
      WidgetbookComponent(
        name: 'Actions and fields',
        useCases: [
          WidgetbookUseCase(
            name: 'Default and disabled',
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
                  const DsTextField(
                    label: 'Название турнира',
                    helperText: 'Отображается участникам',
                  ),
                  const DsTextField(label: 'Код лобби', enabled: false),
                ],
              ),
            ),
          ),
          WidgetbookUseCase(
            name: 'Focus and validation',
            builder: (_) => const DsPagePadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DsTextField(
                    label: 'Никнейм',
                    helperText: 'Так тебя увидят участники',
                    autofocus: true,
                    textInputAction: DsTextInputAction.next,
                  ),
                  DsGap(DsSpace.md),
                  DsTextField(
                    label: 'Код лобби',
                    errorText: 'Проверь код и попробуй снова',
                    textInputAction: DsTextInputAction.done,
                  ),
                ],
              ),
            ),
          ),
          WidgetbookUseCase(
            name: 'Loading and success',
            builder: (_) => DsPagePadding(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const DsTextField(
                    label: 'Проверка кода',
                    status: DsFieldStatus.loading,
                  ),
                  const DsGap(DsSpace.md),
                  const DsTextField(
                    label: 'Никнейм сохранён',
                    status: DsFieldStatus.success,
                  ),
                  const DsGap(DsSpace.md),
                  ResponsiveActions(
                    primary: DsAction(
                      label: 'Подключение',
                      status: DsActionStatus.loading,
                      onPressed: () {},
                    ),
                    secondary: [
                      DsAction(
                        label: 'Сохранено',
                        kind: DsActionKind.secondary,
                        status: DsActionStatus.success,
                        onPressed: () {},
                      ),
                    ],
                  ),
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
        name: 'Confirmation',
        useCases: [
          _useCase('Idle', const TournamentConfirmationPreview()),
          _useCase(
            'Loading',
            const TournamentConfirmationPreview(
              status: TournamentConfirmationStatus.loading,
            ),
          ),
          _useCase(
            'Success',
            const TournamentConfirmationPreview(
              status: TournamentConfirmationStatus.success,
            ),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'QR code',
        useCases: [
          _useCase(
            'QR / Compact',
            const QrCode(
              value: 'http://192.168.1.42:8080',
              semanticLabel: 'QR-код локального подключения.',
              size: QrCodeSize.compact,
            ),
          ),
          _useCase(
            'QR / Standard IPv6',
            const QrCode(
              value: 'http://[fe80::20c:29ff:fe9c:409b]:18080/spectator',
              semanticLabel: 'QR-код локального подключения.',
            ),
          ),
          _useCase(
            'QR / Large Participant',
            const QrCode(
              value: 'http://192.168.1.42:8080/join?role=participant&tournament=demo&code=ABCD-EFGH',
              semanticLabel: 'QR-код подключения участника.',
              size: QrCodeSize.large,
            ),
          ),
          _useCase(
            'QR / Unavailable',
            const QrCode(
              value: 'http://192.168.1.42:8080',
              semanticLabel: 'QR-код локального подключения.',
              state: QrCodeState.unavailable,
            ),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Connection QR card',
        useCases: [
          for (final state in ConnectionQrState.values)
            _useCase(_connectionQrStateName(state), _connectionQrCard(state)),
          _useCase(
            'Long address / Narrow',
            ConnectionQrCard(
              encodedValue: 'http://[fe80::20c:29ff:fe9c:409b]:18080/spectator',
              displayAddress:
                  'http://[fe80::20c:29ff:fe9c:409b]:18080/spectator',
              state: ConnectionQrState.ready,
              onCopyAddress: () {},
              onShare: () {},
            ),
          ),
        ],
      ),
      WidgetbookComponent(
        name: 'Role connection',
        useCases: [
          for (final state in ParticipantInviteState.values)
            _useCase(
              'Participant invite / ${state.name}',
              ParticipantInviteCard(
                data: ParticipantInviteViewData(
                  endpoint: 'http://192.168.1.42:8080',
                  joinCode: 'FIGHT-24',
                  state: state,
                ),
                onCopyCode: () {},
                onCopyAddress: () {},
                onRetry: () {},
              ),
            ),
          for (final state in ParticipantJoinState.values)
            _useCase(
              'Participant join / ${state.name}',
              ParticipantJoinPanel(
                data: ParticipantJoinViewData(
                  state: state,
                  enteredValue: 'http://192.168.1.42:8080',
                ),
                onScan: () {},
                onSubmit: (_) {},
                onRetry: () {},
              ),
            ),
          WidgetbookUseCase(
            name: 'Spectator access / Full screen TV',
            builder: (_) => SpectatorAccessDialog(
              data: const SpectatorAccessViewData(
                endpoint: 'http://192.168.1.42:8080',
                state: ConnectionQrState.ready,
                connectedClients: 2,
              ),
              onClose: () {},
              onCopyAddress: () {},
              onShare: () {},
              onRetry: () {},
            ),
          ),
          for (final state in ConnectionQrState.values.where(
            (state) => state != ConnectionQrState.copied,
          ))
            WidgetbookUseCase(
              name: 'Host Open spectator / ${_hostStateName(state)}',
              builder: (_) => HostOpenScreenPreview(
                spectatorProjection: _hostConnectionProjection(state),
              ),
            ),
        ],
      ),
      WidgetbookComponent(
        name: 'Stress matrix',
        useCases: [
          _useCase(
            'Long Russian copy',
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PageHeader(
                  sectionLabel: 'УЧАСТНИК · ВОССТАНОВЛЕНИЕ СОЕДИНЕНИЯ',
                  title:
                      'Очень длинное название локального турнира выходного дня',
                  subtitle: 'Информация должна переноситься без потери fighter identity и следующего действия.',
                ),
                const DsGap(DsSpace.lg),
                ConnectionBanner(
                  state: TournamentConnectionState.stale,
                  detail: 'Показаны последние данные; изменения временно недоступны.',
                  synchronizedAtLabel: '12 минут назад',
                  onAction: () {},
                ),
                const DsGap(DsSpace.lg),
                ResponsiveActions(
                  primary: DsAction(
                    label: 'Попробовать восстановить подключение',
                    onPressed: () {},
                  ),
                  secondary: [
                    DsAction(
                      label: 'Вернуться на главный экран',
                      kind: DsActionKind.secondary,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          _useCase(
            'Error loading empty',
            const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DsTextField(
                  label: 'Код локального турнира',
                  errorText: 'Проверь код и попробуй снова',
                ),
                DsGap(DsSpace.lg),
                TournamentStandings(state: TournamentStandingsState.loading),
                DsGap(DsSpace.lg),
                TournamentStandings(state: TournamentStandingsState.empty),
              ],
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
            'History snapshot / Comfortable',
            HistorySnapshotCard(
              tournamentName: 'Friday Fight Night',
              summary: 'Double Elimination · 8 участников · сегодня, 22:14',
              champion: previewParticipants.first,
              onOpen: () {},
            ),
          ),
          _useCase(
            'History snapshot / Compact',
            HistorySnapshotCard(
              density: DsDensity.compact,
              tournamentName: 'Friday Fight Night',
              summary: 'Double Elimination · 8 участников · сегодня, 22:14',
              champion: previewParticipants.first,
              onOpen: () {},
            ),
          ),
          _useCase(
            'History snapshot / Presentation',
            HistorySnapshotCard(
              density: DsDensity.presentation,
              tournamentName: 'Friday Fight Night',
              summary: 'Double Elimination · 8 участников · сегодня, 22:14',
              champion: previewParticipants.first,
              onOpen: () {},
            ),
          ),
          _useCase(
            'Connection / Connected',
            const ConnectionBanner(
              state: TournamentConnectionState.connected,
              detail: 'Данные актуальны',
              synchronizedAtLabel: 'только что',
            ),
          ),
          _useCase(
            'Connection / Reconnecting',
            ConnectionBanner(
              state: TournamentConnectionState.reconnecting,
              detail: 'Пытаемся связаться с хостом',
              onAction: () {},
            ),
          ),
          _useCase(
            'Connection / Stale',
            ConnectionBanner(
              state: TournamentConnectionState.stale,
              detail: 'Показаны последние полученные данные',
              synchronizedAtLabel: '2 минуты назад',
              onAction: () {},
            ),
          ),
          _useCase(
            'Connection / Disconnected',
            ConnectionBanner(
              state: TournamentConnectionState.disconnected,
              detail: 'Хост недоступен в локальной сети',
              onAction: () {},
            ),
          ),
          _useCase(
            'Connection / Incompatible',
            ConnectionBanner(
              state: TournamentConnectionState.incompatible,
              detail: 'Обновите приложение на обоих устройствах',
              onAction: () {},
            ),
          ),
          _useCase(
            'Connection / Retrying',
            ConnectionBanner(
              state: TournamentConnectionState.retrying,
              detail: 'Запрос отправлен повторно',
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
            'Standings / Ready with tied and unknown places',
            const TournamentStandings(),
          ),
          _useCase(
            'Standings / Loading',
            const TournamentStandings(state: TournamentStandingsState.loading),
          ),
          _useCase(
            'Standings / Empty',
            const TournamentStandings(state: TournamentStandingsState.empty),
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
          _useCase(
            'Structure / Completed disclosure',
            const TournamentBracketPreview(completedPreviewCount: 1),
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

Widget _pageLayoutPreview(PageLayoutPreset preset) => DsPagePadding(
  child: PageLayout(
    preset: preset,
    primary: const DsSurface(
      tone: DsSurfaceTone.elevated,
      child: DsSection(
        title: 'Главная область',
        child: DsText('Dominant object и основной рабочий контекст.'),
      ),
    ),
    secondary: preset == PageLayoutPreset.focused
        ? null
        : const DsSurface(
            child: DsSection(
              title: 'Контекст',
              child: DsText('Secondary rail без дублирования content.'),
            ),
          ),
    supporting: const DsText(
      'Supporting content следует после основной композиции.',
      variant: DsTextVariant.secondary,
    ),
  ),
);

WidgetbookUseCase _useCase(String name, Widget child) => WidgetbookUseCase(
  name: name,
  builder: (_) => SingleChildScrollView(child: DsPagePadding(child: child)),
);

ConnectionQrCard _connectionQrCard(ConnectionQrState state) => ConnectionQrCard(
  encodedValue: 'http://192.168.1.42:8080',
  displayAddress: 'http://192.168.1.42:8080',
  state: state,
  onCopyAddress: () {},
  onShare: () {},
  onRetry: () {},
);

String _connectionQrStateName(ConnectionQrState state) => switch (state) {
  ConnectionQrState.starting => 'Starting',
  ConnectionQrState.ready => 'Ready',
  ConnectionQrState.reconnecting => 'Reconnecting',
  ConnectionQrState.unavailable => 'Unavailable',
  ConnectionQrState.expired => 'Expired',
  ConnectionQrState.error => 'Error',
  ConnectionQrState.stale => 'Stale',
  ConnectionQrState.copied => 'Copied',
};

String _hostStateName(ConnectionQrState state) => switch (state) {
  ConnectionQrState.starting => 'starting',
  ConnectionQrState.ready => 'serving',
  ConnectionQrState.reconnecting => 'reconnecting',
  ConnectionQrState.stale => 'rebinding',
  ConnectionQrState.unavailable => 'stopped',
  ConnectionQrState.error => 'failed',
  ConnectionQrState.expired => 'expired',
  ConnectionQrState.copied => 'copied',
};

HostOpenConnectionViewData _hostConnectionProjection(
  ConnectionQrState state,
) => HostOpenConnectionViewData(
  state: state,
  connectedSpectators: state == ConnectionQrState.ready ? 2 : 0,
  statusLabel: 'Spectator · ${_hostStateName(state)}',
  detail: 'Готовое состояние Host connection projection.',
  kind: switch (state) {
    ConnectionQrState.ready => StatusKind.success,
    ConnectionQrState.stale || ConnectionQrState.expired => StatusKind.warning,
    ConnectionQrState.error => StatusKind.danger,
    ConnectionQrState.starting ||
    ConnectionQrState.reconnecting => StatusKind.info,
    ConnectionQrState.unavailable ||
    ConnectionQrState.copied => StatusKind.neutral,
  },
  localEndpoint:
      state == ConnectionQrState.unavailable || state == ConnectionQrState.error
      ? null
      : 'http://192.168.1.42:8080',
);
