import 'dart:convert';
import 'dart:io';

const _flutterLibPrefix = 'apps/tournament_app/lib/';
const _packagePrefix = 'package:tournament_hub_app/';

const _knownLayers = {
  'app',
  'presentation',
  'application',
  'domain',
  'infrastructure',
  'platform',
  'shared',
};

const _allowedTargets = <String, Set<String>>{
  'domain': {'domain', 'shared'},
  'application': {'application', 'domain', 'shared'},
  'presentation': {'presentation', 'application', 'shared'},
  'infrastructure': {'infrastructure', 'application', 'domain', 'shared'},
  'platform': {'platform', 'application', 'domain', 'shared'},
  'app': {'app', 'application', 'presentation', 'shared'},
  'shared': {'shared'},
  'widgetbook-entry': {'presentation', 'application', 'shared'},
  'composition': _knownLayers,
};

const _restrictedDartLibraries = {
  'dart:ffi',
  'dart:html',
  'dart:io',
  'dart:js',
  'dart:js_interop',
};

const _domainOnlyRestrictedDartLibraries = {'dart:convert'};

const _restrictedPackagePrefixes = [
  'package:drift/',
  'package:drift_flutter/',
  'package:flutter/',
  'package:flutter_riverpod/',
  'package:hooks_riverpod/',
  'package:path_provider/',
  'package:riverpod/',
  'package:shared_preferences/',
  'package:shelf/',
  'package:shelf_web_socket/',
  'package:sqflite/',
  'package:web_socket_channel/',
];

const _domainOnlyRestrictedPackagePrefixes = [
  'package:json_annotation/',
  'package:json_serializable/',
];

final class LayerImportViolation implements Comparable<LayerImportViolation> {
  const LayerImportViolation({
    required this.rule,
    required this.path,
    required this.importUri,
    required this.message,
  });

  final String rule;
  final String path;
  final String importUri;
  final String message;

  @override
  int compareTo(LayerImportViolation other) {
    final byPath = path.compareTo(other.path);
    if (byPath != 0) return byPath;
    final byImport = importUri.compareTo(other.importUri);
    if (byImport != 0) return byImport;
    return rule.compareTo(other.rule);
  }

  @override
  String toString() => '[$rule] $path: import "$importUri"; $message';
}

