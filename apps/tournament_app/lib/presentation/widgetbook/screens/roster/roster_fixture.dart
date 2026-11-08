import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/screens/roster/roster_screen.dart';
import 'package:tournament_app/presentation/screens/roster/roster_screen_state.dart';

class RosterFixture extends StatelessWidget {
  const RosterFixture({super.key});
  static void action() {}
  @override
  Widget build(BuildContext context) => RosterScreen(
    state: RosterScreenState(
      contextLabel: 'Пятничный турнир · 4 гостя',
      guests: [
        RosterGuest(name: 'Иван', initials: 'И', onRemove: action),
        RosterGuest(name: 'Алексей', initials: 'А', onRemove: action),
        RosterGuest(name: 'Мария', initials: 'М', onRemove: action),
        RosterGuest(name: 'Олег', initials: 'О', onRemove: action),
      ],
    ),
    onBack: action,
    onAdd: action,
    onConnect: action,
    onDeal: action,
  );
}
