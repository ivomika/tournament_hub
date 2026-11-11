import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';
import 'package:tournament_app/domain/tournament/tournament_id.dart';

sealed class NavigationIntent {
  const NavigationIntent();
}

final class OpenProfileIntent extends NavigationIntent {
  const OpenProfileIntent();
}

final class OpenTournamentIntent extends NavigationIntent {
  const OpenTournamentIntent(this.tournamentId);

  final TournamentId tournamentId;
}

final class BackRequestedIntent extends NavigationIntent {
  const BackRequestedIntent();
}

final class BootstrapCompletedIntent extends NavigationIntent {
  const BootstrapCompletedIntent();
}

abstract interface class NavigationIntentSink {
  Future<NavigationFeedback> submit(NavigationIntent intent);
}
