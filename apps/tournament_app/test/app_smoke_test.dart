import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/main.dart';

void main() {
  testWidgets('показывает стартовый экран приложения', (tester) async {
    await tester.pumpWidget(const TournamentHubApp());

    expect(find.text('Tournament Hub'), findsOneWidget);
  });
}
