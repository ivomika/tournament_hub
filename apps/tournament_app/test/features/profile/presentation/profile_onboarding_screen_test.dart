import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/tournament_hub_app.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/profile/domain/exceptions/local_profile_storage_exception.dart';

import '../../../support/fake_local_profile_repository.dart';
import '../../../support/fake_id_generator.dart';
import '../../../support/fake_tournament_repository.dart';

void main() {
  testWidgets('показывает создание профиля при первом запуске', (tester) async {
    final repository = FakeLocalProfileRepository();

    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(find.text('Создайте профиль'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Игрок');
    await tester.tap(find.text('Продолжить'));
    await tester.pumpAndSettle();

    expect(find.text('Добро пожаловать, Игрок!'), findsOneWidget);
    expect(repository.profile?.nickname.value, 'Игрок');
  });

  testWidgets('пропускает создание для сохранённого профиля', (tester) async {
    final repository = FakeLocalProfileRepository(
      profile: LocalProfile.create(id: 'profile-id', nickname: 'Игрок'),
    );

    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();

    expect(find.text('Создайте профиль'), findsNothing);
    expect(find.text('Добро пожаловать, Игрок!'), findsOneWidget);
  });

  testWidgets('показывает ошибку сохранения и разрешает повтор', (
    tester,
  ) async {
    final repository = FakeLocalProfileRepository(
      saveError: const LocalProfileStorageException('Хранилище недоступно.'),
    );

    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Игрок');
    await tester.tap(find.text('Продолжить'));
    await tester.pumpAndSettle();

    expect(find.text('Хранилище недоступно.'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets('блокирует повторное сохранение', (tester) async {
    final completer = Completer<void>();
    final repository = FakeLocalProfileRepository(saveCompleter: completer);

    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Игрок');
    await tester.tap(find.text('Продолжить'));
    await tester.pump();

    expect(repository.saveCalls, 1);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    completer.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('ограничивает ширину формы в desktop-окне', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_app(FakeLocalProfileRepository()));
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(Form)).width, lessThanOrEqualTo(440));
    expect(tester.takeException(), isNull);
  });
}

TournamentHubApp _app(FakeLocalProfileRepository repository) {
  final tournamentRepository = FakeTournamentRepository();
  return TournamentHubApp(
    profileRepository: repository,
    tournamentRepository: tournamentRepository,
    tournamentCompletionRepository: tournamentRepository,
    idGenerator: FakeIdGenerator(),
  );
}
