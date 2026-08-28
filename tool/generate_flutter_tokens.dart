import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> arguments) async {
  final repositoryRoot = File.fromUri(Platform.script).parent.parent;
  final source = File(
    '${repositoryRoot.path}${Platform.pathSeparator}docs'
    '${Platform.pathSeparator}design${Platform.pathSeparator}tokens.json',
  );
  final target = File(
    '${repositoryRoot.path}${Platform.pathSeparator}apps'
    '${Platform.pathSeparator}tournament_app${Platform.pathSeparator}lib'
    '${Platform.pathSeparator}presentation${Platform.pathSeparator}design_system'
    '${Platform.pathSeparator}tokens${Platform.pathSeparator}tokens.g.dart',
  );
  final manifest =
      jsonDecode(await source.readAsString()) as Map<String, Object?>;
  final tokens = manifest['tokens']! as Map<String, Object?>;
  final output = _generate(tokens);

  if (arguments.contains('--check')) {
    if (!target.existsSync() || await target.readAsString() != output) {
      stderr.writeln(
        'Flutter design tokens are stale. Run make generate-tokens.',
      );
      exitCode = 1;
    }
    return;
  }

  await target.parent.create(recursive: true);
  await target.writeAsString(output);
  stdout.writeln('Generated ${target.path}');
}

String _generate(Map<String, Object?> tokens) {
  final declarations = <String>[];
  _visit(tokens, const [], declarations);
  return '''// GENERATED FILE. DO NOT EDIT.
// Source: docs/design/tokens.json

import 'package:flutter/material.dart';

abstract final class TournamentTokens {
${declarations.map((line) => '  $line').join('\n')}
}
''';
}

void _visit(
  Map<String, Object?> node,
  List<String> path,
  List<String> declarations,
) {
  if (node.containsKey('type') && node.containsKey('value')) {
    declarations.add(_declaration(path, node));
    return;
  }

  for (final entry in node.entries) {
    _visit(entry.value! as Map<String, Object?>, [
      ...path,
      entry.key,
    ], declarations);
  }
}

String _declaration(List<String> path, Map<String, Object?> token) {
  final name = _identifier(path);
  final type = token['type']! as String;
  final value = token['value']!;

  return switch (type) {
    'color' =>
      'static const Color $name = Color(0xFF${(value as String).substring(1)});',
    'duration' =>
      'static const Duration $name = Duration(milliseconds: $value);',
    'fontWeight' => 'static const FontWeight $name = FontWeight.w$value;',
    'dimension' => 'static const double $name = ${_number(value)};',
    _ => throw UnsupportedError('Unsupported token type: $type'),
  };
}

String _identifier(List<String> path) {
  final words = path
      .expand((segment) {
        return segment
            .replaceAllMapped(
              RegExp(r'([a-z])([A-Z])'),
              (match) => '${match[1]} ${match[2]}',
            )
            .split(RegExp(r'[^A-Za-z0-9]+'));
      })
      .where((word) => word.isNotEmpty)
      .toList();
  final first = words.first.toLowerCase();
  final rest = words.skip(1).map((word) {
    final safe = RegExp(r'^\d').hasMatch(word) ? 'v$word' : word;
    return '${safe[0].toUpperCase()}${safe.substring(1)}';
  }).join();
  return '$first$rest';
}

String _number(Object value) {
  final number = value as num;
  return number is int ? '${number.toDouble()}' : '$number';
}
