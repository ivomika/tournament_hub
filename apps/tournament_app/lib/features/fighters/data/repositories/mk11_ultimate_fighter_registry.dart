import 'package:tournament_app/features/fighters/domain/entities/fighter.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_avatar_id.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';

final class Mk11UltimateFighterRegistry implements FighterRegistry {
  Mk11UltimateFighterRegistry() : _fighters = _buildFighters();

  final List<Fighter> _fighters;

  @override
  List<Fighter> get fighters => _fighters;

  @override
  Fighter? findById(FighterId id) {
    for (final fighter in _fighters) {
      if (fighter.id == id) return fighter;
    }
    return null;
  }

  static List<Fighter> _buildFighters() {
    const records = <(String, String)>[
      ('baraka', 'Baraka'),
      ('cassie-cage', 'Cassie Cage'),
      ('cetrion', 'Cetrion'),
      ('dvorah', "D'Vorah"),
      ('erron-black', 'Erron Black'),
      ('frost', 'Frost'),
      ('geras', 'Geras'),
      ('jacqui-briggs', 'Jacqui Briggs'),
      ('jade', 'Jade'),
      ('jax-briggs', 'Jax Briggs'),
      ('johnny-cage', 'Johnny Cage'),
      ('kabal', 'Kabal'),
      ('kano', 'Kano'),
      ('kitana', 'Kitana'),
      ('kollector', 'Kollector'),
      ('kotal-kahn', 'Kotal Kahn'),
      ('kung-lao', 'Kung Lao'),
      ('liu-kang', 'Liu Kang'),
      ('noob-saibot', 'Noob Saibot'),
      ('raiden', 'Raiden'),
      ('scorpion', 'Scorpion'),
      ('shao-kahn', 'Shao Kahn'),
      ('skarlet', 'Skarlet'),
      ('sonya-blade', 'Sonya Blade'),
      ('sub-zero', 'Sub-Zero'),
      ('shang-tsung', 'Shang Tsung'),
      ('nightwolf', 'Nightwolf'),
      ('sindel', 'Sindel'),
      ('terminator-t800', 'Terminator T-800'),
      ('joker', 'The Joker'),
      ('spawn', 'Spawn'),
      ('fujin', 'Fujin'),
      ('sheeva', 'Sheeva'),
      ('robocop', 'RoboCop'),
      ('mileena', 'Mileena'),
      ('rain', 'Rain'),
      ('rambo', 'Rambo'),
    ];

    final fighters = records
        .map(
          (record) => Fighter(
            id: FighterId(record.$1),
            displayName: record.$2,
            avatarId: FighterAvatarId(record.$1),
          ),
        )
        .toList(growable: false);
    return List.unmodifiable(fighters);
  }
}
