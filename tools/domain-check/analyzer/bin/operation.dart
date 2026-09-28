import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  final root = Directory.current.parent.parent.parent.absolute.path;
  final file = File(
    p.join(
      root,
      'apps',
      'tournament_app',
      'lib',
      'domain',
      'tournament',
      'entities',
      'tournament.dart',
    ),
  ).absolute;
  final contexts = AnalysisContextCollection(includedPaths: [file.path]);
  final result = await contexts
      .contextFor(file.path)
      .currentSession
      .getResolvedUnit(file.path);
  if (result is! ResolvedUnitResult)
    throw StateError('Cannot resolve ${file.path}');
  final errors = result.diagnostics
      .where((e) => e.severity.name == 'ERROR')
      .toList();
  if (errors.isNotEmpty) throw StateError(errors.join('\n'));
  final methods = MethodCollector();
  result.unit.accept(methods);
  final method = methods.methods.singleWhere(
    (m) => m.name.lexeme == 'removeParticipant',
  );
  Map<String, Object?> trace(MethodDeclaration member) {
    final visitor = OperationVisitor(result, member.name.lexeme);
    member.body.accept(visitor);
    return {
      'name': member.name.lexeme,
      'signature': member.toSource().split('{').first.trim(),
      'steps': visitor.steps,
    };
  }

  final data = {
    'version': 1,
    'owner': 'Tournament',
    'method': 'removeParticipant',
    'source':
        'apps/tournament_app/lib/domain/tournament/entities/tournament.dart',
    'analyzer': '8.4.1',
    'dart': Platform.version.split(' ').first,
    'limitations': [
      'Статическая структура одного метода; это не runtime-трасса.',
      'Цель вызова — объявление контракта, а не выбранная runtime-реализация.',
      'Helpers раскрываются на один уровень; callbacks помечены отдельно.',
    ],
    'operation': trace(method),
    'helpers': methods.methods
        .where((m) => ['_copy', '_requireLifecycle'].contains(m.name.lexeme))
        .map(trace)
        .toList(),
  };
  final serialized = '${const JsonEncoder.withIndent('  ').convert(data)}\n';
  final output = File('$root/tools/domain-check/operation-trace.json');
  if (args.contains('--check')) {
    if (!output.existsSync() ||
        output.readAsStringSync().replaceAll('\r\n', '\n') != serialized) {
      throw StateError(
        'Operation trace outdated. Run make domain-check-operation-generate.',
      );
    }
    print('Validated resolved Tournament.removeParticipant trace.');
  } else {
    output.writeAsStringSync(serialized);
    print('Generated resolved Tournament.removeParticipant trace.');
  }
}

class MethodCollector extends RecursiveAstVisitor<void> {
  final methods = <MethodDeclaration>[];
  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    methods.add(node);
    super.visitMethodDeclaration(node);
  }
}

class OperationVisitor extends RecursiveAstVisitor<void> {
  OperationVisitor(this.result, this.methodName);
  final ResolvedUnitResult result;
  final String methodName;
  final steps = <Map<String, Object?>>[];
  final branches = <String>[];
  void record(String kind, AstNode node, [String? target]) {
    final ordinal = steps.where((step) => step['kind'] == kind).length;
    final location = result.lineInfo.getLocation(node.offset);
    steps.add({
      'id': '$methodName/$kind:$ordinal',
      'kind': kind,
      'code': result.content.substring(node.offset, node.end),
      'line': location.lineNumber,
      'column': location.columnNumber,
      'offset': node.offset,
      'length': node.length,
      'context': [...branches],
      if (target != null) 'target': target,
    });
  }

  @override
  void visitIfStatement(IfStatement node) {
    record('condition', node.expression);
    node.expression.accept(this);
    branches.add('if: ${node.expression.toSource()}');
    node.thenStatement.accept(this);
    branches.removeLast();
    if (node.elseStatement != null) {
      branches.add('else: ${node.expression.toSource()}');
      node.elseStatement!.accept(this);
      branches.removeLast();
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final element = node.methodName.element;
    record(
      'call',
      node,
      element == null
          ? 'unresolved'
          : '${element.enclosingElement?.name ?? ''}.${element.name}',
    );
    super.visitMethodInvocation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    record(
      'constructor',
      node,
      node.constructorName.element?.enclosingElement.name ?? 'unresolved',
    );
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitReturnStatement(ReturnStatement node) {
    record('return', node);
    super.visitReturnStatement(node);
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    record('throw', node);
    super.visitThrowExpression(node);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    record('local', node);
    super.visitVariableDeclaration(node);
  }

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    record('assignment', node);
    super.visitAssignmentExpression(node);
  }

  @override
  void visitNamedExpression(NamedExpression node) {
    record('argument', node);
    super.visitNamedExpression(node);
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    branches.add('callback (порядок вызова определяется вызываемым методом)');
    super.visitFunctionExpression(node);
    branches.removeLast();
  }
}
