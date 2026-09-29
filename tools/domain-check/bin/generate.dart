import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/analysis/utilities.dart';

const _schema = 1;

void main(List<String> arguments) {
  final domain = Directory('../../apps/tournament_app/lib/domain');
  final output = File('domain-architecture.json');
  if (!domain.existsSync()) {
    stderr.writeln('Не найдена папка domain: ${domain.absolute.path}');
    exitCode = 2;
    return;
  }

  final files =
      domain
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  final declarations = <_Declaration>[];
  for (final file in files) {
    final source = file.readAsStringSync();
    final result = parseString(content: source, path: file.path);
    if (result.errors.isNotEmpty) {
      for (final error in result.errors) {
        stderr.writeln('${file.path}: $error');
      }
      exitCode = 2;
      return;
    }
    final relative = file.path
        .substring(domain.path.length + 1)
        .replaceAll('\\', '/');
    final area = relative.split('/').first;
    for (final member in result.unit.declarations) {
      if (member is ClassDeclaration) {
        declarations.add(_fromClass(member, area, relative, source));
      } else if (member is EnumDeclaration) {
        declarations.add(_fromEnum(member, area, relative, source));
      } else if (member is FunctionDeclaration) {
        declarations.add(_fromFunction(member, area, relative, source));
      } else if (member is MixinDeclaration) {
        declarations.add(_fromMixin(member, area, relative, source));
      } else {
        stderr.writeln(
          '$relative: неподдерживаемый top-level declaration ${member.runtimeType}. '
          'Генератор не может молча исключить его из карты.',
        );
        exitCode = 2;
        return;
      }
    }
  }
  final names = <String, String>{};
  for (final declaration in declarations) {
    if (names.containsKey(declaration.name)) {
      stderr.writeln('Неоднозначное имя Domain: ${declaration.name}');
      exitCode = 2;
      return;
    }
    names[declaration.name] = declaration.id;
  }
  for (final declaration in declarations) {
    for (final interfaceName in declaration.implementsNames) {
      for (final target in declarations.where(
        (candidate) =>
            candidate.name == interfaceName && candidate.kind == 'interface',
      )) {
        target.implementedBy.add(declaration.id);
      }
    }
  }

  final nodes = declarations.map((declaration) => declaration.toJson()).toList()
    ..sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));
  final edges = <Map<String, Object?>>[];
  for (final declaration in declarations) {
    for (final referencedName
        in declaration.typeNames.toSet().toList()..sort()) {
      final target = names[referencedName];
      if (target != null && target != declaration.id) {
        edges.add({
          'from': declaration.id,
          'to': target,
          'kind': 'type',
          'evidence': referencedName,
        });
      }
    }
    final localMethods = {
      for (final method in declaration.methods) method.name: method.id,
    };
    for (final method in declaration.methods) {
      for (final call in method.calls) {
        final target = localMethods[call.name];
        if (call.local && target != null) {
          edges.add({
            'from': method.id,
            'to': target,
            'kind': 'call',
            'evidence': call.source,
          });
        } else {
          method.unresolvedCalls.add(call.source);
        }
      }
      for (final failure in method.throwsTypes.toSet().toList()..sort()) {
        edges.add({
          'from': method.id,
          'to': names[failure],
          'kind': 'throw',
          'evidence': failure,
          if (names[failure] == null) 'externalName': failure,
        });
      }
    }
  }
  edges.sort(
    (a, b) => '${a['from']}|${a['kind']}|${a['to']}|${a['evidence']}'.compareTo(
      '${b['from']}|${b['kind']}|${b['to']}|${b['evidence']}',
    ),
  );
  // Serialize after unresolved calls have been recorded.
  final data = {
    'schemaVersion': _schema,
    'areas': declarations.map((d) => d.area).toSet().toList()..sort(),
    'nodes': declarations.map((d) => d.toJson()).toList()
      ..sort((a, b) => (a['id'] as String).compareTo(b['id'] as String)),
    'edges': edges,
  };
  final json = const JsonEncoder.withIndent('  ').convert(data) + '\n';
  if (arguments.contains('--check')) {
    if (!output.existsSync() || output.readAsStringSync() != json) {
      stderr.writeln(
        'Domain graph устарел. Запустите make domain-check-generate.',
      );
      exitCode = 1;
    } else {
      stdout.writeln(
        'Domain graph актуален: ${nodes.length} объектов, ${edges.length} связей.',
      );
    }
  } else {
    output.writeAsStringSync(json);
    stdout.writeln(
      'Domain graph: ${nodes.length} объектов, ${edges.length} связей.',
    );
  }
}

