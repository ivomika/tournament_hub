import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/fighters/data/repositories/mk11_ultimate_fighter_registry.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/bundled_fighter_avatar_resolver.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/services/round_robin_tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_screen.dart';

void main() {
  late FighterRegistry fighterRegistry;

  setUp(() {
    fighterRegistry = Mk11UltimateFighterRegistry();
  });

  testWidgets('показывает обзор, назначения и avatars участников', (
    tester,
  ) async {
    final draft = _draft(3);
    await _pumpTournament(tester, draft, fighterRegistry);

    expect(find.text('Кубок дома'), findsOneWidget);
    expect(find.text('Турнир готов'), findsOneWidget);
    expect(find.text('Участников'), findsOneWidget);
    expect(find.text('Раундов'), findsOneWidget);
    expect(find.text('Владелец'), findsOneWidget);
    expect(find.text('Гость 1'), findsOneWidget);
    expect(find.text('Гость 2'), findsOneWidget);
    expect(find.text('Baraka'), findsOneWidget);
    expect(find.text('Cassie Cage'), findsOneWidget);
    expect(find.text('Cetrion'), findsOneWidget);
    expect(find.byKey(const ValueKey('fighter-avatar-baraka')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('fighter-avatar-cassie-cage')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('fighter-avatar-cetrion')),
      findsOneWidget,
    );
  });

  testWidgets('открывает нечётные раунды с матчами и bye', (tester) async {
    final draft = _draft(3);
    await _pumpTournament(tester, draft, fighterRegistry);

    await tester.tap(find.byKey(const Key('open-tournament-rounds')));
    await tester.pumpAndSettle();

    expect(find.text('Раунды'), findsOneWidget);
    expect(find.byKey(const ValueKey('round-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('round-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('round-3')), findsOneWidget);
    expect(find.byKey(const ValueKey('round-1-bye')), findsOneWidget);
    expect(find.byKey(const ValueKey('round-2-bye')), findsOneWidget);
    expect(find.byKey(const ValueKey('round-3-bye')), findsOneWidget);
    expect(find.textContaining('Пропускает раунд:'), findsNWidgets(3));
  });

  testWidgets('чётные раунды не показывают bye', (tester) async {
    final draft = _draft(4);
    await _pumpTournament(tester, draft, fighterRegistry);

    await tester.tap(find.byKey(const Key('open-tournament-rounds')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('round-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('round-2')), findsOneWidget);
    expect(find.byKey(const ValueKey('round-3')), findsOneWidget);
    expect(find.textContaining('Пропускает раунд:'), findsNothing);
  });

  testWidgets('phone и desktop layout не создают overflow', (tester) async {
    final draft = _draft(4);

    await tester.binding.setSurfaceSize(const Size(320, 700));
    await _pumpTournament(tester, draft, fighterRegistry);
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(const Size(1200, 800));
    await tester.pumpAndSettle();
    expect(
      tester
          .getSize(find.byKey(const Key('tournament-overview-content')))
          .width,
      lessThanOrEqualTo(960),
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('open-tournament-rounds')));
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byKey(const Key('tournament-rounds-content'))).width,
      lessThanOrEqualTo(960),
    );
    expect(tester.takeException(), isNull);
    addTearDown(() => tester.binding.setSurfaceSize(null));
  });
}

Future<void> _pumpTournament(
  WidgetTester tester,
  TournamentDraft draft,
  FighterRegistry fighterRegistry,
) {
  final participantIds = draft.participants.map(
    (participant) => participant.id,
  );
  final schedule = const RoundRobinTournamentRules().createSchedule(
    participantIds,
  );
  final fighters = fighterRegistry.fighters.take(draft.participants.length);
  final assignments = draft.participants.indexed.map(
    (entry) => FighterAssignment(
      participantId: entry.$2.id,
      fighterId: fighters.elementAt(entry.$1).id,
    ),
  );
  final setup = TournamentSetup(
    tournamentId: draft.id,
    schedule: schedule,
    fighterAssignments: assignments,
  );

  return tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: TournamentScreen(
        draft: draft,
        setup: setup,
        fighterRegistry: fighterRegistry,
        avatarResolver: const BundledFighterAvatarResolver(),
      ),
    ),
  );
}

TournamentDraft _draft(int participantCount) {
  final participants = <TournamentParticipant>[
    TournamentParticipant.fromLocalProfile(
      LocalProfile.create(id: 'local-1', nickname: 'Владелец'),
    ),
    for (var index = 1; index < participantCount; index++)
      TournamentParticipant.fromGuestProfile(
        GuestProfile.create(id: 'guest-$index', nickname: 'Гость $index'),
      ),
  ];
  return TournamentDraft(
    id: TournamentId('tournament-1'),
    name: TournamentName('Кубок дома'),
    participants: participants,
  );
}
