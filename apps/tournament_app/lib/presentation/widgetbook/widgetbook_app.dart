import 'package:flutter/widgets.dart';
import 'package:tournament_app/presentation/widgetbook/widgetbook_catalog.dart';
import 'package:widgetbook/widgetbook.dart';

/// Оболочка preview-инструмента, не визуальный компонент продукта.
class TournamentWidgetbookApp extends StatelessWidget {
  const TournamentWidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Widgetbook.material(directories: widgetbookCatalog);
  }
}
