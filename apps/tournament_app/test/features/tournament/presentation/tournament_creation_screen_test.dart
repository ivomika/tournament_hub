import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/tournament_hub_app.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_storage_exception.dart';

import '../../../support/fake_id_generator.dart';
import '../../../support/fake_local_profile_repository.dart';
import '../../../support/fake_tournament_repository.dart';

void main() {
  testWidgets('показывает обязательный local profile и minimum validation', (
    tester,
  ) async {
    final repository = FakeTournamentRepository();
    await _openCreation(tester, repository);

    expect(find.text('Игрок'), findsOneWidget);
    expect(find.text('Локальный профиль · обязательно'), findsOneWidget);
    expect(
      find.byKey(const Key('minimum-participants-message')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('create-tournament-button')),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('добавляет гостя и сохраняет draft один раз', (tester) async {
    final repository = FakeTournamentRepository();
    await _openCreation(tester, repository);

    await tester.enterText(
      find.byKey(const Key('tournament-name-input')),
      'Кубок дома',
    );
    await _addGuest(tester, 'Гость');
    await tester.tap(find.byKey(const Key('create-tournament-button')));
    await tester.pumpAndSettle();

    expect(repository.draftSaveCalls, 1);
    expect(repository.draft?.name.value, 'Кубок дома');
    expect(repository.draft?.participants, hasLength(2));
    expect(find.text('Кубок дома'), findsOneWidget);
    expect(find.text('Турнир готов'), findsOneWidget);
  });

  testWidgets('переименовывает и удаляет гостя', (tester) async {
    final repository = FakeTournamentRepository();
    await _openCreation(tester, repository);
    await _addGuest(tester, 'Первый');

    await tester.tap(find.byTooltip('Переименовать Первый'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('rename-guest-input')),
      'Второй',
    );
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    expect(find.text('Второй'), findsOneWidget);
    await tester.tap(find.byTooltip('Удалить Второй'));
    await tester.pump();
    expect(find.text('Нужен минимум ещё один игрок.'), findsOneWidget);
  });

  testWidgets('после storage error сохраняет ввод и разрешает повтор', (
    tester,
  ) async {
    final repository = FakeTournamentRepository()
      ..saveError = const TournamentStorageException('База недоступна.');
    await _openCreation(tester, repository);
    await tester.enterText(
      find.byKey(const Key('tournament-name-input')),
      'Турнир',
    );
    await _addGuest(tester, 'Гость');

    await tester.tap(find.byKey(const Key('create-tournament-button')));
    await tester.pumpAndSettle();

    expect(find.text('База недоступна.'), findsOneWidget);
    expect(find.text('Гость'), findsWidgets);
    expect(
      tester
          .widget<TextField>(find.byKey(const Key('tournament-name-input')))
          .controller
          ?.text,
      'Турнир',
    );

    repository.saveError = null;
    await tester.tap(find.byKey(const Key('create-tournament-button')));
    await tester.pumpAndSettle();
    expect(repository.draftSaveCalls, 2);
    expect(repository.draft, isNotNull);
  });

  testWidgets('блокирует повторный submit во время сохранения', (tester) async {
    final completer = Completer<void>();
    final repository = FakeTournamentRepository()..saveCompleter = completer;
    await _openCreation(tester, repository);
    await tester.enterText(
      find.byKey(const Key('tournament-name-input')),
      'Турнир',
    );
    await _addGuest(tester, 'Гость');

    await tester.tap(find.byKey(const Key('create-tournament-button')));
    await tester.pump();

    expect(repository.saveCalls, 1);
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const Key('create-tournament-button')),
          )
          .onPressed,
      isNull,
    );

    completer.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('desktop использует ограниченную wide-композицию без overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await _openCreation(tester, FakeTournamentRepository());

    expect(
      tester
          .getSize(find.byKey(const Key('tournament-creation-content')))
          .width,
      lessThanOrEqualTo(960),
    );
    expect(tester.takeException(), isNull);
  });
}

Future<void> _openCreation(
  WidgetTester tester,
  FakeTournamentRepository tournamentRepository,
) async {
  await tester.pumpWidget(
    TournamentHubApp(
      profileRepository: FakeLocalProfileRepository(
        profile: LocalProfile.create(id: 'local-1', nickname: 'Игрок'),
      ),
      tournamentRepository: tournamentRepository,
      tournamentCompletionRepository: tournamentRepository,
      idGenerator: FakeIdGenerator([
        'guest-1',
        'guest-2',
        'tournament-1',
        'tournament-2',
      ]),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('open-tournament-creation')));
  await tester.pumpAndSettle();
}

Future<void> _addGuest(WidgetTester tester, String nickname) async {
  await tester.enterText(
    find.byKey(const Key('guest-nickname-input')),
    nickname,
  );
  await tester.tap(find.byKey(const Key('add-guest-button')));
  await tester.pump();
}
