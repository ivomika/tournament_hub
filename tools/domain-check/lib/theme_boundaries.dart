import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

const _foundation = 'lib/presentation/design_system/foundation/';
const _primitiveGallery =
    'lib/presentation/widgetbook/foundation/colors/primitive_scales/scales_use_case.dart';
const _viewportFixture = 'lib/presentation/widgetbook/visual_viewport.dart';
const _factory = '${_foundation}theme/app_theme.dart';
const _legacyFactory = '${_foundation}app_foundation.dart';

bool _primitive(String path) =>
    path.startsWith('${_foundation}primitives/') ||
    {
      '${_foundation}colors/color_primitives.dart',
      '${_foundation}colors/app_colors.dart',
      '${_foundation}typography/app_typography.dart',
    }.contains(path);

/// AST/namespace boundary check; comments and string contents are never parsed as code.
List<String> inspectThemeBoundaries(
  Map<String, String> sources,
  String packageName,
) {
  final units = <String, CompilationUnit>{};
  for (final entry in sources.entries) {
    final result = parseString(
      content: entry.value,
      path: entry.key,
      throwIfDiagnostics: false,
    );
    if (result.errors.isEmpty) units[entry.key] = result.unit;
  }
  String? target(String? raw) {
    final uri = raw == null ? null : Uri.tryParse(raw);
    if (uri?.scheme != 'package' || uri!.pathSegments.first != packageName)
      return null;
    return 'lib/${uri.pathSegments.skip(1).join('/')}';
  }

  bool exposes(
    String path,
    bool Function(String) predicate,
    Set<String> visited,
  ) {
    if (predicate(path)) return true;
    if (!visited.add(path)) return false;
    for (final directive in units[path]?.directives ?? <Directive>[]) {
      if (directive is! ExportDirective) continue;
      final uris = [
        directive.uri.stringValue,
        ...directive.configurations.map((c) => c.uri.stringValue),
      ];
      for (final raw in uris) {
        final next = target(raw);
        if (next != null && exposes(next, predicate, visited)) return true;
      }
    }
    return false;
  }

  bool flutterExport(String path, Set<String> visited) {
    if (path.startsWith('package:flutter/') || path == 'dart:ui') return true;
    final resolved = target(path);
    if (resolved == null || !visited.add(resolved)) return false;
    return (units[resolved]?.directives.whereType<ExportDirective>() ??
            <ExportDirective>[])
        .any((d) => flutterExport(d.uri.stringValue ?? '', visited));
  }

  // Parts share their parent library's imports, including Flutter prefixes.
  final parents = <String, CompilationUnit>{};
  for (final unit in units.values) {
    for (final part in unit.directives.whereType<PartDirective>()) {
      final resolved = target(part.uri.stringValue);
      if (resolved != null) parents[resolved] = unit;
    }
  }
  final extensionTypes = <String>{};
  final extensionFields = <String>{};
  for (final unit in units.values) {
    for (final cls in unit.declarations.whereType<ClassDeclaration>()) {
      if (cls.extendsClause?.superclass.toSource().contains(
            'ThemeExtension<',
          ) !=
          true)
        continue;
      extensionTypes.add(cls.namePart.typeName.lexeme);
      for (final field in cls.body.members.whereType<FieldDeclaration>()) {
        extensionFields.addAll(
          field.fields.variables.map((v) => v.name.lexeme),
        );
      }
    }
  }
  final problems = <String>[];
  for (final entry in units.entries) {
    final file = entry.key;
    if (!file.startsWith('lib/')) continue;
    final unit = entry.value;
    void report(int offset, String message) {
      final line =
          '\n'.allMatches(sources[file]!.substring(0, offset)).length + 1;
      problems.add('$file:$line R-003.d: $message');
    }

    final namespaces = <String, List<ImportDirective>>{};
    for (final directive in [
      ...unit.directives,
      ...?parents[file]?.directives,
    ].whereType<ImportDirective>()) {
      if (flutterExport(directive.uri.stringValue ?? '', {})) {
        namespaces
            .putIfAbsent(directive.prefix?.name ?? '', () => [])
            .add(directive);
      }
    }
    final localTypes = unit.declarations
        .whereType<ClassDeclaration>()
        .map((d) => d.namePart.typeName.lexeme)
        .toSet();
    bool flutterType(String qualified, String expected) {
      final pieces = qualified.split('.');
      if (pieces.last != expected) return false;
      final prefix = pieces.length > 1 ? pieces.first : '';
      if (prefix.isEmpty && localTypes.contains(expected)) return false;
      return (namespaces[prefix] ?? []).any((importDirective) {
        for (final combinator in importDirective.combinators) {
          if (combinator is ShowCombinator &&
              !combinator.shownNames.any((n) => n.name == expected))
            return false;
          if (combinator is HideCombinator &&
              combinator.hiddenNames.any((n) => n.name == expected))
            return false;
        }
        return true;
      });
    }

    final widgetUnit = unit.declarations.whereType<ClassDeclaration>().any((c) {
      final parent = c.extendsClause?.superclass.toSource().split('<').first;
      return parent != null &&
          [
            'Widget',
            'StatelessWidget',
            'StatefulWidget',
            'State',
            'InheritedWidget',
            'RenderObjectWidget',
          ].any((type) => flutterType(parent, type));
    });
    final allowedDefinition = _primitive(file) || file == _factory;
    if (allowedDefinition && widgetUnit) {
      report(
        0,
        'Primitive/ThemeData assembly не может содержать production widgets',
      );
    }
    final canBuildTheme =
        (file.startsWith('lib/app/') && !widgetUnit) ||
        file == _legacyFactory ||
        file == _factory;
    for (final directive in unit.directives) {
      if (directive is! UriBasedDirective) continue;
      final uris = <String?>[directive.uri.stringValue];
      if (directive is ImportDirective)
        uris.addAll(directive.configurations.map((c) => c.uri.stringValue));
      if (directive is ExportDirective)
        uris.addAll(directive.configurations.map((c) => c.uri.stringValue));
      for (final raw in uris) {
        final resolved = target(raw);
        if (resolved == null) continue;
        if (!allowedDefinition &&
            file != _primitiveGallery &&
            exposes(resolved, _primitive, {})) {
          report(
            directive.offset,
            'Прямой/реэкспортированный primitive доступ запрещён: $raw; используйте текущую FlutterTheme',
          );
        }
        if (!canBuildTheme &&
            exposes(
              resolved,
              (p) => p == _factory || p == _legacyFactory,
              {},
            )) {
          report(
            directive.offset,
            'Widget/WidgetTheme не создаёт фиксированную основную тему: $raw',
          );
        }
      }
    }
    if (allowedDefinition || file == _viewportFixture) continue;
    final aliases = <String, String>{};
    for (final declaration in unit.declarations.whereType<GenericTypeAlias>()) {
      final source = declaration.type.toSource();
      if ([
        'Color',
        'TextStyle',
        'ThemeData',
        'ColorScheme',
        'TextTheme',
      ].any((type) => flutterType(source, type))) {
        aliases[declaration.name.lexeme] = source;
      }
    }
    bool matches(String qualified, String name) =>
        flutterType(aliases[qualified] ?? qualified, name);
    final constants = <String, Expression>{};
    final collector = _ConstantsVisitor(constants);
    unit.accept(collector);
    parents[file]?.accept(collector);
    unit.accept(
      _StyleVisitor(
        matches,
        report,
        namespaces.isNotEmpty,
        extensionTypes,
        extensionFields,
        constants,
      ),
    );
  }
  return problems;
}