Future<void> main(List<String> arguments) async {
  final repositoryRoot = File.fromUri(Platform.script).parent.parent;
  final selfTestOnly = arguments.contains('--self-test-only');
  final projectOnly = arguments.contains('--project-only');

  if (selfTestOnly && projectOnly) {
    stderr.writeln(
      '--self-test-only and --project-only are mutually exclusive.',
    );
    exitCode = 64;
    return;
  }

  final failures = <LayerImportViolation>[];
  if (!projectOnly) {
    failures.addAll(await _runFixtureTests(repositoryRoot));
  }
  if (!selfTestOnly) {
    failures.addAll(await _checkProject(repositoryRoot));
  }
  failures.sort();

  if (failures.isNotEmpty) {
    stderr.writeln('Flutter layer import check failed:');
    for (final failure in failures) {
      stderr.writeln('  $failure');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('Flutter layer import check passed.');
}

Future<List<LayerImportViolation>> _runFixtureTests(Directory root) async {
  final fixtureFile = File(
    _join(
      root.path,
      'tool',
      'architecture_fixtures',
      'flutter_layer_imports.json',
    ),
  );
  final decoded = jsonDecode(await fixtureFile.readAsString()) as List<Object?>;
  final failures = <LayerImportViolation>[];

  for (final entry in decoded) {
    final fixture = entry! as Map<String, Object?>;
    final name = fixture['name']! as String;
    final path = fixture['path']! as String;
    final source = fixture['source']! as String;
    final expected =
        (fixture['expectedRules']! as List<Object?>).cast<String>().toList()
          ..sort();
    final actualViolations = _sourceViolations(path, source);
    final actual = actualViolations.map((item) => item.rule).toList()..sort();

    if (!_sameItems(actual, expected)) {
      failures.add(
        LayerImportViolation(
          rule: 'fixture-mismatch',
          path: _relative(root, fixtureFile.path),
          importUri: name,
          message: 'expected ${expected.join(', ')}, got ${actual.join(', ')}',
        ),
      );
    }
  }

  return failures;
}

Future<List<LayerImportViolation>> _checkProject(Directory root) async {
  final lib = Directory(_join(root.path, 'apps', 'tournament_app', 'lib'));
  if (!lib.existsSync()) {
    return [
      LayerImportViolation(
        rule: 'missing-flutter-lib',
        path: _relative(root, lib.path),
        importUri: '-',
        message: 'production Dart root is required',
      ),
    ];
  }

  final violations = <LayerImportViolation>[];
  final files = <File>[];
  await for (final entity in lib.list(recursive: true, followLinks: false)) {
    if (entity is File && entity.path.endsWith('.dart')) files.add(entity);
  }
  files.sort((left, right) => left.path.compareTo(right.path));

  for (final file in files) {
    final path = _relative(root, file.path);
    violations.addAll(_sourceViolations(path, await file.readAsString()));
  }
  return violations;
}

List<LayerImportViolation> _sourceViolations(String path, String source) {
  final normalizedPath = path.replaceAll('\\', '/');
  final sourceKind = _sourceKind(normalizedPath);
  if (sourceKind == null) {
    return [
      LayerImportViolation(
        rule: 'unknown-layer',
        path: normalizedPath,
        importUri: '-',
        message: 'file is outside the layer roots defined by ADR-0010',
      ),
    ];
  }

  final violations = <LayerImportViolation>[];
  for (final importUri in _directiveUris(source)) {
    final targetLayer = _projectTargetLayer(normalizedPath, importUri);
    if (targetLayer != null) {
      if (targetLayer == 'outside-lib') {
        violations.add(
          LayerImportViolation(
            rule: 'project-import-outside-lib',
            path: normalizedPath,
            importUri: importUri,
            message: 'production Dart may import project code only inside lib',
          ),
        );
        continue;
      }
      if (targetLayer == 'unknown') {
        violations.add(
          LayerImportViolation(
            rule: 'unknown-target-layer',
            path: normalizedPath,
            importUri: importUri,
            message: 'target is outside the layer roots defined by ADR-0010',
          ),
        );
        continue;
      }
      final allowed = _allowedTargets[sourceKind]!;
      if (!allowed.contains(targetLayer)) {
        violations.add(
          LayerImportViolation(
            rule: 'layer-import:$sourceKind->$targetLayer',
            path: normalizedPath,
            importUri: importUri,
            message: '$sourceKind may import only ${allowed.join(', ')}',
          ),
        );
      }
      continue;
    }

    if (_hasRestrictedExternalImport(sourceKind, importUri)) {
      violations.add(
        LayerImportViolation(
          rule: 'external-import:$sourceKind',
          path: normalizedPath,
          importUri: importUri,
          message: '$sourceKind must remain framework/platform independent',
        ),
      );
    }
  }
  violations.sort();
  return violations;
}

String? _sourceKind(String path) {
  if (!path.startsWith(_flutterLibPrefix)) return null;
  final relative = path.substring(_flutterLibPrefix.length);
  if (relative == 'main.dart') return 'composition';
  if (relative == 'main_widgetbook.dart') return 'widgetbook-entry';

  final segments = relative.split('/');
  final layer = segments.first;
  if (!_knownLayers.contains(layer)) return null;
  if (layer == 'app' && segments.length > 1 && segments[1] == 'composition') {
    return 'composition';
  }
  return layer;
}

String? _projectTargetLayer(String sourcePath, String importUri) {
  String? targetRelative;
  if (importUri.startsWith(_packagePrefix)) {
    targetRelative = importUri.substring(_packagePrefix.length);
  } else if (importUri.startsWith('package:') ||
      importUri.startsWith('dart:')) {
    return null;
  } else {
    final sourceRelative = sourcePath.substring(_flutterLibPrefix.length);
    targetRelative = _normalizeRelative(
      '${_dirname(sourceRelative)}/$importUri',
    );
    if (targetRelative == null) return 'outside-lib';
  }

  if (targetRelative == 'main.dart') return 'app';
  if (targetRelative == 'main_widgetbook.dart') return 'presentation';
  final targetRoot = targetRelative.split('/').first;
  return _knownLayers.contains(targetRoot) ? targetRoot : 'unknown';
}

bool _hasRestrictedExternalImport(String sourceKind, String importUri) {
  if (sourceKind != 'domain' &&
      sourceKind != 'application' &&
      sourceKind != 'shared') {
    return false;
  }
  if (_restrictedDartLibraries.contains(importUri)) return true;
  if (_restrictedPackagePrefixes.any(importUri.startsWith)) return true;
  if (sourceKind != 'domain') return false;
  if (_domainOnlyRestrictedDartLibraries.contains(importUri)) return true;
  return _domainOnlyRestrictedPackagePrefixes.any(importUri.startsWith);
}

Iterable<String> _directiveUris(String source) sync* {
  final directive = RegExp(
    r'^\s*(?:import|export|part)\s+.*?;',
    multiLine: true,
    dotAll: true,
  );
  final quoted = RegExp(r'''["']([^"']+)["']''');
  for (final statement in directive.allMatches(source)) {
    for (final uri in quoted.allMatches(statement.group(0)!)) {
      yield uri.group(1)!;
    }
  }
}

String? _normalizeRelative(String path) {
  final result = <String>[];
  for (final segment in path.replaceAll('\\', '/').split('/')) {
    if (segment.isEmpty || segment == '.') continue;
    if (segment == '..') {
      if (result.isEmpty) return null;
      result.removeLast();
    } else {
      result.add(segment);
    }
  }
  return result.join('/');
}

bool _sameItems(List<String> left, List<String> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index++) {
    if (left[index] != right[index]) return false;
  }
  return true;
}

String _dirname(String path) {
  final separator = path.lastIndexOf('/');
  return separator < 0 ? '' : path.substring(0, separator);
}

String _join(String first, String second, [String? third, String? fourth]) => [
  first,
  second,
  third,
  fourth,
].whereType<String>().join(Platform.pathSeparator);

String _relative(Directory root, String path) =>
    path.substring(root.path.length + 1).replaceAll('\\', '/');