_Declaration _fromClass(
  ClassDeclaration node,
  String area,
  String file,
  String source,
) {
  final name = node.namePart.typeName.lexeme;
  return _Declaration(
    id: '$area.$name',
    area: area,
    name: name,
    file: file,
    kind: node.interfaceKeyword != null
        ? 'interface'
        : node.sealedKeyword != null
        ? 'sealed class'
        : node.abstractKeyword != null
        ? 'abstract class'
        : 'class',
    description: _comment(node.documentationComment),
    implementsNames:
        node.implementsClause?.interfaces
            .map((type) => type.name.lexeme)
            .toList() ??
        const [],
    fields: [
      for (final member in node.body.members)
        if (member is FieldDeclaration) member.toSource(),
    ],
    methods: [
      for (final member in node.body.members)
        if (member is MethodDeclaration)
          _method(
            '$area.$name',
            member.name.lexeme,
            source.substring(member.offset, member.body.offset).trim(),
            member.body,
          )
        else if (member is ConstructorDeclaration)
          _method(
            '$area.$name',
            member.name == null ? name : '$name.${member.name!.lexeme}',
            source.substring(member.offset, member.body.offset).trim(),
            member.body,
          ),
    ],
    typeNames: _typeNames(node),
  );
}

_Declaration _fromEnum(
  EnumDeclaration node,
  String area,
  String file,
  String source,
) {
  final name = node.namePart.typeName.lexeme;
  return _Declaration(
    id: '$area.$name',
    area: area,
    name: name,
    file: file,
    kind: 'enum',
    description: _comment(node.documentationComment),
    fields: [for (final constant in node.body.constants) constant.name.lexeme],
    methods: [
      for (final member in node.body.members)
        if (member is MethodDeclaration)
          _method(
            '$area.$name',
            member.name.lexeme,
            source.substring(member.offset, member.body.offset).trim(),
            member.body,
          ),
    ],
    typeNames: _typeNames(node),
  );
}

_Declaration _fromMixin(
  MixinDeclaration node,
  String area,
  String file,
  String source,
) {
  final name = node.name.lexeme;
  return _Declaration(
    id: '$area.$name',
    area: area,
    name: name,
    file: file,
    kind: 'mixin',
    description: _comment(node.documentationComment),
    fields: [
      for (final member in node.body.members)
        if (member is FieldDeclaration) member.toSource(),
    ],
    methods: [
      for (final member in node.body.members)
        if (member is MethodDeclaration)
          _method(
            '$area.$name',
            member.name.lexeme,
            source.substring(member.offset, member.body.offset).trim(),
            member.body,
          ),
    ],
    typeNames: _typeNames(node),
  );
}

_Declaration _fromFunction(
  FunctionDeclaration node,
  String area,
  String file,
  String source,
) {
  final name = node.name.lexeme;
  final body = node.functionExpression.body;
  return _Declaration(
    id: '$area.$name',
    area: area,
    name: name,
    file: file,
    kind: 'function',
    description: _comment(node.documentationComment),
    fields: const [],
    methods: [
      _method(
        '$area.$name',
        name,
        source.substring(node.offset, body.offset).trim(),
        body,
      ),
    ],
    typeNames: _typeNames(node),
  );
}

