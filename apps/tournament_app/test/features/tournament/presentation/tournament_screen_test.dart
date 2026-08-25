import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/fighters/data/repositories/mk11_ultimate_fighter_registry.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/bundled_fighter_avatar_resolver.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/standings/domain/services/mvp_tournament_ruleset.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/application/start_tournament.dart';
import 'package:tournament_app/features/tournament/application/update_active_tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/services/round_robin_tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_screen.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_conduct_controller.dart';

import '../../../support/fake_id_generator.dart';
import '../../../support/fake_tournament_repository.dart';

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
    await tester.scrollUntilVisible(find.byKey(const ValueKey('round-2')), 300);
    expect(find.byKey(const ValueKey('round-2')), findsOneWidget);
    await tester.scrollUntilVisible(find.byKey(const ValueKey('round-3')), 300);
    expect(find.byKey(const ValueKey('round-3')), findsOneWidget);
    expect(find.byKey(const ValueKey('round-3-bye')), findsOneWidget);
    expect(find.text('Пропускает раунд'), findsWidgets);
  });

  testWidgets('чётные раунды не показывают bye', (tester) async {
    final draft = _draft(4);
    await _pumpTournament(tester, draft, fighterRegistry);

    await tester.tap(find.byKey(const Key('open-tournament-rounds')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('round-1')), findsOneWidget);
    await tester.scrollUntilVisible(find.byKey(const ValueKey('round-2')), 300);
    expect(find.byKey(const ValueKey('round-2')), findsOneWidget);
    await tester.scrollUntilVisible(find.byKey(const ValueKey('round-3')), 300);
    expect(find.byKey(const ValueKey('round-3')), findsOneWidget);
    expect(find.text('Пропускает раунд'), findsNothing);
  });

  testWidgets('выбирает победителя схватки и исправляет итог', (tester) async {
    await _pumpTournament(tester, _draft(2), fighterRegistry);
    await tester.tap(find.byKey(const Key('open-tournament-rounds')));
    await tester.pumpAndSettle();
    const firstWinner = ValueKey('record-bout-round-1-match-1-local-1');

    await tester.tap(find.byKey(firstWinner));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('match-score-round-1-match-1')),
      findsOneWidget,
    );
    expect(find.text('1 : 0'), findsOneWidget);

    await tester.tap(find.byKey(firstWinner));
    await tester.pumpAndSettle();
    expect(find.text('2 : 0'), findsOneWidget);
    expect(find.text('Матч завершён'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('correct-match-round-1-match-1')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Итог 0:2'));
    await tester.pumpAndSettle();
    expect(find.text('0 : 2'), findsOneWidget);
  });

  testWidgets('ошибка сохранения не меняет счёт и разрешает retry', (
    tester,
  ) async {
    final repository = await _pumpTournament(
      tester,
      _draft(2),
      fighterRegistry,
    );
    await tester.tap(find.byKey(const Key('open-tournament-rounds')));
    await tester.pumpAndSettle();
    repository.saveError = StateError('Нет записи');
    const button = ValueKey('record-bout-round-1-match-1-local-1');

    await tester.tap(find.byKey(button));
    await tester.pumpAndSettle();
    expect(find.text('0 : 0'), findsOneWidget);
    expect(find.byKey(const Key('match-save-error')), findsOneWidget);

    repository.saveError = null;
    await tester.tap(find.byKey(button));
    await tester.pumpAndSettle();
    expect(find.text('1 : 0'), findsOneWidget);
  });

  testWidgets('проходит от матча до итогов и экрана чемпиона', (tester) async {
    final repository = await _pumpTournament(
      tester,
      _draft(2),
      fighterRegistry,
    );
    await tester.tap(find.byKey(const Key('open-tournament-rounds')));
    await tester.pumpAndSettle();
    const winnerButton = ValueKey('record-bout-round-1-match-1-local-1');
    await tester.tap(find.byKey(winnerButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(winnerButton));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('open-tournament-results')),
      300,
    );
    await tester.tap(find.byKey(const Key('open-tournament-results')));
    await tester.pumpAndSettle();

    expect(find.text('Итоги готовы'), findsOneWidget);
    expect(find.byKey(const ValueKey('standing-local-1')), findsOneWidget);
    expect(find.text('3'), findsWidgets);

    await tester.tap(find.byKey(const Key('finish-tournament-button')));
    await tester.pumpAndSettle();
    expect(repository.finishedTournamentSaveCalls, 1);
    expect(repository.activeTournament, isNull);
    expect(find.text('Чемпион'), findsOneWidget);
    expect(find.byKey(const Key('champion-nickname')), findsOneWidget);
    expect(find.text('Владелец'), findsOneWidget);
    expect(find.text('Baraka'), findsOneWidget);
  });

  testWidgets('ошибка завершения оставляет итоги и разрешает повтор', (
    tester,
  ) async {
    final repository = await _pumpTournament(
      tester,
      _draft(2),
      fighterRegistry,
    );
    await tester.tap(find.byKey(const Key('open-tournament-rounds')));
    await tester.pumpAndSettle();
    const winnerButton = ValueKey('record-bout-round-1-match-1-local-1');
    await tester.tap(find.byKey(winnerButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(winnerButton));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('open-tournament-results')),
      300,
    );
    await tester.tap(find.byKey(const Key('open-tournament-results')));
    await tester.pumpAndSettle();
    repository.saveError = StateError('Нет записи');

    await tester.tap(find.byKey(const Key('finish-tournament-button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('tournament-finish-error')), findsOneWidget);
    expect(find.text('Чемпион'), findsNothing);

    repository.saveError = null;
    await tester.tap(find.byKey(const Key('finish-tournament-button')));
    await tester.pumpAndSettle();
    expect(find.text('Чемпион'), findsOneWidget);
  });

  testWidgets('после перезапуска открывает сохранённые итоги без пересчёта', (
    tester,
  ) async {
    final draft = _draft(2);
    final repository = await _pumpTournament(tester, draft, fighterRegistry);
    await tester.tap(find.byKey(const Key('open-tournament-rounds')));
    await tester.pumpAndSettle();
    const winnerButton = ValueKey('record-bout-round-1-match-1-local-1');
    await tester.tap(find.byKey(winnerButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(winnerButton));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('open-tournament-results')),
      300,
    );
    await tester.tap(find.byKey(const Key('open-tournament-results')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('finish-tournament-button')));
    await tester.pumpAndSettle();

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await _pumpTournament(
      tester,
      draft,
      fighterRegistry,
      repository: repository,
    );

    expect(find.text('Турнир завершён'), findsOneWidget);
    expect(find.text('Показать итоги'), findsOneWidget);
    await tester.tap(find.byKey(const Key('open-tournament-rounds')));
    await tester.pumpAndSettle();
    expect(find.text('Итоги готовы'), findsOneWidget);
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

Future<FakeTournamentRepository> _pumpTournament(
  WidgetTester tester,
  TournamentDraft draft,
  FighterRegistry fighterRegistry, {
  FakeTournamentRepository? repository,
}) async {
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

  final resolvedRepository = repository ?? FakeTournamentRepository();
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: TournamentScreen(
        draft: draft,
        setup: setup,
        fighterRegistry: fighterRegistry,
        avatarResolver: const BundledFighterAvatarResolver(),
        controller: TournamentConductController(
          StartTournament(resolvedRepository),
          UpdateActiveTournamentMatch(resolvedRepository),
          resolvedRepository,
          FakeIdGenerator([
            for (var index = 0; index < 20; index++) 'update-$index',
          ]),
          ruleset: MvpTournamentRuleset.instance,
          draft: draft,
          setup: setup,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return resolvedRepository;
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
