import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/tournament_hub_app.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/profile/domain/exceptions/local_profile_storage_exception.dart';

import '../../../support/fake_local_profile_repository.dart';
import '../../../support/fake_id_generator.dart';
import '../../../support/fake_tournament_repository.dart';

void main() {
  testWidgets('показывает текущий nickname', (tester) async {
    final repository = _repositoryWithProfile();

    await _openProfile(tester, repository);

    expect(find.text('Профиль'), findsOneWidget);
    expect(find.text('Игрок'), findsOneWidget);
  });

  testWidgets('сохраняет новый nickname с прежней identity', (tester) async {
    final repository = _repositoryWithProfile();
    final initialId = repository.profile!.id;
    await _openProfile(tester, repository);

    await tester.tap(find.byTooltip('Изменить nickname'));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), 'Новый игрок');
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    expect(find.text('Новый игрок'), findsOneWidget);
    expect(repository.profile!.id, initialId);
    expect(repository.saveCalls, 1);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Добро пожаловать, Новый игрок!'), findsOneWidget);
  });

  testWidgets('отменяет редактирование без сохранения', (tester) async {
    final repository = _repositoryWithProfile();
    await _openProfile(tester, repository);

    await tester.tap(find.byTooltip('Изменить nickname'));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), 'Не сохранять');
    await tester.tap(find.text('Отмена'));
    await tester.pump();

    expect(find.text('Игрок'), findsOneWidget);
    expect(repository.saveCalls, 0);
  });

  testWidgets('сохраняет введённое значение при ошибке storage', (
    tester,
  ) async {
    final repository = _repositoryWithProfile()
      ..saveError = const LocalProfileStorageException(
        'Не удалось записать профиль.',
      );
    await _openProfile(tester, repository);

    await tester.tap(find.byTooltip('Изменить nickname'));
    await tester.pump();
    await tester.enterText(find.byType(TextFormField), 'Новый игрок');
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    expect(find.text('Не удалось записать профиль.'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller!.text,
      'Новый игрок',
    );
  });

  testWidgets('не сохраняет неизменившийся nickname', (tester) async {
    final repository = _repositoryWithProfile();
    await _openProfile(tester, repository);

    await tester.tap(find.byTooltip('Изменить nickname'));
    await tester.pump();
    await tester.tap(find.text('Сохранить'));
    await tester.pumpAndSettle();

    expect(find.text('Nickname не изменился.'), findsOneWidget);
    expect(repository.saveCalls, 0);
  });

  testWidgets('ограничивает ширину профиля в desktop-окне', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await _openProfile(tester, _repositoryWithProfile());

    expect(tester.getSize(find.byType(Form)).width, lessThanOrEqualTo(560));
    expect(tester.takeException(), isNull);
  });
}

FakeLocalProfileRepository _repositoryWithProfile() {
  return FakeLocalProfileRepository(
    profile: LocalProfile.create(id: 'profile-id', nickname: 'Игрок'),
  );
}

Future<void> _openProfile(
  WidgetTester tester,
  FakeLocalProfileRepository repository,
) async {
  final tournamentRepository = FakeTournamentRepository();
  await tester.pumpWidget(
    TournamentHubApp(
      profileRepository: repository,
      tournamentRepository: tournamentRepository,
      tournamentCompletionRepository: tournamentRepository,
      idGenerator: FakeIdGenerator(),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip('Открыть профиль'));
  await tester.pumpAndSettle();
}
