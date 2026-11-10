import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

abstract final class CodeReadability {
  static List<String> inspect(
    String path,
    String source,
    CompilationUnit unit,
  ) {
    if (!path.startsWith('lib/') && !path.startsWith('test/')) return [];
    final visitor = _ReadabilityVisitor(path, source, unit);
    unit.accept(visitor);
    return visitor.problems;
  }
}

class _ReadabilityVisitor extends RecursiveAstVisitor<void> {
  _ReadabilityVisitor(this.path, this.source, this.unit);
  final String path;
  final String source;
  final CompilationUnit unit;
  final problems = <String>[];
  final _reportedOffsets = <int>{};

  void _report(int offset, String rule, String message) {
    final line = '\n'.allMatches(source.substring(0, offset)).length + 1;
    problems.add('$path:$line $rule: $message');
  }

  void _name(String name, int offset, AstNode declaration) {
    if (name == '_') return;
    final normalized = name.replaceFirst(RegExp(r'^_+'), '');
    final segments = normalized
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (match) => '${match[1]}_${match[2]}',
        )
        .split('_')
        .map((segment) => segment.toLowerCase());
    final abbreviated =
        normalized.runes.length == 1 ||
        segments.any(const {'ctx', 'cfg', 'args'}.contains);
    if (!abbreviated || _coordinate(name, declaration)) return;
    if (_reportedOffsets.add(offset)) {
      _report(
        offset,
        'R-008.a',
        'Сокращённое имя $name: укажите назначение переменной полностью',
      );
    }
  }

  bool _coordinate(String name, AstNode declaration) {
    if (name != 'x' && name != 'y') return false;
    if (declaration is! VariableDeclaration ||
        declaration.parent is! VariableDeclarationList)
      return false;
    final list = declaration.parent! as VariableDeclarationList;
    if (!const {'double', 'int', 'num'}.contains(list.type?.toSource()))
      return false;
    if (list.parent is! VariableDeclarationStatement) return false;
    AstNode? ancestor = declaration.parent;
    while (ancestor != null && ancestor is! MethodDeclaration) {
      if (ancestor is FunctionExpression || ancestor is FunctionDeclaration)
        return false;
      ancestor = ancestor.parent;
    }
    if (ancestor is! MethodDeclaration ||
        ancestor.name.lexeme != 'paint' ||
        ancestor.isStatic)
      return false;
    AstNode? owner = ancestor.parent;
    while (owner != null && owner is! ClassDeclaration) {
      owner = owner.parent;
    }
    if (owner is! ClassDeclaration) return false;
    if (unit.declarations.whereType<ClassDeclaration>().any(
      (element) => element.namePart.typeName.lexeme == 'CustomPainter',
    ))
      return false;
    final supertype = owner.extendsClause?.superclass.toSource();
    return unit.directives.whereType<ImportDirective>().any((directive) {
      if (!const {
        'package:flutter/rendering.dart',
        'package:flutter/painting.dart',
        'package:flutter/widgets.dart',
        'package:flutter/material.dart',
      }.contains(directive.uri.stringValue))
        return false;
      final prefix = directive.prefix?.name;
      final expected = prefix == null
          ? 'CustomPainter'
          : '$prefix.CustomPainter';
      if (supertype != expected) return false;
      for (final combinator in directive.combinators) {
        if (combinator is HideCombinator &&
            combinator.hiddenNames.any(
              (element) => element.name == 'CustomPainter',
            ))
          return false;
        if (combinator is ShowCombinator &&
            !combinator.shownNames.any(
              (element) => element.name == 'CustomPainter',
            ))
          return false;
      }
      return true;
    });
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    _name(node.name.lexeme, node.name.offset, node);
    super.visitVariableDeclaration(node);
  }

  @override
  void visitRegularFormalParameter(RegularFormalParameter node) {
    final name = node.name;
    if (name != null) _name(name.lexeme, name.offset, node);
    super.visitRegularFormalParameter(node);
  }

  @override
  void visitFieldFormalParameter(FieldFormalParameter node) {
    _name(node.name.lexeme, node.name.offset, node);
    super.visitFieldFormalParameter(node);
  }

  @override
  void visitSuperFormalParameter(SuperFormalParameter node) {
    _name(node.name.lexeme, node.name.offset, node);
    super.visitSuperFormalParameter(node);
  }

  @override
  void visitDeclaredIdentifier(DeclaredIdentifier node) {
    _name(node.name.lexeme, node.name.offset, node);
    super.visitDeclaredIdentifier(node);
  }

  @override
  void visitDeclaredVariablePattern(DeclaredVariablePattern node) {
    _name(node.name.lexeme, node.name.offset, node);
    super.visitDeclaredVariablePattern(node);
  }

  @override
  void visitCatchClause(CatchClause node) {
    for (final parameter in [
      node.exceptionParameter,
      node.stackTraceParameter,
    ]) {
      if (parameter != null)
        _name(parameter.name.lexeme, parameter.name.offset, node);
    }
    super.visitCatchClause(node);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    AstNode? ancestor = node.parent;
    while (ancestor != null && ancestor is! FunctionBody) {
      if (ancestor is ConditionalExpression) {
        _report(
          node.question.offset,
          'R-008.b',
          'Вложенный ?: запрещён; выделите именованный метод с явными if/switch',
        );
        break;
      }
      ancestor = ancestor.parent;
    }
    super.visitConditionalExpression(node);
  }
}
