import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/app/host/app_route_screen.dart';
import 'package:tournament_hub_app/app/lifecycle/app_state.dart';
import 'package:tournament_hub_app/app/navigation/models/app_route_id.dart';
import 'package:tournament_hub_app/app/navigation/models/app_route_projection.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';

void main() {
  testWidgets('recoverable route предоставляет только explicit retry', (
    tester,
  ) async {
    var retries = 0;

    await tester.pumpWidget(
      _TestApp(
        child: AppRouteScreen(
          projection: const AppRouteProjection(
            route: AppRouteId.recoverableError,
            problem: AppProblemCode.profileReadFailed,
          ),
          onDestinationSelected: (_) {},
          onRetry: () => retries++,
        ),
      ),
    );
    await tester.tap(find.text('Проверить снова'));

    expect(retries, 1);
  });

  testWidgets('fatal route не предлагает retry или внутренние детали', (
    tester,
  ) async {
    await tester.pumpWidget(
      _TestApp(
        child: AppRouteScreen(
          projection: const AppRouteProjection(
            route: AppRouteId.fatalError,
            problem: AppProblemCode.unexpectedFailure,
          ),
          onDestinationSelected: (_) {},
        ),
      ),
    );

    expect(find.text('Не удалось запустить приложение'), findsOneWidget);
    expect(find.text('Проверить снова'), findsNothing);
    expect(find.textContaining('Exception'), findsNothing);
  });
}

final class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MaterialApp(
    themeMode: ThemeMode.dark,
    darkTheme: TournamentTheme.dark,
    home: child,
  );
}
