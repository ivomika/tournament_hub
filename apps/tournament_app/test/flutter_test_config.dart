import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Flutter автоматически вызывает этот test-only hook; импорт из lib не нужен.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  goldenFileComparator = _LinuxGoldenComparator(goldenFileComparator);
  setUp(_setRenderEnvironment);
  tearDown(_resetRenderEnvironment);
  await testMain();
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

/// Не даёт случайно принять Windows PNG за Linux baseline.
class _LinuxGoldenComparator extends GoldenFileComparator {
  _LinuxGoldenComparator(this.delegate);

  final GoldenFileComparator delegate;

  @override
  Uri getTestUri(Uri key, int? version) => delegate.getTestUri(key, version);

  void _requireLinux() {
    if (!Platform.isLinux) {
      throw UnsupportedError(
        'Golden generate/compare requires the canonical Linux environment.',
      );
    }
  }

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) {
    _requireLinux();
    return delegate.compare(imageBytes, golden);
  }

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) {
    _requireLinux();
    return delegate.update(golden, imageBytes);
  }
}
