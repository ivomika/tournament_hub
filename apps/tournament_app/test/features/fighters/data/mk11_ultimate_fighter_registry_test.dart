import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/fighters/data/repositories/mk11_ultimate_fighter_registry.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';

void main() {
  late Mk11UltimateFighterRegistry registry;

  setUp(() => registry = Mk11UltimateFighterRegistry());

  test('содержит полный детерминированный roster MK11 Ultimate', () {
    expect(registry.fighters, hasLength(37));
    expect(registry.fighters.first.displayName, 'Baraka');
    expect(registry.fighters.last.displayName, 'Rambo');

    final ids = registry.fighters.map((fighter) => fighter.id.value).toSet();
    final avatarIds = registry.fighters
        .map((fighter) => fighter.avatarId.value)
        .toSet();
    expect(ids, hasLength(37));
    expect(avatarIds, hasLength(37));
    expect(ids, avatarIds);
  });

  test('находит бойца по ID и возвращает null для неизвестного', () {
    expect(registry.findById(FighterId('sub-zero'))?.displayName, 'Sub-Zero');
    expect(registry.findById(FighterId('missing')), isNull);
  });

  test('список нельзя изменить снаружи', () {
    expect(() => registry.fighters.clear(), throwsUnsupportedError);
  });
}
