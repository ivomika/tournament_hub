import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/screen_registry.dart';
import 'package:tournament_hub_app/presentation/widgetbook/widgetbook_catalog.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  test('catalog содержит каждый Flutter screen preview', () {
    final useCaseNames = <String>{};

    void collect(Iterable<WidgetbookNode> nodes) {
      for (final node in nodes) {
        if (node is WidgetbookUseCase) useCaseNames.add(node.name);
        collect(node.children ?? const []);
      }
    }

    collect(buildTournamentCatalog());

    expect(
      useCaseNames,
      containsAll(ScreenPreviewKind.values.map((screen) => screen.catalogName)),
    );
  });

  testWidgets('Widgetbook запускается отдельным entry tree', (tester) async {
    await tester.pumpWidget(const TournamentWidgetbook());
    await tester.pump();

    expect(find.byType(Widgetbook), findsOneWidget);
  });

  testWidgets('все screen previews строятся на mobile и desktop', (
    tester,
  ) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1;

    for (final size in const [
      Size(320, 720),
      Size(599, 959),
      Size(1280, 960),
    ]) {
      tester.view.physicalSize = size;
      for (final kind in ScreenPreviewKind.values) {
        await tester.pumpWidget(
          MaterialApp(
            theme: TournamentTheme.dark,
            home: TournamentScreenPreview(kind: kind),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '${kind.name} at $size');
      }
    }
  });

  testWidgets('identity показывает персонажа и участника', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: ParticipantIdentity(participant: previewParticipants.first),
        ),
      ),
    );

    expect(find.text('Scorpion'), findsOneWidget);
    expect(find.text('Иван'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('fighter artwork variants задают визуальную иерархию', (
    tester,
  ) async {
    const compactKey = Key('compact-artwork');
    const heroKey = Key('hero-artwork');
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                FighterAvatar(
                  key: compactKey,
                  fighterId: 'scorpion',
                  fighterName: 'Scorpion',
                  variant: FighterArtworkVariant.compact,
                ),
                FighterAvatar(
                  key: heroKey,
                  fighterId: 'scorpion',
                  fighterName: 'Scorpion',
                  variant: FighterArtworkVariant.hero,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsNWidgets(2));
    expect(
      tester.getSize(find.byKey(heroKey)).width,
      greaterThan(tester.getSize(find.byKey(compactKey)).width),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('missing fighter artwork показывает fallback', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(
          body: FighterAvatar(
            fighterId: 'missing-fighter',
            fighterName: 'Unknown Fighter',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.sports_martial_arts), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('current match artwork крупнее bracket representation', (
    tester,
  ) async {
    const currentKey = Key('current-match');
    const bracketKey = Key('bracket-match');
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                TournamentMatchCard(
                  key: currentKey,
                  title: 'Current',
                  first: previewParticipants.first,
                  second: previewParticipants[1],
                  isCurrent: true,
                ),
                TournamentMatchCard(
                  key: bracketKey,
                  title: 'Bracket',
                  first: previewParticipants.first,
                  second: previewParticipants[1],
                  identityVariant: FighterArtworkVariant.compact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final currentArtwork = find
        .descendant(
          of: find.byKey(currentKey),
          matching: find.byType(FighterAvatar),
        )
        .first;
    final bracketArtwork = find
        .descendant(
          of: find.byKey(bracketKey),
          matching: find.byType(FighterAvatar),
        )
        .first;
    expect(
      tester.getSize(currentArtwork).width,
      greaterThan(tester.getSize(bracketArtwork).width),
    );
  });

  testWidgets('token showcase не переполняет compact viewport', (tester) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 480);

    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(body: TokenShowcase()),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}
