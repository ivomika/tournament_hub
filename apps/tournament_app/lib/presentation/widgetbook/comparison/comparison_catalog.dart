import 'package:tournament_app/presentation/widgetbook/components/segmented_choice/segmented_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/components/select/select_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/components/field/field_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/responsive/responsive_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/motion/motion_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/elevation/elevation_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/borders/borders_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/shape/shape_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/spacing/spacing_comparison.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/typography/typography_comparison.dart';
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
    SegmentedComparison.spec,
    SelectComparison.spec,
    FieldComparison.spec,
    ResponsiveComparison.spec,
    MotionComparison.spec,
    ElevationComparison.spec,
    BordersComparison.spec,
    ShapeComparison.spec,
    SpacingComparison.spec,
    ColorsComparison.spec,
    TypographyComparison.spec,
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
