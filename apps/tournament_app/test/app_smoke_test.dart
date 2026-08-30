import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/app/composition/app_composition.dart';
import 'package:tournament_hub_app/app/host/tournament_hub_app.dart';
import 'package:tournament_hub_app/app/lifecycle/app_state.dart';

void main() {
  testWidgets('показывает стартовый экран приложения', (tester) async {
    final runtime = AppComposition.memory();
    await tester.pumpWidget(TournamentHubApp(runtime: runtime));
    await tester.runAsync(() async {
      for (var attempt = 0; attempt < 100; attempt++) {
        if (runtime.appStateSource.current.kind != AppStateKind.bootstrapping) {
          return;
        }
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      throw StateError('Bootstrap did not finish.');
    });
    await tester.pump();

    expect(find.text('Как тебя представить?'), findsOneWidget);
  });
}
