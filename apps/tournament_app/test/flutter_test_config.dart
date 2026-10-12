import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_typography.dart';

/// Flutter автоматически вызывает этот test-only hook; импорт из lib не нужен.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  goldenFileComparator = _PlatformGoldenComparator(goldenFileComparator);
  setUpAll(_loadFoundationFonts);
  setUp(_setRenderEnvironment);
  tearDown(_resetRenderEnvironment);
  await testMain();
}

Future<void> _loadFoundationFonts() async {
  final inter = FontLoader(AppTypography.interfaceFamily)
    ..addFont(rootBundle.load('assets/fonts/inter/Inter-Variable.ttf'));
  final condensed = FontLoader(AppTypography.displayFamily)
    ..addFont(
      rootBundle.load(
        'assets/fonts/roboto_condensed/RobotoCondensed-Variable.ttf',
      ),
    );
  await Future.wait([inter.load(), condensed.load()]);
}

void _setRenderEnvironment() {
  final dispatcher = TestWidgetsFlutterBinding.instance.platformDispatcher;
  dispatcher.localeTestValue = const Locale('ru');
  dispatcher.textScaleFactorTestValue = 1;
  dispatcher.implicitView?.devicePixelRatio = 1;
}

void _resetRenderEnvironment() {
  final dispatcher = TestWidgetsFlutterBinding.instance.platformDispatcher;
  dispatcher.implicitView?.reset();
  dispatcher.clearAllTestValues();
}

/// Проверяет внешний формат URI: `golden/<native-os>/<snapshot>.png`.
/// Не позволяет update/compare использовать baseline другой платформы.
class _PlatformGoldenComparator extends GoldenFileComparator {
  _PlatformGoldenComparator(this.delegate);

  final GoldenFileComparator delegate;

  @override
  Uri getTestUri(Uri key, int? version) => delegate.getTestUri(key, version);

  void _requireNativePath(Uri golden) {
    final segments = golden.pathSegments;
    final folder = segments.lastIndexOf('golden');
    if (folder < 0 ||
        folder + 2 >= segments.length ||
        segments[folder + 1] != Platform.operatingSystem) {
      throw ArgumentError.value(
        golden,
        'golden',
        'Expected golden/${Platform.operatingSystem}/<snapshot>.png. '
            'Cross-platform baselines must not be mixed.',
      );
    }
  }

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) {
    _requireNativePath(golden);
    return delegate.compare(imageBytes, golden);
  }

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) {
    _requireNativePath(golden);
    return delegate.update(golden, imageBytes);
  }
}
