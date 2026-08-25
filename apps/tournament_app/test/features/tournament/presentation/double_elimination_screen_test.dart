import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/fighters/data/repositories/mk11_ultimate_fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/bundled_fighter_avatar_resolver.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/application/double_elimination_conduct_controller.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_bracket.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/services/double_elimination_topology_generator.dart';
import 'package:tournament_app/features/tournament/domain/services/random_index_generator.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_match_status.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';
import 'package:tournament_app/features/tournament/presentation/double_elimination_screen.dart';

import '../../../support/fake_double_elimination_tournament_repository.dart';
import '../../../support/fake_id_generator.dart';

void main() {
  testWidgets('проводит матч и предупреждает о пересчёте при исправлении', (
    tester,
  ) async {
    final repository = FakeDoubleEliminationTournamentRepository();
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(find.text('Верхняя сетка'), findsOneWidget);
    expect(find.text('2:0'), findsNothing);
    await tester.tap(find.text('Победил').first);
    await tester.pumpAndSettle();

    expect(repository.saveCalls, greaterThanOrEqualTo(2));
    expect(find.text('Исправить результат'), findsOneWidget);
    await tester.tap(find.text('Исправить результат'));
    await tester.pumpAndSettle();
    expect(
      find.text('Все зависимые результаты будут удалены, а сетка пересчитана.'),
      findsOneWidget,
    );
  });

  testWidgets('desktop показывает единый список секций без overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_app(FakeDoubleEliminationTournamentRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Верхняя сетка'), findsOneWidget);
    expect(find.text('Нижняя сетка'), findsOneWidget);
    expect(find.byType(TabBar), findsNothing);
    await tester.scrollUntilVisible(
      find.text('Гранд-финал'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Гранд-финал'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('после завершения показывает победителя и итоговые места', (
    tester,
  ) async {
    final repository = FakeDoubleEliminationTournamentRepository();
    final registry = Mk11UltimateFighterRegistry();
    final tournament = _completeTournament(_tournament(registry, 2));
    await tester.pumpWidget(_app(repository, tournament: tournament));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('finish-double-elimination')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('double-elimination-results')), findsOneWidget);
    expect(find.text('Победитель турнира'), findsOneWidget);
    final championAssignment = tournament.fighterAssignments.firstWhere(
      (assignment) => assignment.participantId == tournament.bracket.championId,
    );
    expect(
      find.text(registry.findById(championAssignment.fighterId)!.displayName),
      findsWidgets,
    );
    expect(
      find.text(
        tournament.draft.participants
            .firstWhere(
              (participant) => participant.id == tournament.bracket.championId,
            )
            .nickname
            .value,
      ),
      findsWidgets,
    );
    expect(find.byKey(const Key('finish-double-elimination')), findsNothing);
    expect(repository.finished, hasLength(1));
  });
}

Widget _app(
  FakeDoubleEliminationTournamentRepository repository, {
  DoubleEliminationTournament? tournament,
}) {
  final registry = Mk11UltimateFighterRegistry();
  return MaterialApp(
    theme: ThemeData.dark(useMaterial3: true),
    home: DoubleEliminationScreen(
      controller: DoubleEliminationConductController(
        tournament ?? _tournament(registry),
        repository,
        FakeIdGenerator(),
        registry,
      ),
      fighterRegistry: registry,
      avatarResolver: const BundledFighterAvatarResolver(),
    ),
  );
}

DoubleEliminationTournament _tournament(
  Mk11UltimateFighterRegistry registry, [
  int participantCount = 4,
]) {
  final draft = TournamentDraft(
    id: TournamentId('de-1'),
    name: TournamentName('Локальный DE'),
    format: TournamentFormat.doubleElimination,
    participants: [
      TournamentParticipant.fromLocalProfile(
        LocalProfile.create(id: 'local-1', nickname: 'Владелец'),
      ),
      for (var index = 1; index < participantCount; index++)
        TournamentParticipant.fromGuestProfile(
          GuestProfile.create(id: 'guest-$index', nickname: 'Гость $index'),
        ),
    ],
  );
  return DoubleEliminationTournament(
    draft: draft,
    fighterAssignments: [
      for (final (index, participant) in draft.participants.indexed)
        FighterAssignment(
          participantId: participant.id,
          fighterId: registry.fighters[index].id,
        ),
    ],
    bracket: DoubleEliminationBracket(
      topology: DoubleEliminationTopologyGenerator(_PredictableRandom())
          .generate(draft.participants.map((participant) => participant.id)),
    ),
  );
}

DoubleEliminationTournament _completeTournament(
  DoubleEliminationTournament tournament,
) {
  var result = tournament;
  var update = 0;
  while (!result.bracket.isCompleted) {
    final match = result.bracket.matches.firstWhere(
      (item) => item.status == BracketMatchStatus.ready,
    );
    result = result.recordBracketResult(
      matchId: match.definition.id,
      winnerId: match.firstParticipantId!,
      updateId: MatchUpdateId('finish-${++update}'),
    );
  }
  return result;
}

final class _PredictableRandom implements RandomIndexGenerator {
  @override
  int nextInt(int upperBound) => upperBound - 1;
}
