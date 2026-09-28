import 'dart:io';

import 'package:path/path.dart' as p;

import '../lib/inventory.dart';

void expect(bool condition, String message) {
  if (!condition) throw StateError(message);
}

Future<void> main() async {
  final root = p.normalize(p.absolute('test/fixtures/inventory'));
  final result = await scanInventory(root);
  final nodes = (result['nodes'] as List).cast<Map<String, Object?>>();
  final box = nodes.singleWhere((n) => n['title'] == 'Box');
  final members = (box['memberFacts'] as List).cast<Map<String, Object?>>();
  Map<String, Object?> member(String name) =>
      members.singleWhere((m) => m['name'] == name);
  final items = member('items')['type'] as Map;
  final itemType = (items['arguments'] as List).single as Map;
  final other = member('other')['type'] as Map;
  expect(
    itemType['symbolId'] != other['symbolId'],
    'Aliased same-name types must resolve independently',
  );
  expect(itemType['nullable'] == true, 'Nested nullability missing');
  expect(
    (member('unknown')['type'] as Map)['resolution'] == 'dynamic',
    'dynamic must stay explicit',
  );
  expect(
    members
            .where((m) => m['name'] == 'count')
            .map((m) => m['id'])
            .toSet()
            .length ==
        2,
    'Getter/setter need separate identities',
  );
  expect(
    members.where((m) => m['kind'] == 'constructor').length == 2,
    'Named constructor missing',
  );
  expect(
    member('_helper')['visibility'] == 'private',
    'Private member missing',
  );
  expect(
    (member('choose')['returnType'] as Map)['display'] == 'T',
    'Generic type lost',
  );
  final mode = nodes.singleWhere((n) => n['title'] == 'Mode');
  expect(
    (mode['memberFacts'] as List).any(
      (m) => m['kind'] == 'field' && m['name'] == 'value',
    ),
    'Enhanced enum field missing',
  );
  expect((mode['members'] as List).length == 2, 'Enum values missing');
  final store = nodes.singleWhere((n) => n['title'] == 'Store');
  final storeBase = nodes.singleWhere((n) => n['title'] == 'StoreBase');
  expect(
    (storeBase['inheritedFacts'] as List).any(
      (fact) =>
          (fact as Map)['name'] == 'read' && fact['declaringType'] == 'Store',
    ),
    'Inherited contract member must name declaring type',
  );
  expect(
    (store['memberFacts'] as List).single['hasBody'] == false,
    'Contract must not have an invented body',
  );
  expect(
    (result['diagnostics'] as List).length == 1,
    'Unsupported typedef must have diagnostic',
  );
  final ids = nodes.map((n) => n['id']).toList();
  expect(ids.toSet().length == ids.length, 'Duplicate node IDs');
  final partThing = nodes.singleWhere((n) => n['title'] == 'PartThing');
  expect(
    (partThing['id'] as String).contains('example.dart#PartThing'),
    'Part declaration must use owning library identity',
  );
  for (final node in nodes) {
    final evidence = node['evidence'] as Map;
    final fileName = p.basename(evidence['source'] as String);
    final source = File(p.join(root, fileName)).readAsStringSync();
    final start = evidence['offset'] as int;
    expect(
      source.substring(start, start + (evidence['length'] as int)) ==
          evidence['code'],
      'Evidence mismatch',
    );
  }
  print(
    'Inventory fixtures passed: aliases, duplicates, generic/nullable/dynamic types, constructors, accessors, enhanced enum, unsupported declaration.',
  );
  final occurrences = (result['relationOccurrences'] as List)
      .cast<Map<String, Object?>>();
  final fields = occurrences.where(
    (o) =>
        o['sourceMemberId'] == member('items')['id'] &&
        o['kind'] == 'field-type',
  );
  expect(
    fields.any((o) => o['targetId'] == itemType['symbolId']),
    'Field relation must resolve imported type',
  );
  expect(
    !fields.any((o) => o['targetId'] == other['symbolId']),
    'Alias collision must not invent another field dependency',
  );
  expect(
    occurrences.any((o) => o['kind'] == 'call' && o['resolution'] == 'dynamic'),
    'Dynamic dispatch must stay unknown',
  );
  expect(
    !occurrences.any(
      (o) =>
          o['sourceMemberId'] == member('unrelatedName')['id'] &&
          [itemType['symbolId'], other['symbolId']].contains(o['targetId']),
    ),
    'Local name collision must not create type dependency',
  );
  expect(
    occurrences.any(
      (o) => o['kind'] == 'extends' && o['targetId'] == itemType['symbolId'],
    ),
    'Resolved superclass missing',
  );
  expect(
    occurrences.any(
      (o) => o['kind'] == 'implements' && o['targetId'] == store['id'],
    ),
    'Resolved contract missing',
  );
  expect(
    occurrences.any(
      (o) =>
          o['kind'] == 'constructor-call' &&
          o['targetId'] == itemType['symbolId'],
    ),
    'Explicit super constructor missing',
  );
  expect(
    occurrences.map((o) => o['id']).toSet().length == occurrences.length,
    'Occurrence IDs must be unique',
  );
  final genericExtra = nodes.singleWhere((n) => n['title'] == 'GenericExtra');
  expect(
    !occurrences.any(
      (o) =>
          o['sourceId'] == genericExtra['id'] &&
          o['kind'] == 'extends' &&
          o['targetId'] == itemType['symbolId'],
    ),
    'Generic argument is not a superclass',
  );
  expect(
    occurrences.any(
      (o) =>
          o['sourceId'] == genericExtra['id'] &&
          o['kind'] == 'type-use' &&
          o['targetId'] == itemType['symbolId'],
    ),
    'Generic hierarchy argument must remain a type-use dependency',
  );
  for (final occurrence in occurrences) {
    final evidence = occurrence['evidence'] as Map;
    final source = File(p.join(root, p.basename(evidence['source'] as String)))
        .readAsStringSync();
    expect(
      source.substring(
            evidence['offset'] as int,
            (evidence['offset'] as int) + (evidence['length'] as int),
          ) ==
          evidence['code'],
      'Relation evidence mismatch',
    );
  }
  print(
    'Relations fixtures passed: resolved aliases, local collision, dynamic, inheritance, implements, explicit constructor call and exact evidence.',
  );
  final invalidFixture = Directory.systemTemp.createTempSync(
    'domain-viewer-invalid-',
  );
  try {
    final invalidDomain = Directory(p.join(invalidFixture.path, 'domain'))
      ..createSync();
    File(p.join(invalidDomain.path, 'broken.dart'))
        .writeAsStringSync('class Broken {');
    var rejected = false;
    try {
      await scanInventory(invalidDomain.path);
    } on StateError {
      rejected = true;
    }
    expect(rejected, 'Parse error must fail extraction');
  } finally {
    invalidFixture.deleteSync(recursive: true);
  }
}
