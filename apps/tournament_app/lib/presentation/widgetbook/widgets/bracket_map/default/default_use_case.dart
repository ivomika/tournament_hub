import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_map/app_bracket_map.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_node.dart';

final bracketMapDefaultUseCase = WidgetbookUseCase(
  name: 'prepared diagram',
  builder: BracketMapDefaultUseCase.build,
);

abstract final class BracketMapDefaultUseCase {
  static Widget build(BuildContext context) => const BracketMapFixture();
}

class BracketMapFixture extends StatefulWidget {
  const BracketMapFixture({super.key});
  @override
  State<BracketMapFixture> createState() => _BracketMapFixtureState();
}

class _BracketMapFixtureState extends State<BracketMapFixture> {
  final controller = TransformationController();
  static void action() {}
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppBracketMap(
    controller: controller,
    diagram: AppBracketDiagram(
      size: const AppBracketExtent(840, 720),
      nodes: [
        AppBracketMapNode(
          position: const AppBracketPoint(24, 60),
          label: 'W1 · Сейчас',
          first: const AppBracketParticipant(
            primary: 'Sub-Zero',
            secondary: 'Иван',
            initials: 'SZ',
          ),
          second: const AppBracketParticipant(
            primary: 'Scorpion',
            secondary: 'Алексей',
            initials: 'SC',
          ),
          state: AppBracketState.current,
          onPressed: action,
        ),
        AppBracketMapNode(
          position: const AppBracketPoint(304, 140),
          label: 'W3 · Финал',
          first: const AppBracketPlaceholder('Победитель W1'),
          second: const AppBracketPlaceholder('Победитель W2'),
          state: AppBracketState.pending,
          onPressed: action,
        ),
      ],
      edges: const [
        [
          AppBracketPoint(244, 118),
          AppBracketPoint(274, 118),
          AppBracketPoint(274, 198),
          AppBracketPoint(304, 198),
        ],
      ],
      labels: const [],
    ),
  );
}
