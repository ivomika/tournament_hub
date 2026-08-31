import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/application/spectator/spectator_projection_factory.dart';
import 'package:tournament_hub_app/application/tournament/models/host_tournament_projection.dart';

void main() {
  test('строит allowlist projection с opaque participant IDs', () {
    const source = HostTournamentProjection(
      id: 't-1',
      title: 'Friday Fight',
      formatId: 'single-elimination',
      lifecycle: 'running',
      revision: 7,
      sequence: 7,
      participants: [
        HostParticipantProjection(
          id: 'profile:private-profile-id',
          nickname: 'Иван',
          isGuest: false,
          fighterId: 'scorpion',
          fighterName: 'Scorpion',
          fighterAssetPath: 'assets/fighters/scorpion.png',
        ),
        HostParticipantProjection(
          id: 'guest:private-guest-id',
          nickname: 'Гость',
          isGuest: true,
        ),
      ],
      matches: [
        HostMatchProjection(
          id: 'm-1',
          round: 1,
          order: 0,
          stage: 'main',
          status: 'finished',
          firstTo: 1,
          firstParticipantId: 'profile:private-profile-id',
          secondParticipantId: 'guest:private-guest-id',
          winnerParticipantId: 'profile:private-profile-id',
          loserParticipantId: 'guest:private-guest-id',
          winnerScore: 1,
          loserScore: 0,
        ),
      ],
      ranking: [
        HostPlacementProjection(
          participantId: 'profile:private-profile-id',
          from: 1,
          to: 1,
        ),
      ],
      championId: 'profile:private-profile-id',
    );

    final result = SpectatorProjectionFactory.fromHost(source)!;

    expect(result.participants.map((value) => value.id), [
      'participant-1',
      'participant-2',
    ]);
    expect(result.matches.single.result!.winnerParticipantId, 'participant-1');
    expect(result.championParticipantId, 'participant-1');
    expect(result.participants.first.fighter!.assetPath, contains('scorpion'));
  });

  test('не публикует draft, open и cancelled lifecycle', () {
    for (final lifecycle in ['draft', 'open', 'cancelled']) {
      final source = HostTournamentProjection(
        id: 't-1',
        title: 'Tournament',
        formatId: 'round-robin',
        lifecycle: lifecycle,
        revision: 1,
        sequence: 0,
        participants: const [],
        matches: const [],
        ranking: const [],
      );
      expect(SpectatorProjectionFactory.fromHost(source), isNull);
    }
  });
}
