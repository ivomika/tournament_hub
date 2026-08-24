import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/application/create_tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';

import '../../../support/fake_id_generator.dart';
import '../../../support/fake_tournament_repository.dart';

void main() {
  late FakeTournamentRepository repository;
  late CreateTournamentDraft useCase;
  final owner = LocalProfile.create(id: 'local-1', nickname: 'Владелец');

  setUp(() {
    repository = FakeTournamentRepository();
    useCase = CreateTournamentDraft(
      repository,
      FakeIdGenerator(['tournament-1']),
    );
  });

  test('создаёт snapshot и сохраняет его через repository port', () async {
    final draft = await useCase.execute(
      name: '  Кубок дома  ',
      owner: owner,
      guests: [GuestProfile.create(id: 'guest-1', nickname: 'Гость')],
    );

    expect(draft.id.value, 'tournament-1');
    expect(draft.name.value, 'Кубок дома');
    expect(repository.draft, draft);
    expect(repository.saveCalls, 1);
  });

  test('не вызывает repository при невалидном составе', () async {
    await expectLater(
      useCase.execute(name: 'Турнир', owner: owner, guests: const []),
      throwsA(isA<TournamentValidationException>()),
    );
    expect(repository.saveCalls, 0);
  });
}
