import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/host_draft/host_draft_screen.dart';

void main() {
  testWidgets('Draft сохраняет название и выбранный режим перед Open', (
    tester,
  ) async {
    String? savedTitle;
    String? savedFormat;
    var opened = false;
    await tester.pumpWidget(
      _app(
        HostDraftScreenPreview(
          onSave: ({required title, required formatId}) async {
            savedTitle = title;
            savedFormat = formatId;
          },
          onOpen: () async => opened = true,
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('draft-title')), 'Local Cup');
    await tester.tap(find.byKey(const Key('draft-format')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Round Robin').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('save-and-open-draft')));
    await tester.tap(find.byKey(const Key('save-and-open-draft')));
    await tester.pumpAndSettle();

    expect(savedTitle, 'Local Cup');
    expect(savedFormat, 'round-robin');
    expect(opened, isTrue);
  });

  testWidgets('Draft сохраняет прежнюю линейную композицию', (tester) async {
    await tester.pumpWidget(_app(const HostDraftScreenPreview()));

    expect(find.byType(PageLayout), findsNothing);
    expect(find.text('Параметры'), findsOneWidget);
    expect(find.byType(DsSelect<String>), findsOneWidget);
    expect(find.text('Черновик'), findsOneWidget);
  });

  testWidgets('Draft показывает безопасную ошибку и не открывает лобби', (
    tester,
  ) async {
    var opened = false;
    await tester.pumpWidget(
      _app(
        HostDraftScreenPreview(
          onSave: ({required title, required formatId}) async {
            throw StateError('raw storage details');
          },
          onOpen: () async => opened = true,
        ),
      ),
    );

    await tester.ensureVisible(find.byKey(const Key('save-and-open-draft')));
    await tester.tap(find.byKey(const Key('save-and-open-draft')));
    await tester.pumpAndSettle();

    expect(opened, isFalse);
    expect(
      find.text('Не удалось сохранить черновик. Попробуйте ещё раз.'),
      findsOneWidget,
    );
    expect(find.textContaining('raw storage'), findsNothing);
  });
}

Widget _app(Widget child) =>
    MaterialApp(theme: TournamentTheme.dark, home: child);
