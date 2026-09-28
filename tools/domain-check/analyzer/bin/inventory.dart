import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../lib/inventory.dart';

Future<void> main(List<String> args) async {
  final repo = p.normalize(
    p.join(File.fromUri(Platform.script).parent.path, '..', '..', '..', '..'),
  );
  final root = args.isEmpty
      ? p.join(repo, 'apps', 'tournament_app', 'lib', 'domain')
      : p.normalize(p.absolute(args.first));
  print(jsonEncode(await scanInventory(root)));
}
