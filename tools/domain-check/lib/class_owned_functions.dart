import 'package:analyzer/dart/ast/ast.dart';

/// Проверяет только декларации библиотеки: методы и локальные функции остаются
/// под действием остальных правил, но не являются нарушением R-003.g.
abstract final class ClassOwnedFunctions {
  static List<String> inspect(
    String path,
    String source,
    CompilationUnit unit,
  ) {
    if (!path.startsWith('lib/') && !path.startsWith('test/')) return [];
    final problems = <String>[];
    void report(int offset, String name) {
      final line = '\n'.allMatches(source.substring(0, offset)).length + 1;
      problems.add(
        '$path:$line R-003.g: Верхнеуровневая функция $name запрещена; перенесите поведение в класс',
      );
    }

    for (final declaration in unit.declarations) {
      if (declaration is FunctionDeclaration) {
        if (path == 'lib/app/routing/app_routes.g.dart' &&
            declaration.isGetter &&
            const {r'$appRoutes', r'$homeRoute', r'$bootstrapRoute'}.contains(declaration.name.lexeme) &&
            unit.directives.whereType<PartOfDirective>().any((directive) => directive.uri?.stringValue == 'app_routes.dart')) {
          continue;
        }
        if (unit.directives.any((d) => d is PartOfDirective) ||
            !_frameworkEntry(path, declaration)) {
          report(declaration.name.offset, declaration.name.lexeme);
        }
      } else if (declaration is TopLevelVariableDeclaration) {
        for (final variable in declaration.variables.variables) {
          Expression? value = variable.initializer;
          while (value is ParenthesizedExpression) {
            value = value.expression;
          }
          if (value is FunctionExpression) {
            report(variable.name.offset, variable.name.lexeme);
          }
        }
      }
    }
    return problems;
  }

  static bool _frameworkEntry(String path, FunctionDeclaration declaration) {
    if (declaration.isGetter || declaration.isSetter) return false;
    final name = declaration.name.lexeme;
    if (name == 'main') {
      return RegExp(r'^lib/main(?:_[a-z0-9_]+)?\.dart$').hasMatch(path) ||
          (path.startsWith('test/') && path.endsWith('_test.dart'));
    }
    if (name == 'testExecutable') {
      return path == 'test/flutter_test_config.dart';
    }
    return name == 'lookupFoundationLocalizations' &&
        path == 'lib/presentation/l10n/generated/foundation_localizations.dart';
  }
}
