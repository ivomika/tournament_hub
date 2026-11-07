import 'package:tournament_app/presentation/widgetbook/foundation/colors/colors_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/identity/identity_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/button_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/components/surface/surface_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/icons/icon_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/avatar_comparison.dart';

abstract final class ComparisonCatalog {
  static final List<ComparisonSpec> components = [
    ColorsComparison.spec,
    AvatarComparison.spec,
    IconComparison.spec,
    SurfaceComparison.spec,
    ButtonComparison.spec,
    IdentityComparison.spec,
    RosterComparison.spec,
  ];
  static ComparisonSpec component(String id) =>
      components.singleWhere((s) => s.component == id);
}