const _rawConstructors = {
  'Color',
  'TextStyle',
  'FontVariation',
  'FontFeature',
  'ThemeData',
  'ColorScheme',
  'TextTheme',
};
const _styleConstants = {
  'Colors',
  'FontWeight',
  'FontStyle',
  'TextDecoration',
  'EdgeInsets',
  'BorderRadius',
  'Radius',
  'Alignment',
  'Curves',
  'CrossAxisAlignment',
  'MainAxisAlignment',
  'TextAlign',
};
const _styleObjects = {
  'EdgeInsets',
  'BorderRadius',
  'Radius',
  'BorderSide',
  'Border',
  'BoxShadow',
  'BoxDecoration',
  'ShapeDecoration',
  'Duration',
  'Size',
  'Offset',
};
const _styleArguments = {
  'fontSize',
  'fontFamily',
  'height',
  'width',
  'letterSpacing',
  'wordSpacing',
  'padding',
  'margin',
  'spacing',
  'runSpacing',
  'radius',
  'borderRadius',
  'strokeWidth',
  'thickness',
  'elevation',
  'opacity',
  'duration',
  'minHeight',
  'maxHeight',
  'minWidth',
  'maxWidth',
  'color',
  'backgroundColor',
  'alpha',
};

class _StyleVisitor extends RecursiveAstVisitor<void> {
  _StyleVisitor(
    this.matches,
    this.report,
    this.hasFlutter,
    this.extensionTypes,
    this.extensionFields,
    this.constants,
  );
  final bool Function(String, String) matches;
  final void Function(int, String) report;
  final bool hasFlutter;
  final Set<String> extensionTypes;
  final Set<String> extensionFields;
  final Map<String, Expression> constants;

