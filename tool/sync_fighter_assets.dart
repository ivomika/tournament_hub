import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

Future<void> main(List<String> arguments) async {
  final root = File.fromUri(Platform.script).parent.parent;
  final sourceDirectory = Directory(
    _join(root.path, 'docs', 'source', 'fighters'),
  );
  final targetDirectory = Directory(
    _join(root.path, 'apps', 'tournament_app', 'assets', 'fighters'),
  );
  final sourceManifest = File(_join(sourceDirectory.path, 'manifest.json'));
  final targetManifest = File(_join(targetDirectory.path, 'manifest.json'));
  final checkOnly = arguments.contains('--check');
  final manifest =
      jsonDecode(await sourceManifest.readAsString()) as Map<String, Object?>;
  if (manifest['schemaVersion'] != 1 || manifest['format'] != 'png') {
    _fail('Unsupported fighter manifest schema or format.');
  }
  final width = manifest['width']! as int;
  final height = manifest['height']! as int;
  final avatars = manifest['avatars']! as List<Object?>;
  if (width <= 0 || height <= 0 || avatars.isEmpty) {
    _fail('Fighter manifest dimensions and roster must be non-empty.');
  }
  final expectedNames = <String>{'manifest.json'};
  final sources = <String, File>{};

  for (final value in avatars) {
    final entry = value! as Map<String, Object?>;
    final id = entry['id']! as String;
    final assetPath = entry['asset']! as String;
    final name = assetPath.split('/').last;
    if (!RegExp(r'^[a-z0-9-]+\.png$').hasMatch(name) || name != '$id.png') {
      _fail('Unsafe or inconsistent fighter asset: $id -> $assetPath');
    }
    if (!expectedNames.add(name)) _fail('Duplicate fighter asset: $name');
    final source = File(_join(sourceDirectory.path, name));
    if (!source.existsSync())
      _fail('Missing source fighter asset: ${source.path}');
    _validatePng(await source.readAsBytes(), width, height, source.path);
    sources[name] = source;
  }

  final sourcePngNames = sourceDirectory
      .listSync()
      .whereType<File>()
      .map((file) => file.uri.pathSegments.last)
      .where((name) => name.endsWith('.png'))
      .toSet();
  if (!_sameSet(sourcePngNames, sources.keys.toSet())) {
    _fail(
      'Source fighter PNG set differs from manifest. '
      'Expected ${sources.length}, found ${sourcePngNames.length}.',
    );
  }

  if (!checkOnly) {
    await targetDirectory.create(recursive: true);
    await sourceManifest.copy(targetManifest.path);
    for (final entry in sources.entries) {
      await entry.value.copy(_join(targetDirectory.path, entry.key));
    }
  }

  if (!targetDirectory.existsSync()) {
    _fail('Runtime fighter assets are missing. Run make sync-fighter-assets.');
  }
  final actualNames = targetDirectory
      .listSync()
      .whereType<File>()
      .map((file) => file.uri.pathSegments.last)
      .toSet();
  if (!_sameSet(actualNames, expectedNames)) {
    _fail(
      'Runtime fighter asset set differs from manifest. '
      'Expected ${expectedNames.length}, found ${actualNames.length}.',
    );
  }
  await _requireEqual(sourceManifest, targetManifest);
  for (final entry in sources.entries) {
    await _requireEqual(
      entry.value,
      File(_join(targetDirectory.path, entry.key)),
    );
  }

  stdout.writeln(
    '${checkOnly ? 'Checked' : 'Synchronized'} ${sources.length} fighter assets.',
  );
}

void _validatePng(Uint8List bytes, int width, int height, String path) {
  const signature = [137, 80, 78, 71, 13, 10, 26, 10];
  if (bytes.length < 24) {
    _fail('Invalid PNG signature: $path');
  }
  for (var index = 0; index < signature.length; index++) {
    if (bytes[index] != signature[index]) _fail('Invalid PNG signature: $path');
  }
  final data = ByteData.sublistView(bytes);
  final actualWidth = data.getUint32(16, Endian.big);
  final actualHeight = data.getUint32(20, Endian.big);
  if (actualWidth != width || actualHeight != height) {
    _fail(
      'Unexpected PNG dimensions for $path: '
      '${actualWidth}x$actualHeight, expected ${width}x$height.',
    );
  }
}

Future<void> _requireEqual(File source, File target) async {
  if (!target.existsSync()) _fail('Missing runtime file: ${target.path}');
  final sourceBytes = await source.readAsBytes();
  final targetBytes = await target.readAsBytes();
  if (sourceBytes.length != targetBytes.length) {
    _fail('Runtime file differs from source: ${target.path}');
  }
  for (var index = 0; index < sourceBytes.length; index++) {
    if (sourceBytes[index] != targetBytes[index]) {
      _fail('Runtime file differs from source: ${target.path}');
    }
  }
}

bool _sameSet(Set<String> first, Set<String> second) =>
    first.length == second.length && first.containsAll(second);

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}

String _join(
  String first,
  String second, [
  String? third,
  String? fourth,
  String? fifth,
]) => [
  first,
  second,
  third,
  fourth,
  fifth,
].whereType<String>().join(Platform.pathSeparator);
