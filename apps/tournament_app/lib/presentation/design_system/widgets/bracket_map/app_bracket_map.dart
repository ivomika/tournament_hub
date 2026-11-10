import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_node.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_map/app_bracket_map_theme.dart';

@immutable
class AppBracketMapNode {
  const AppBracketMapNode({
    required this.position,
    required this.label,
    required this.first,
    required this.second,
    required this.state,
    required this.onPressed,
  });
  final AppBracketPoint position;
  final String label;
  final AppBracketSlot first, second;
  final AppBracketState state;
  final VoidCallback? onPressed;
}

@immutable
class AppBracketMapLabel {
  const AppBracketMapLabel(this.position, this.text);
  final AppBracketPoint position;
  final String text;
}

@immutable
class AppBracketDiagram {
  AppBracketDiagram({
    required this.size,
    required List<AppBracketMapNode> nodes,
    required List<List<AppBracketPoint>> edges,
    required List<AppBracketMapLabel> labels,
  }) : nodes = List.unmodifiable(nodes),
       edges = List.unmodifiable(edges.map(List<AppBracketPoint>.unmodifiable)),
       labels = List.unmodifiable(labels);
  final AppBracketExtent size;
  final List<AppBracketMapNode> nodes;
  final List<List<AppBracketPoint>> edges;
  final List<AppBracketMapLabel> labels;
}

class AppBracketMap extends StatelessWidget {
  const AppBracketMap({
    required this.diagram,
    required this.controller,
    super.key,
  });
  final AppBracketDiagram diagram;
  final TransformationController controller;
  @override
  Widget build(BuildContext context) {
    final appearance = AppBracketMapTheme.of(context);
    return ClipRect(
      child: InteractiveViewer(
        transformationController: controller,
        constrained: false,
        alignment: appearance.origin,
        minScale: appearance.minScale,
        maxScale: appearance.maxScale,
        child: CustomPaint(
          painter: _BracketPainter(diagram, appearance),
          child: SizedBox.fromSize(
            size: diagram.size.size,
            child: Stack(
              children: [
                for (final label in diagram.labels)
                  Positioned(
                    left: label.position.dx,
                    top: label.position.dy,
                    child: Text(label.text, style: appearance.label),
                  ),
                for (final node in diagram.nodes)
                  Positioned(
                    left: node.position.dx,
                    top: node.position.dy,
                    child: AppBracketNode(
                      label: node.label,
                      first: node.first,
                      second: node.second,
                      state: node.state,
                      onPressed: node.onPressed,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  const _BracketPainter(this.diagram, this.theme);
  final AppBracketDiagram diagram;
  final AppBracketMapTheme theme;
  @override
  void paint(Canvas canvas, Size size) {
    final dot = Paint()..color = theme.gridColor;
    for (
      var gridHorizontalOffset = theme.zero;
      gridHorizontalOffset < size.width;
      gridHorizontalOffset += theme.grid
    ) {
      for (
        var gridVerticalOffset = theme.zero;
        gridVerticalOffset < size.height;
        gridVerticalOffset += theme.grid
      ) {
        canvas.drawCircle(
          Offset(gridHorizontalOffset, gridVerticalOffset),
          theme.dot,
          dot,
        );
      }
    }
    final line = Paint()
      ..color = theme.edgeColor
      ..strokeWidth = theme.stroke
      ..style = PaintingStyle.stroke;
    for (final edge in diagram.edges) {
      if (edge.isEmpty) continue;
      final path = Path()..moveTo(edge.first.dx, edge.first.dy);
      for (final point in edge.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, line);
    }
  }

  @override
  bool shouldRepaint(_BracketPainter old) =>
      old.diagram != diagram || old.theme != theme;
}

/// Геометрия диаграммы — подготовленные данные, не оформление виджета.
@immutable
class AppBracketPoint {
  const AppBracketPoint(this.dx, this.dy);
  final double dx, dy;
}

@immutable
class AppBracketExtent {
  const AppBracketExtent(this.width, this.height);
  final double width, height;
  Size get size => Size(width, height);
}