  bool literal(AstNode node) {
    final visitor = _LiteralVisitor(constants);
    node.accept(visitor);
    return visitor.found;
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final type = node.constructorName.type.toSource();
    checkConstruction(type, node.argumentList, node.offset);
    super.visitInstanceCreationExpression(node);
  }

  void checkConstruction(String type, ArgumentList arguments, int offset) {
    if (_rawConstructors.any((name) => matches(type, name))) {
      report(
        offset,
        'Raw $type вне primitive/ThemeData assembly; используйте runtime тему',
      );
    } else if ((hasFlutter &&
                _styleObjects.any((name) => matches(type, name)) ||
            extensionTypes.contains(type.split('.').last)) &&
        literal(arguments)) {
      report(offset, 'Литеральное оформление $type вне основной темы');
    } else if (hasFlutter) {
      for (final arg in arguments.arguments.whereType<NamedArgument>()) {
        if ((_styleArguments.contains(arg.name.lexeme) ||
                extensionFields.contains(arg.name.lexeme)) &&
            literal(arg.argumentExpression)) {
          report(
            arg.offset,
            'Литеральный style-параметр ${arg.name.lexeme}; получите значение из темы',
          );
        }
      }
    }
  }

  void checkAccess(String owner, String member, int offset) {
    if (_styleConstants.any((type) => matches(owner, type)) ||
        (member == 'new' &&
            _rawConstructors.any((type) => matches(owner, type)))) {
      report(offset, 'Константное оформление $owner.$member вне основной темы');
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    checkAccess(node.prefix.name, node.identifier.name, node.offset);
    super.visitPrefixedIdentifier(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.target != null)
      checkAccess(node.target!.toSource(), node.propertyName.name, node.offset);
    super.visitPropertyAccess(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // Without resolution, implicit constructor calls are MethodInvocation nodes.
    final target = node.target?.toSource();
    final name = node.methodName.name;
    final rawOwner =
        target != null && _rawConstructors.any((type) => matches(target, type));
    final styleOwner =
        target != null && _styleObjects.any((type) => matches(target, type));
    // Named constructors are unresolved invocations as well. lerp is a runtime
    // operation on theme values, not a new primitive definition.
    if (name != 'lerp' && (rawOwner || styleOwner)) {
      checkConstruction(target, node.argumentList, node.offset);
    } else {
      checkConstruction(
        target == null ? name : '$target.$name',
        node.argumentList,
        node.offset,
      );
    }
    if (hasFlutter &&
        {
          'copyWith',
          'withOpacity',
          'withValues',
        }.contains(node.methodName.name)) {
      for (final arg in node.argumentList.arguments) {
        if (arg is NamedArgument &&
            !_styleArguments.contains(arg.name.lexeme) &&
            !extensionFields.contains(arg.name.lexeme))
          continue;
        if (literal(arg))
          report(
            arg.offset,
            'Литеральный style override ${node.methodName.name}; используйте тему',
          );
      }
    }
    super.visitMethodInvocation(node);
  }
}

class _ConstantsVisitor extends RecursiveAstVisitor<void> {
  _ConstantsVisitor(this.constants);
  final Map<String, Expression> constants;
  @override
  void visitVariableDeclarationList(VariableDeclarationList node) {
    if (node.isConst || node.isFinal) {
      for (final variable in node.variables) {
        if (variable.initializer != null)
          constants[variable.name.lexeme] = variable.initializer!;
      }
    }
    super.visitVariableDeclarationList(node);
  }
}

class _LiteralVisitor extends RecursiveAstVisitor<void> {
  _LiteralVisitor(this.constants);
  final Map<String, Expression> constants;
  final visited = <String>{};
  bool found = false;
  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (!visited.add(node.name)) return;
    constants[node.name]?.accept(this);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    // A threshold controlling interpolation is not a style value.
    node.thenExpression.accept(this);
    node.elseExpression.accept(this);
  }

  @override
  void visitIntegerLiteral(IntegerLiteral node) {
    found = true;
  }

  @override
  void visitDoubleLiteral(DoubleLiteral node) {
    found = true;
  }

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    found = true;
  }
}
