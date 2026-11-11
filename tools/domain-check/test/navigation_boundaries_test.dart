import 'dart:io';
import '../bin/check_flutter_architecture.dart' as architecture;

void main() => _NavigationBoundaryTests.run();

abstract final class _NavigationBoundaryTests {
  static void run() {
    final cases = <({String name, String path, String source, bool rejected})>[
      (
        name: 'owned push stack update stays inside close method',
        path: 'lib/app/navigation/go_router_push_interaction_adapter.dart',
        source:
            'class GoRouterPushInteractionAdapter { void _close() { router.restore(matches); } }',
        rejected: false,
      ),
      (
        name: 'other push adapter method is not an exemption',
        path: 'lib/app/navigation/go_router_push_interaction_adapter.dart',
        source:
            'class GoRouterPushInteractionAdapter { void bypass() { router.push(location); } }',
        rejected: true,
      ),
      (
        name: 'owned controller sheet stays inside modal adapter',
        path: 'lib/app/navigation/flutter_modal_interaction_adapter.dart',
        source:
            'class FlutterModalInteractionAdapter { void _openSheet() { scaffold.showBottomSheet(builder); } }',
        rejected: false,
      ),
      (
        name: 'arbitrary app code cannot open controller sheet',
        path: 'lib/app/routing/accidental_navigation.dart',
        source:
            'class Example { void open() { scaffold.showBottomSheet(builder); } }',
        rejected: true,
      ),
      (
        name: "push SDK call in exact adapter owner",
        path: "lib/app/navigation/go_router_push_interaction_adapter.dart",
        source:
            "class GoRouterPushInteractionAdapter { void _open() { router.push(location); } }",
        rejected: false,
      ),
      (
        name: "push close SDK call in exact adapter owner",
        path: "lib/app/navigation/go_router_push_interaction_adapter.dart",
        source:
            "class GoRouterPushInteractionAdapter { void _close() { router.pop(); } }",
        rejected: false,
      ),
      (
        name: "wrong class cannot use push adapter path",
        path: "lib/app/navigation/go_router_push_interaction_adapter.dart",
        source: "class Other { void _open() { router.push(location); } }",
        rejected: true,
      ),
      (
        name: "modal route push in exact adapter owner",
        path: "lib/app/navigation/flutter_modal_interaction_adapter.dart",
        source:
            "class FlutterModalInteractionAdapter { void _openRoute() { navigator.push(route); } }",
        rejected: false,
      ),
      (
        name: "modal route removal in exact adapter owner",
        path: "lib/app/navigation/flutter_modal_interaction_adapter.dart",
        source:
            "class FlutterModalInteractionAdapter { void _closeRoute() { navigator.removeRoute(route); } }",
        rejected: false,
      ),
      (
        name: "wrong class cannot remove modal routes",
        path: "lib/app/navigation/flutter_modal_interaction_adapter.dart",
        source:
            "class Other { void _closeRoute() { navigator.removeRoute(route); } }",
        rejected: true,
      ),
      (
        name: "arbitrary app code cannot remove routes",
        path: "lib/app/routing/accidental_navigation.dart",
        source:
            "class Example { void close() { navigator.removeRoute(route); } }",
        rejected: true,
      ),
      (
        name: "arbitrary app code cannot restore router stack",
        path: "lib/app/routing/accidental_navigation.dart",
        source: "class Example { void change() { router.restore(matches); } }",
        rejected: true,
      ),
      (
        name: "screens cannot invoke showDialog",
        path: "lib/presentation/screens/home/home_screen.dart",
        source:
            "import 'package:flutter/material.dart'; class Example { void open() { showDialog(context: context, builder: builder); } }",
        rejected: true,
      ),
      (
        name: "arbitrary DS class cannot invoke modal SDK",
        path:
            "lib/presentation/design_system/components/select/app_select.dart",
        source:
            "import 'package:flutter/material.dart'; class Other { void _open() { showModalBottomSheet(context: context, builder: builder); } }",
        rejected: true,
      ),
      (
        name: "exact existing select opener remains allowed",
        path:
            "lib/presentation/design_system/components/select/app_select.dart",
        source:
            "import 'package:flutter/material.dart'; class _AppSelectState { void _open() { showModalBottomSheet(context: context, builder: builder); } }",
        rejected: false,
      ),
      (
        name: "exact existing Widgetbook dialog opener remains allowed",
        path:
            "lib/presentation/widgetbook/widgets/dialog/overlay/overlay_use_case.dart",
        source:
            "import 'package:flutter/material.dart'; class _DialogOverlayState { void _open() { showDialog(context: context, builder: builder); } }",
        rejected: false,
      ),
      (
        name: "date picker cannot be opened by presentation state",
        path: "lib/presentation/navigation/example_state.dart",
        source:
            "import 'package:flutter/material.dart'; class ExampleState { void choose() { showDatePicker(context: context, firstDate: firstDate, lastDate: lastDate); } }",
        rejected: true,
      ),
      (
        name: "canvas restore is not router restore",
        path: "lib/presentation/design_system/foundation/example_painter.dart",
        source: "class ExamplePainter { void paint() { canvas.restore(); } }",
        rejected: false,
      ),
      (
        name: 'presentation cannot import go_router',
        path: 'lib/presentation/navigation/example.dart',
        source: "import 'package:go_router/go_router.dart'; class Example {}",
        rejected: true,
      ),
      (
        name: 'effect filename in presentation is not bypass',
        path: 'lib/presentation/navigation/go_router_effect_executor.dart',
        source: "import 'package:go_router/go_router.dart'; class Example {}",
        rejected: true,
      ),
      (
        name: 'presentation cannot export go_router',
        path: 'lib/presentation/navigation/example.dart',
        source: "export 'package:go_router/go_router.dart';",
        rejected: true,
      ),
      (
        name: 'widgets cannot invoke Navigator',
        path: 'lib/presentation/screens/home/home_screen.dart',
        source:
            "import 'package:flutter/material.dart'; class Example { void open(BuildContext context) { Navigator.of(context).pop(); } }",
        rejected: true,
      ),
      (
        name: 'app route can import router types',
        path: 'lib/app/routing/app_routes.dart',
        source: "import 'package:go_router/go_router.dart'; class Example {}",
        rejected: false,
      ),
      (
        name: 'presentation feedback stays router independent',
        path: 'lib/presentation/navigation/navigation_feedback.dart',
        source:
            'sealed class NavigationFeedback {} final class NavigationAccepted extends NavigationFeedback {}',
        rejected: false,
      ),
      (
        name: 'Navigator in string is not navigation',
        path: 'lib/presentation/navigation/example.dart',
        source:
            "class Example { final description = 'Navigator.of(context).pop()'; }",
        rejected: false,
      ),
    ];
    final failures = <String>[];
    final generatedCases = <({String name, Map<String, String> sources, bool rejected})>[
      (
        name: 'exact codegen pair',
        sources: {
          'lib/app/routing/app_routes.dart': "part 'app_routes.g.dart';",
          'lib/app/routing/app_routes.g.dart':
              "part of 'app_routes.dart'; List<Object> get \$appRoutes => []; Object get \$homeRoute => Object(); Object get \$bootstrapRoute => Object();",
        },
        rejected: false,
      ),
      (
        name: 'arbitrary top function in generated route is rejected',
        sources: {
          'lib/app/routing/app_routes.dart': "part 'app_routes.g.dart';",
          'lib/app/routing/app_routes.g.dart':
              "part of 'app_routes.dart'; void hidden() {}",
        },
        rejected: true,
      ),
      (
        name: 'relative import is not generated part exemption',
        sources: {
          'lib/app/routing/app_routes.dart': "import 'app_routes.g.dart';",
          'lib/app/routing/app_routes.g.dart': '',
        },
        rejected: true,
      ),
      (
        name: 'wrong generated owner rejected',
        sources: {
          'lib/app/routing/app_routes.dart': '',
          'lib/app/routing/app_routes.g.dart':
              "part of 'other.dart'; List<Object> get \$appRoutes => [];",
        },
        rejected: true,
      ),
      (
        name: 'local select modal pop allowed',
        sources: {
          'lib/presentation/design_system/components/select/app_select.dart':
              "import 'package:flutter/material.dart'; class _SelectModalState { void _close() => Navigator.of(context).pop(); }",
        },
        rejected: false,
      ),
      (
        name: 'select modal cannot push',
        sources: {
          'lib/presentation/design_system/components/select/app_select.dart':
              "import 'package:flutter/material.dart'; class _SelectModalState { void _close() => Navigator.of(context).push(route); }",
        },
        rejected: true,
      ),
      (
        name: 'other class cannot claim modal exemption',
        sources: {
          'lib/presentation/design_system/components/select/app_select.dart':
              "import 'package:flutter/material.dart'; class Other { void _close() => Navigator.of(context).pop(); }",
        },
        rejected: true,
      ),
    ];
    for (final scenario in generatedCases) {
      final findings = architecture.inspect(scenario.sources, 'fixture');
      if (findings.isNotEmpty != scenario.rejected)
        failures.add('${scenario.name}: $findings');
    }
    for (final scenario in cases) {
      final findings = architecture.inspect({
        scenario.path: scenario.source,
      }, 'fixture');
      final rejected = findings.any((finding) => finding.contains('R-003.h:'));
      if (rejected != scenario.rejected ||
          (!scenario.rejected && findings.isNotEmpty)) {
        failures.add(
          '${scenario.name}: expected rejected=${scenario.rejected}, actual $findings',
        );
      }
    }
    if (failures.isNotEmpty) {
      stderr.writeln(failures.join('\n'));
      stderr.writeln(
        'Navigation boundaries: ${failures.length}/${cases.length + generatedCases.length} failed.',
      );
      exitCode = 1;
    } else {
      stdout.writeln(
        'Navigation boundaries: ${cases.length + generatedCases.length} passed.',
      );
    }
  }
}
