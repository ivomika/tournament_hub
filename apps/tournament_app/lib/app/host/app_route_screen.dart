import 'package:flutter/widgets.dart';

import '../../presentation/design_system/design_system.dart';
import '../../presentation/screens/recoverable_error/recoverable_error_screen.dart';
import '../../presentation/screens/screen_registry.dart';
import '../navigation/models/app_route_id.dart';
import '../navigation/models/app_route_projection.dart';

final class AppRouteScreen extends StatelessWidget {
  const AppRouteScreen({
    required this.projection,
    required this.onDestinationSelected,
    this.onRetry,
    super.key,
  });

  final AppRouteProjection projection;
  final ValueChanged<AppDestination> onDestinationSelected;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final screen = switch (projection.route) {
      AppRouteId.fatalError => const RecoverableErrorScreenPreview(
        isFatal: true,
      ),
      AppRouteId.recoverableError => RecoverableErrorScreenPreview(
        onRetry: onRetry,
      ),
      _ => TournamentScreenPreview(kind: _previewKind(projection.route)),
    };
    return AppNavigationScope(
      onDestinationSelected: onDestinationSelected,
      child: screen,
    );
  }

  ScreenPreviewKind _previewKind(AppRouteId route) => switch (route) {
    AppRouteId.bootstrap => ScreenPreviewKind.bootstrap,
    AppRouteId.registration => ScreenPreviewKind.registration,
    AppRouteId.main => ScreenPreviewKind.main,
    AppRouteId.profile => ScreenPreviewKind.profile,
    AppRouteId.history => ScreenPreviewKind.history,
    AppRouteId.historyDetail => ScreenPreviewKind.historyDetail,
    AppRouteId.settings => ScreenPreviewKind.settings,
    AppRouteId.hostDraft => ScreenPreviewKind.hostDraft,
    AppRouteId.hostOpen => ScreenPreviewKind.hostOpen,
    AppRouteId.hostDistribution => ScreenPreviewKind.hostDistribution,
    AppRouteId.hostRunning => ScreenPreviewKind.hostRunning,
    AppRouteId.hostResultEntry => ScreenPreviewKind.hostResultEntry,
    AppRouteId.hostFinished => ScreenPreviewKind.hostFinished,
    AppRouteId.hostCancelled => ScreenPreviewKind.hostCancelled,
    AppRouteId.joinTournament => ScreenPreviewKind.join,
    AppRouteId.participantLobby => ScreenPreviewKind.participantLobby,
    AppRouteId.participantDistribution =>
      ScreenPreviewKind.participantDistribution,
    AppRouteId.participantRunning => ScreenPreviewKind.participantRunning,
    AppRouteId.participantFinished => ScreenPreviewKind.participantFinished,
    AppRouteId.recoverableError || AppRouteId.fatalError => throw StateError(
      'Error routes are handled before preview mapping.',
    ),
  };
}
