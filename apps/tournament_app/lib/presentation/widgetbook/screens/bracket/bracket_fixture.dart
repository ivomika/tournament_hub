import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/screens/bracket/bracket_screen.dart';
import 'package:tournament_app/presentation/screens/bracket/bracket_screen_state.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_map/app_bracket_map.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_node.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_screen_metrics.dart';
import 'package:intl/intl.dart';

enum BracketSample { de, se }

class BracketFixture extends StatefulWidget {
  const BracketFixture({required this.sample, super.key});
  final BracketSample sample;
  @override
  State<BracketFixture> createState() => _BracketFixtureState();
}

class _BracketFixtureState extends State<BracketFixture> {
  final controller = TransformationController();
  bool expanded = false;
  late AppBracketDiagram diagram;
  late AppBracketPoint focus;
  double scale = 1;
  static void action() {}
  @override
  void initState() {
    super.initState();
    switch (widget.sample) {
      case BracketSample.de:
        diagram = AppBracketDiagram(
          size: const AppBracketExtent(1420, 1000),
          nodes: [
            AppBracketMapNode(
              position: const AppBracketPoint(24.0, 60.0),
              label: "W1 · Раунд 1",
              first: AppBracketParticipant(
                primary: "Sub-Zero",
                secondary: "Иван",
                initials: "Su",
              ),
              second: AppBracketParticipant(
                primary: "Scorpion",
                secondary: "Алексей",
                initials: "Sc",
              ),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(24.0, 220.0),
              label: "W2 · Раунд 1",
              first: AppBracketParticipant(
                primary: "Kitana",
                secondary: "Мария",
                initials: "Ki",
              ),
              second: AppBracketParticipant(
                primary: "Raiden",
                secondary: "Олег",
                initials: "Ra",
              ),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(24.0, 380.0),
              label: "W3 · Раунд 1",
              first: AppBracketParticipant(
                primary: "Liu Kang",
                secondary: "Даня",
                initials: "Li",
              ),
              second: AppBracketParticipant(
                primary: "Jade",
                secondary: "Никита",
                initials: "Ja",
              ),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(24.0, 540.0),
              label: "W4 · Раунд 1",
              first: AppBracketParticipant(
                primary: "Kung Lao",
                secondary: "Ахмед",
                initials: "Ku",
              ),
              second: AppBracketParticipant(
                primary: "Skarlet",
                secondary: "Витя",
                initials: "Sk",
              ),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(304.0, 140.0),
              label: "W5 · Сейчас",
              first: AppBracketParticipant(
                primary: "Sub-Zero",
                secondary: "Иван",
                initials: "Su",
              ),
              second: AppBracketParticipant(
                primary: "Kitana",
                secondary: "Мария",
                initials: "Ki",
              ),
              state: AppBracketState.current,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(304.0, 460.0),
              label: "W6 · Полуфинал",
              first: AppBracketPlaceholder("Победитель W3"),
              second: AppBracketPlaceholder("Победитель W4"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(584.0, 300.0),
              label: "W7 · Финал верхней",
              first: AppBracketPlaceholder("Победитель W5"),
              second: AppBracketPlaceholder("Победитель W6"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(24.0, 720.0),
              label: "L1 · Нижняя · Раунд 1",
              first: AppBracketPlaceholder("Проигравший W1"),
              second: AppBracketPlaceholder("Проигравший W2"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(24.0, 860.0),
              label: "L2 · Нижняя · Раунд 1",
              first: AppBracketPlaceholder("Проигравший W3"),
              second: AppBracketPlaceholder("Проигравший W4"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(304.0, 680.0),
              label: "L3 · Нижняя · Раунд 2",
              first: AppBracketPlaceholder("Победитель L1"),
              second: AppBracketPlaceholder("Проигравший W6"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(304.0, 840.0),
              label: "L4 · Нижняя · Раунд 2",
              first: AppBracketPlaceholder("Победитель L2"),
              second: AppBracketPlaceholder("Проигравший W5"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(584.0, 760.0),
              label: "L5 · Нижняя · Раунд 3",
              first: AppBracketPlaceholder("Победитель L3"),
              second: AppBracketPlaceholder("Победитель L4"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(864.0, 650.0),
              label: "L6 · Финал нижней",
              first: AppBracketPlaceholder("Победитель L5"),
              second: AppBracketPlaceholder("Проигравший W7"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(864.0, 300.0),
              label: "GF · Grand Final",
              first: AppBracketPlaceholder("Победитель W7"),
              second: AppBracketPlaceholder("Победитель L6"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(1144.0, 300.0),
              label: "RESET · Reset · при победе нижней",
              first: AppBracketPlaceholder("Участник Grand Final"),
              second: AppBracketPlaceholder("Участник Grand Final"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
          ],
          edges: [
            const [
              AppBracketPoint(244.0, 118.0),
              AppBracketPoint(274.0, 118.0),
              AppBracketPoint(274.0, 198.0),
              AppBracketPoint(304.0, 198.0),
            ],
            const [
              AppBracketPoint(244.0, 278.0),
              AppBracketPoint(274.0, 278.0),
              AppBracketPoint(274.0, 198.0),
            ],
            const [
              AppBracketPoint(244.0, 438.0),
              AppBracketPoint(274.0, 438.0),
              AppBracketPoint(274.0, 518.0),
              AppBracketPoint(304.0, 518.0),
            ],
            const [
              AppBracketPoint(244.0, 598.0),
              AppBracketPoint(274.0, 598.0),
              AppBracketPoint(274.0, 518.0),
            ],
            const [
              AppBracketPoint(524.0, 198.0),
              AppBracketPoint(554.0, 198.0),
              AppBracketPoint(554.0, 358.0),
              AppBracketPoint(584.0, 358.0),
            ],
            const [
              AppBracketPoint(524.0, 518.0),
              AppBracketPoint(554.0, 518.0),
              AppBracketPoint(554.0, 358.0),
            ],
            const [
              AppBracketPoint(244.0, 778.0),
              AppBracketPoint(274.0, 778.0),
              AppBracketPoint(274.0, 738.0),
              AppBracketPoint(304.0, 738.0),
            ],
            const [
              AppBracketPoint(244.0, 918.0),
              AppBracketPoint(274.0, 918.0),
              AppBracketPoint(274.0, 898.0),
              AppBracketPoint(304.0, 898.0),
            ],
            const [
              AppBracketPoint(524.0, 738.0),
              AppBracketPoint(554.0, 738.0),
              AppBracketPoint(554.0, 818.0),
              AppBracketPoint(584.0, 818.0),
            ],
            const [
              AppBracketPoint(524.0, 898.0),
              AppBracketPoint(554.0, 898.0),
              AppBracketPoint(554.0, 818.0),
            ],
            const [
              AppBracketPoint(804.0, 818.0),
              AppBracketPoint(834.0, 818.0),
              AppBracketPoint(834.0, 708.0),
              AppBracketPoint(864.0, 708.0),
            ],
            const [
              AppBracketPoint(804.0, 358.0),
              AppBracketPoint(864.0, 358.0),
            ],
            const [
              AppBracketPoint(1084.0, 708.0),
              AppBracketPoint(1110.0, 708.0),
              AppBracketPoint(1110.0, 440.0),
              AppBracketPoint(974.0, 440.0),
              AppBracketPoint(974.0, 416.0),
            ],
            const [
              AppBracketPoint(1084.0, 358.0),
              AppBracketPoint(1144.0, 358.0),
            ],
          ],
          labels: const [
            AppBracketMapLabel(AppBracketPoint(24.0, 16.0), "Верхняя сетка"),
            AppBracketMapLabel(AppBracketPoint(24.0, 660.0), "Нижняя сетка"),
          ],
        );
        focus = const AppBracketPoint(414.0, 198.0);
      case BracketSample.se:
        diagram = AppBracketDiagram(
          size: const AppBracketExtent(840, 720),
          nodes: [
            AppBracketMapNode(
              position: const AppBracketPoint(24.0, 60.0),
              label: "W1 · Раунд 1",
              first: AppBracketParticipant(
                primary: "Sub-Zero",
                secondary: "Иван",
                initials: "Su",
              ),
              second: AppBracketParticipant(
                primary: "Scorpion",
                secondary: "Алексей",
                initials: "Sc",
              ),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(24.0, 220.0),
              label: "W2 · Раунд 1",
              first: AppBracketParticipant(
                primary: "Kitana",
                secondary: "Мария",
                initials: "Ki",
              ),
              second: AppBracketParticipant(
                primary: "Raiden",
                secondary: "Олег",
                initials: "Ra",
              ),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(24.0, 380.0),
              label: "W3 · Раунд 1",
              first: AppBracketParticipant(
                primary: "Liu Kang",
                secondary: "Даня",
                initials: "Li",
              ),
              second: AppBracketParticipant(
                primary: "Jade",
                secondary: "Никита",
                initials: "Ja",
              ),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(24.0, 540.0),
              label: "W4 · Раунд 1",
              first: AppBracketParticipant(
                primary: "Kung Lao",
                secondary: "Ахмед",
                initials: "Ku",
              ),
              second: AppBracketParticipant(
                primary: "Skarlet",
                secondary: "Витя",
                initials: "Sk",
              ),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(304.0, 140.0),
              label: "W5 · Сейчас",
              first: AppBracketParticipant(
                primary: "Sub-Zero",
                secondary: "Иван",
                initials: "Su",
              ),
              second: AppBracketParticipant(
                primary: "Kitana",
                secondary: "Мария",
                initials: "Ki",
              ),
              state: AppBracketState.current,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(304.0, 460.0),
              label: "W6 · Полуфинал",
              first: AppBracketPlaceholder("Победитель W3"),
              second: AppBracketPlaceholder("Победитель W4"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
            AppBracketMapNode(
              position: const AppBracketPoint(584.0, 300.0),
              label: "W7 · Финал",
              first: AppBracketPlaceholder("Победитель W5"),
              second: AppBracketPlaceholder("Победитель W6"),
              state: AppBracketState.ready,
              onPressed: action,
            ),
          ],
          edges: [
            const [
              AppBracketPoint(244.0, 118.0),
              AppBracketPoint(274.0, 118.0),
              AppBracketPoint(274.0, 198.0),
              AppBracketPoint(304.0, 198.0),
            ],
            const [
              AppBracketPoint(244.0, 278.0),
              AppBracketPoint(274.0, 278.0),
              AppBracketPoint(274.0, 198.0),
            ],
            const [
              AppBracketPoint(244.0, 438.0),
              AppBracketPoint(274.0, 438.0),
              AppBracketPoint(274.0, 518.0),
              AppBracketPoint(304.0, 518.0),
            ],
            const [
              AppBracketPoint(244.0, 598.0),
              AppBracketPoint(274.0, 598.0),
              AppBracketPoint(274.0, 518.0),
            ],
            const [
              AppBracketPoint(524.0, 198.0),
              AppBracketPoint(554.0, 198.0),
              AppBracketPoint(554.0, 358.0),
              AppBracketPoint(584.0, 358.0),
            ],
            const [
              AppBracketPoint(524.0, 518.0),
              AppBracketPoint(554.0, 518.0),
              AppBracketPoint(554.0, 358.0),
            ],
          ],
          labels: const [
            AppBracketMapLabel(AppBracketPoint(24.0, 16.0), "Сетка турнира"),
          ],
        );
        focus = const AppBracketPoint(414.0, 198.0);
    }
    WidgetsBinding.instance.addPostFrameCallback(focusInitial);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void focusInitial(Duration time) => current();
  void controls() => setState(toggle);
  void toggle() {
    expanded = !expanded;
  }

  void zoomIn() => zoom(
    scale + Theme.of(context).extension<AppScreenMetrics>()!.bracketScaleStep,
  );
  void zoomOut() => zoom(
    scale - Theme.of(context).extension<AppScreenMetrics>()!.bracketScaleStep,
  );
  void zoom(double next) {
    final runtimeScreenMetrics = Theme.of(context)
        .extension<AppScreenMetrics>()!;
    setState(() {
      scale = next.clamp(
        runtimeScreenMetrics.bracketScaleMin,
        runtimeScreenMetrics.bracketScaleMax,
      );
      controller.value = Matrix4.diagonal3Values(scale, scale, 1);
    });
  }

  void fit() {
    final size = MediaQuery.sizeOf(context);
    zoom((size.width / diagram.size.width).clamp(.2, 1.6));
  }

  void current() {
    if (!mounted) return;
    final size = MediaQuery.sizeOf(context);
    setState(() {
      scale = 1;
      controller.value = Matrix4.translationValues(
        -(focus.dx - size.width / 2).clamp(
          0.0,
          (diagram.size.width - size.width).clamp(0.0, double.infinity),
        ),
        -(focus.dy - size.height / 2).clamp(
          0.0,
          (diagram.size.height - size.height).clamp(0.0, double.infinity),
        ),
        0,
      );
    });
  }

  @override
  Widget build(BuildContext context) => BracketScreen(
    state: BracketScreenState(
      diagram: diagram,
      zoomLabel: NumberFormat.percentPattern('ru').format(scale),
      controlsExpanded: expanded,
      detail: '',
    ),
    controller: controller,
    onBack: action,
    onControls: controls,
    onZoomOut: zoomOut,
    onZoomIn: zoomIn,
    onFit: fit,
    onCurrent: current,
  );
}
