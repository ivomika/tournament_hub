import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:path/path.dart' as p;

import 'relations.dart';
import 'symbols.dart';

Future<Map<String, Object?>> scanInventory(String domainRoot) async {
  final files =
      Directory(domainRoot)
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  final collection = AnalysisContextCollection(includedPaths: [domainRoot]);
  final nodes = <Map<String, Object?>>[];
  final diagnostics = <Map<String, Object?>>[];
  final occurrences = <Map<String, Object?>>[];
  for (final file in files) {
    final parsed = parseString(
      content: file.readAsStringSync(),
      path: file.path,
      throwIfDiagnostics: false,
    );
    if (parsed.errors.isNotEmpty)
      throw StateError(
        '${file.path}: parse errors ${parsed.errors.join('\n')}',
      );
    final result = await collection
        .contextFor(file.path)
        .currentSession
        .getResolvedUnit(file.path);
    if (result is! ResolvedUnitResult)
      throw StateError('Cannot resolve ${file.path}');
    final errors = result.diagnostics.where((d) => d.severity.name == 'ERROR');
    if (errors.isNotEmpty)
      throw StateError('${file.path}: ${errors.join('\n')}');
    final relative = p
        .relative(file.path, from: domainRoot)
        .replaceAll('\\', '/');
    for (final declaration in result.unit.declarations) {
      final Element? element;
      final List<ClassMember> members;
      final String name;
      final String kind;
      final String signature;
      final enumValues = <EnumConstantDeclaration>[];
      if (declaration is ClassDeclaration) {
        element = declaration.declaredFragment?.element;
        members = declaration.members;
        name = declaration.name.lexeme;
        kind = declaration.interfaceKeyword != null
            ? 'interface'
            : declaration.sealedKeyword != null
            ? 'sealed-class'
            : declaration.abstractKeyword != null
            ? 'abstract-class'
            : 'class';
        signature = result.content
            .substring(
              declaration.firstTokenAfterCommentAndMetadata.offset,
              declaration.leftBracket.offset,
            )
            .trim();
      } else if (declaration is EnumDeclaration) {
        element = declaration.declaredFragment?.element;
        members = declaration.members;
        name = declaration.name.lexeme;
        kind = 'enum';
        enumValues.addAll(declaration.constants);
        signature = result.content
            .substring(
              declaration.enumKeyword.offset,
              declaration.leftBracket.offset,
            )
            .trim();
      } else {
        diagnostics.add({
          'code': 'UNSUPPORTED_DECLARATION',
          'source': relative,
          'kind': declaration.runtimeType.toString(),
          'message':
              'Declaration не поддержан реестром: ${declaration.runtimeType}',
        });
        continue;
      }
      if (element == null) throw StateError('Unresolved declaration $name');
      final id = symbolId(element);
      Map<String, Object?> evidence(AstNode ast) {
        final location = result.lineInfo.getLocation(ast.offset);
        return {
          'source': 'apps/tournament_app/lib/domain/$relative',
          'line': location.lineNumber,
          'column': location.columnNumber,
          'offset': ast.offset,
          'length': ast.length,
          'code': result.content.substring(ast.offset, ast.end),
        };
      }

      final facts = <Map<String, Object?>>[];
      RelationCollector collector(String? memberId) => RelationCollector(
        result,
        'apps/tournament_app/lib/domain/$relative',
        id,
        memberId,
        occurrences,
      );
      if (declaration is ClassDeclaration) {
        final header = collector(null);
        final superclass = declaration.extendsClause?.superclass;
        if (superclass?.type != null)
          header.typed('extends', superclass!, superclass.type!);
        for (final type
            in declaration.implementsClause?.interfaces ?? <NamedType>[]) {
          if (type.type != null) header.typed('implements', type, type.type!);
        }
        for (final type
            in declaration.withClause?.mixinTypes ?? <NamedType>[]) {
          if (type.type != null) header.typed('mixin', type, type.type!);
        }
      }
      for (final member in members) {
        if (member is FieldDeclaration) {
          for (final variable in member.fields.variables) {
            final field = variable.declaredFragment?.element;
            if (field == null)
              throw StateError('Unresolved field $name.${variable.name}');
            facts.add({
              'id': '$id/field:${variable.name.lexeme}',
              'name': variable.name.lexeme,
              'kind': 'field',
              'visibility': variable.name.lexeme.startsWith('_')
                  ? 'private'
                  : 'public',
              'signature':
                  '${member.isStatic ? 'static ' : ''}${member.fields.keyword?.lexeme ?? ''} ${field.type.getDisplayString()} ${variable.name.lexeme}'
                      .trim(),
              'type': typeFact(field.type),
              'evidence': evidence(variable),
            });
            final fieldRelations = collector(
              '$id/field:${variable.name.lexeme}',
            );
            fieldRelations.typed(
              'field-type',
              member.fields.type ?? variable,
              field.type,
            );
            variable.initializer?.accept(fieldRelations);
          }
        } else if (member is MethodDeclaration ||
            member is ConstructorDeclaration) {
          final ExecutableElement? executable;
          final FunctionBody body;
          final String memberName;
          final String memberKind;
          if (member is MethodDeclaration) {
            executable = member.declaredFragment?.element;
            body = member.body;
            memberName = member.name.lexeme;
            memberKind = member.isGetter
                ? 'getter'
                : member.isSetter
                ? 'setter'
                : member.isOperator
                ? 'operator'
                : 'method';
          } else {
            final constructor = member as ConstructorDeclaration;
            executable = constructor.declaredFragment?.element;
            body = constructor.body;
            memberName = constructor.name?.lexeme ?? 'new';
            memberKind = 'constructor';
          }
          if (executable == null)
            throw StateError('Unresolved member $name.$memberName');
          facts.add({
            'id': '$id/$memberKind:$memberName',
            'name': memberName,
            'kind': memberKind,
            'visibility': memberName.startsWith('_') ? 'private' : 'public',
            'signature': result.content
                .substring(
                  member.firstTokenAfterCommentAndMetadata.offset,
                  member is ConstructorDeclaration
                      ? member.parameters.end
                      : body.offset,
                )
                .trim()
                .replaceAll(RegExp(r'\s+'), ' '),
            'hasBody': body is! EmptyFunctionBody,
            'returnType': typeFact(executable.returnType),
            'parameters': executable.formalParameters
                .map(
                  (param) => {
                    'name': param.name,
                    'type': typeFact(param.type),
                    'named': param.isNamed,
                    'required':
                        param.isRequiredNamed || param.isRequiredPositional,
                  },
                )
                .toList(),
            'evidence': evidence(member),
          });
          final methodRelations = collector('$id/$memberKind:$memberName');
          if (member is MethodDeclaration)
            methodRelations.typed(
              'return-type',
              member.returnType ?? member,
              executable.returnType,
            );
          final parameters = member is MethodDeclaration
              ? member.parameters?.parameters
              : (member as ConstructorDeclaration).parameters.parameters;
          for (
            var index = 0;
            index < executable.formalParameters.length;
            index++
          ) {
            final param = executable.formalParameters[index];
            methodRelations.typed(
              'parameter-type',
              parameters != null && index < parameters.length
                  ? parameters[index]
                  : member,
              param.type,
              parameter: param.name,
            );
          }
          member.accept(methodRelations);
        } else {
          diagnostics.add({
            'code': 'UNSUPPORTED_MEMBER',
            'source': relative,
            'message': 'Member не поддержан: ${member.runtimeType}',
          });
        }
      }
      for (final constant in enumValues) {
        facts.add({
          'id': '$id/enum-value:${constant.name.lexeme}',
          'name': constant.name.lexeme,
          'kind': 'enum-value',
          'visibility': 'public',
          'signature': constant.toSource(),
          'evidence': evidence(constant),
        });
      }
      final comment =
          declaration.documentationComment?.tokens
              .map((t) => t.lexeme.replaceFirst(RegExp(r'^///\s?'), ''))
              .join(' ')
              .trim() ??
          '';
      final parts = relative.split('/');
      final area = parts.length > 1 ? parts.first : 'domain';
      final folder =
          '$area/${parts.length > 2 ? parts.sublist(1, parts.length - 1).join('/') : '.'}';
      final role =
          const {
            'entities': 'entity',
            'models': 'model',
            'ports': 'port',
            'repositories': 'repository',
            'value_objects': 'value-object',
            'failures': 'failure',
          }[parts.length > 2 ? parts[1] : ''] ??
          'declaration';
      final fields = facts
          .where((f) => f['kind'] == 'field')
          .map((f) => f['signature'])
          .toList();
      final methods = facts
          .where((f) => !['field', 'enum-value'].contains(f['kind']))
          .map((f) => f['signature'])
          .toList();
      final inheritedFacts = element is InterfaceElement
          ? element.inheritedMembers.values.map((inherited) {
              final declaring = inherited.enclosingElement;
              return {
                'name': inherited.displayName,
                'declaringType': declaring?.displayName ?? 'unknown',
                'declaringTypeId': declaring == null ? null : symbolId(declaring),
                'overriddenHere': facts.any(
                  (fact) => fact['name'] == inherited.displayName,
                ),
              };
            }).toList()
          : <Map<String, Object?>>[];
      nodes.add({
        'id': id,
        'title': name,
        'kind': kind,
        'area': area,
        'folder': folder,
        'role': role,
        'roleSource': 'directory',
        'importance':
            role == 'entity' && name.toLowerCase() == area.replaceAll('_', '')
            ? 'prominent'
            : ['value-object', 'failure'].contains(role) || kind == 'enum'
            ? 'compact'
            : 'standard',
        'signature': signature.replaceAll(RegExp(r'\s+'), ' '),
        'description': comment.isEmpty
            ? 'Назначение не описано. ${fields.length} полей, ${methods.length} операций.'
            : comment,
        'descriptionSource': comment.isEmpty
            ? 'structural-summary'
            : 'doc-comment',
        'members': enumValues.map((c) => c.name.lexeme).toList(),
        'fields': fields,
        'methods': methods,
        'memberFacts': facts,
        'inheritedFacts': inheritedFacts,
        'evidence': evidence(declaration),
      });
    }
  }
  nodes.sort((a, b) => (a['id'] as String).compareTo(b['id'] as String));
  final libRoot = Directory(domainRoot).parent;
  final outsideFiles =
      libRoot
          .listSync(recursive: true)
          .whereType<File>()
          .where(
            (file) =>
                file.path.endsWith('.dart') &&
                !p.isWithin(domainRoot, file.path) &&
                !file.path.endsWith('.g.dart'),
          )
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  final portIds = nodes
      .where((node) => ['port', 'repository'].contains(node['role']))
      .map((node) => node['id'])
      .toSet();
  final implementations = <Map<String, Object?>>[];
  if (outsideFiles.isNotEmpty) {
    final outsideContexts = AnalysisContextCollection(
      includedPaths: [libRoot.path],
    );
    for (final file in outsideFiles) {
      final parsed = parseString(
        content: file.readAsStringSync(),
        path: file.path,
        throwIfDiagnostics: false,
      );
      if (parsed.errors.isNotEmpty)
        throw StateError(
          '${file.path}: parse errors ${parsed.errors.join('\n')}',
        );
      final result = await outsideContexts
          .contextFor(file.path)
          .currentSession
          .getResolvedUnit(file.path);
      if (result is! ResolvedUnitResult)
        throw StateError('Cannot resolve implementation scan ${file.path}');
      final errors = result.diagnostics.where(
        (d) => d.severity.name == 'ERROR',
      );
      if (errors.isNotEmpty)
        throw StateError('${file.path}: ${errors.join('\n')}');
      for (final declaration
          in result.unit.declarations.whereType<ClassDeclaration>()) {
        final element = declaration.declaredFragment?.element;
        if (element == null) continue;
        for (final interface in element.allSupertypes) {
          final target = symbolId(interface.element);
          if (!portIds.contains(target)) continue;
          final location = result.lineInfo.getLocation(declaration.offset);
          implementations.add({
            'contractId': target,
            'implementationId': symbolId(element),
            'source': p
                .relative(file.path, from: libRoot.path)
                .replaceAll('\\', '/'),
            'line': location.lineNumber,
          });
        }
      }
    }
  }
  return {
    'nodes': nodes,
    'scannedFiles': files.length,
    'diagnostics': diagnostics,
    'relationOccurrences': {
      for (final occurrence in occurrences) occurrence['id']: occurrence,
    }.values.toList(),
    'implementationScan': {
      'root': 'apps/tournament_app/lib',
      'outsideDomainFiles': outsideFiles
          .map(
            (file) =>
                p.relative(file.path, from: libRoot.path).replaceAll('\\', '/'),
          )
          .toList(),
      'found': implementations,
      'limitations': 'Resolved class interfaces outside primary Domain; runtime DI and dynamic dispatch are not proven.',
    },
    'dart': Platform.version.split(' ').first,
    'analyzer': '8.4.1',
  };
}
