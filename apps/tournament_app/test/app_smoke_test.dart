import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/app/composition/app_composition.dart';
import 'package:tournament_hub_app/app/host/tournament_hub_app.dart';

void main() {
  testWidgets('показывает стартовый экран приложения', (tester) async {
    await tester.pumpWidget(
      TournamentHubApp(runtime: AppComposition.production()),
    );

    expect(find.text('Tournament Hub'), findsOneWidget);
  });
}
