import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/avatar_comparison.dart';

abstract final class ComparisonCatalog {
  static final List<ComparisonSpec> components = [AvatarComparison.spec];
  static ComparisonSpec component(String id) =>
      components.singleWhere((s) => s.component == id);
}
