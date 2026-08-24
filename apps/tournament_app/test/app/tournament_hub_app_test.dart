import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/tournament_hub_app.dart';

void main() {
  testWidgets('показывает стартовый экран приложения', (tester) async {
    await tester.pumpWidget(const TournamentHubApp());

    expect(find.text('TOURNAMENT HUB'), findsOneWidget);
    expect(find.text('Локальная турнирная сессия'), findsOneWidget);
  });
}
