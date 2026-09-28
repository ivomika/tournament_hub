import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import 'symbols.dart';

class RelationCollector extends RecursiveAstVisitor<void> {
  RelationCollector(
    this.result,
    this.source,
    this.sourceId,
    this.sourceMemberId,
    this.output,
  );
  final ResolvedUnitResult result;
  final String source;
  final String sourceId;
  final String? sourceMemberId;
  final List<Map<String, Object?>> output;

  void record(
    String kind,
    AstNode node,
    Element? element, {
    DartType? type,
    String? status,
    String? parameter,
  }) {
    Element? owner = element;
    while (owner != null &&
        owner is! InterfaceElement &&
        owner is! LibraryElement) {
      owner = owner.enclosingElement;
    }
    final target = owner is InterfaceElement
        ? symbolId(owner)
        : element == null
        ? null
        : symbolId(element);
    final location = result.lineInfo.getLocation(node.offset);
    final resolution =
        status ?? (element == null ? 'unresolved' : 'resolved-single');
    output.add({
      'id':
          '$sourceId/${sourceMemberId ?? 'declaration'}/$kind:${node.offset}:${element == null ? resolution : symbolId(element)}${parameter == null ? '' : ':$parameter'}:${type?.getDisplayString() ?? ''}',
      'sourceId': sourceId,
      'sourceMemberId': sourceMemberId,
      'targetId': target,
      'targetSymbol': element == null ? null : symbolId(element),
      'targetName': owner is InterfaceElement ? owner.name : element?.name,
      'targetMember': element is ExecutableElement ? element.name : null,
      'kind': kind,
      'resolution': resolution,
      if (parameter != null) 'parameter': parameter,
      if (type != null) 'type': typeFact(type),
      'evidence': {
        'source': source,
        'line': location.lineNumber,
        'column': location.columnNumber,
        'offset': node.offset,
        'length': node.length,
        'code': result.content.substring(node.offset, node.end),
      },
    });
  }

  void typed(String kind, AstNode node, DartType type, {String? parameter}) {
    // Type parameters are local generic bindings, not dependencies on their owner.
    if (type is TypeParameterType || type is VoidType || type is NeverType)
      return;
    if (type is InterfaceType)
      record(kind, node, type.element, type: type, parameter: parameter);
    if (type is DynamicType || type is InvalidType)
      record(
        kind,
        node,
        null,
        type: type,
        status: type is DynamicType ? 'dynamic' : 'unresolved',
        parameter: parameter,
      );
    if (type is ParameterizedType) {
      for (final argument in type.typeArguments) {
        typed(
          ['extends', 'implements', 'mixin'].contains(kind) ? 'type-use' : kind,
          node,
          argument,
          parameter: parameter,
        );
      }
    }
    if (type is FunctionType) {
      typed(kind, node, type.returnType, parameter: parameter);
      for (final param in type.formalParameters) {
        typed(kind, node, param.type, parameter: parameter);
      }
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final element = node.methodName.element;
    record(
      'call',
      node,
      element,
      status: element == null && node.target?.staticType is DynamicType
          ? 'dynamic'
          : null,
    );
    super.visitMethodInvocation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    record('create', node, node.constructorName.element);
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {
    record('constructor-call', node, node.element);
    super.visitSuperConstructorInvocation(node);
  }

  @override
  void visitRedirectingConstructorInvocation(
    RedirectingConstructorInvocation node,
  ) {
    record('constructor-call', node, node.element);
    super.visitRedirectingConstructorInvocation(node);
  }
}