_Method _method(String owner, String name, String signature, AstNode body) {
  final visitor = _MethodVisitor(owner.split('.').last);
  body.accept(visitor);
  return _Method(
    id: '$owner::$name',
    name: name,
    signature: signature,
    calls: visitor.calls,
    throwsTypes: visitor.throwsTypes,
  );
}

List<String> _typeNames(AstNode node) {
  final visitor = _TypeVisitor();
  node.accept(visitor);
  return visitor.names;
}

String? _comment(Comment? comment) {
  if (comment == null) return null;
  final lines = comment.tokens
      .map(
        (token) => token.lexeme.replaceFirst(RegExp(r'^\s*///?\s?'), '').trim(),
      )
      .where((line) => line.isNotEmpty)
      .toList();
  return lines.isEmpty ? null : lines.join(' ');
}

final class _TypeVisitor extends RecursiveAstVisitor<void> {
  final names = <String>[];
  @override
  void visitNamedType(NamedType node) {
    names.add(node.name.lexeme);
    super.visitNamedType(node);
  }
}

final class _MethodVisitor extends RecursiveAstVisitor<void> {
  _MethodVisitor(this.ownerName);

  final String ownerName;
  final calls = <_Call>[];
  final throwsTypes = <String>[];
  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.parent is! ThrowExpression) {
      final target = node.target;
      final ownConstructor =
          target is SimpleIdentifier && target.name == ownerName;
      calls.add(
        _Call(
          ownConstructor
              ? '$ownerName.${node.methodName.name}'
              : node.methodName.name,
          node.toSource(),
          target == null || target is ThisExpression || ownConstructor,
        ),
      );
    }
    super.visitMethodInvocation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final constructor = node.constructorName;
    final type = constructor.type.name.lexeme;
    final suffix = constructor.name?.name;
    if (node.parent is! ThrowExpression) {
      calls.add(
        _Call(
          suffix == null ? type : '$type.$suffix',
          node.toSource(),
          type == ownerName,
        ),
      );
    }
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    final expression = node.expression;
    if (expression is InstanceCreationExpression) {
      throwsTypes.add(expression.constructorName.type.name.lexeme);
    } else if (expression is MethodInvocation) {
      throwsTypes.add(
        expression.target is SimpleIdentifier
            ? (expression.target as SimpleIdentifier).name
            : expression.methodName.name,
      );
    } else {
      throwsTypes.add('неразрешённый тип');
    }
    super.visitThrowExpression(node);
  }
}

final class _Call {
  const _Call(this.name, this.source, this.local);
  final String name;
  final String source;
  final bool local;
}

final class _Method {
  _Method({
    required this.id,
    required this.name,
    required this.signature,
    required this.calls,
    required this.throwsTypes,
  });
  final String id;
  final String name;
  final String signature;
  final List<_Call> calls;
  final List<String> throwsTypes;
  final List<String> unresolvedCalls = [];
  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'signature': signature,
    'unresolvedCalls': unresolvedCalls.toSet().toList()..sort(),
  };
}

final class _Declaration {
  _Declaration({
    required this.id,
    required this.area,
    required this.name,
    required this.file,
    required this.kind,
    required this.description,
    required this.fields,
    required this.methods,
    required this.typeNames,
    this.implementsNames = const [],
  });
  final String id;
  final String area;
  final String name;
  final String file;
  final String kind;
  final String? description;
  final List<String> fields;
  final List<_Method> methods;
  final List<String> typeNames;
  final List<String> implementsNames;
  final List<String> implementedBy = [];
  Map<String, Object?> toJson() => {
    'id': id,
    'area': area,
    'name': name,
    'file': file,
    'kind': kind,
    'description': description,
    'fields': fields,
    'methods': [for (final method in methods) method.toJson()],
    if (kind == 'interface') 'implementedBy': implementedBy..sort(),
  };
}
