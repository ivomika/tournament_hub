import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

abstract final class NavigationBoundaries {
  static List<String> inspect(
    String path,
    String source,
    CompilationUnit unit,
  ) {
    if (!path.startsWith('lib/app/') &&
        !path.startsWith('lib/presentation/') &&
        !path.startsWith('lib/domain/') &&
        !path.startsWith('lib/infrastructure/'))
      return [];
    final visitor = _NavigationVisitor(path, source);
    unit.accept(visitor);
    return visitor.findings;
  }
}

class _NavigationVisitor extends RecursiveAstVisitor<void> {
  _NavigationVisitor(this.path, this.source);
  final String path, source;
  final findings = <String>[];
  void report(AstNode node) {
    final line = '\n'.allMatches(source.substring(0, node.offset)).length + 1;
    findings.add(
      '$path:$line R-003.h: Router navigation belongs to app; use presentation intentions',
    );
  }

  void checkUri(String? uri, AstNode node) {
    if (!path.startsWith('lib/app/') &&
        (uri?.startsWith('package:go_router/') ?? false))
      report(node);
  }

  @override
  void visitImportDirective(ImportDirective node) {
    checkUri(node.uri.stringValue, node);
    for (final alternative in node.configurations) {
      checkUri(alternative.uri.stringValue, alternative);
    }
    super.visitImportDirective(node);
  }

  @override
  void visitExportDirective(ExportDirective node) {
    checkUri(node.uri.stringValue, node);
    for (final alternative in node.configurations) {
      checkUri(alternative.uri.stringValue, alternative);
    }
    super.visitExportDirective(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (path.startsWith('lib/app/')) {
      if (const {
            'go',
            'push',
            'pop',
            'replace',
            'pushReplacement',
            'restore',
            'removeRoute',
            'showDialog',
            'showDatePicker',
            'showModalBottomSheet',
            'showBottomSheet',
          }.contains(node.methodName.name) &&
          !_appAdapter(node))
        report(node);
      super.visitMethodInvocation(node);
      return;
    }
    if (const {
          'showDialog',
          'showDatePicker',
          'showModalBottomSheet',
          'showBottomSheet',
        }.contains(node.methodName.name) &&
        !_localOpener(node))
      report(node);
    final target = node.target?.toSource();
    if ((target == 'Navigator' || (target?.endsWith('.Navigator') ?? false)) &&
        !_localModal(node))
      report(node);
    super.visitMethodInvocation(node);
  }

  ({String owner, String method})? _member(MethodInvocation node) {
    final method = node.thisOrAncestorOfType<MethodDeclaration>();
    final owner = method?.thisOrAncestorOfType<ClassDeclaration>();
    if (method == null || owner == null) return null;
    return (owner: owner.namePart.typeName.lexeme, method: method.name.lexeme);
  }

  bool _appAdapter(MethodInvocation node) {
    final call = node.methodName.name;
    if (const {
          'go',
          'push',
          'pop',
          'replace',
          'pushReplacement',
        }.contains(call) &&
        const {
          'lib/app/navigation/go_router_effect_executor.dart',
          'lib/app/routing/app_routes.g.dart',
        }.contains(path))
      return true;
    final member = _member(node);
    if (member == null) return false;
    if (path == 'lib/app/navigation/go_router_push_interaction_adapter.dart' &&
        member.owner == 'GoRouterPushInteractionAdapter') {
      if (member.method == '_open' && call == 'push') return true;
      return member.method == '_close' &&
          const {'pop', 'restore'}.contains(call);
    }
    if (path == 'lib/app/navigation/flutter_modal_interaction_adapter.dart' &&
        member.owner == 'FlutterModalInteractionAdapter') {
      return switch (member.method) {
        '_openRoute' => call == 'push',
        '_closeRoute' => call == 'removeRoute',
        '_openSheet' => call == 'showBottomSheet',
        _ => false,
      };
    }
    return false;
  }

  bool _localOpener(MethodInvocation node) {
    final member = _member(node);
    if (member == null || member.method != '_open') return false;
    if (path ==
            'lib/presentation/design_system/components/select/app_select.dart' &&
        member.owner == '_AppSelectState' &&
        node.methodName.name == 'showModalBottomSheet')
      return true;
    return path ==
            'lib/presentation/widgetbook/widgets/dialog/overlay/overlay_use_case.dart' &&
        member.owner == '_DialogOverlayState' &&
        node.methodName.name == 'showDialog';
  }

  bool _localModal(MethodInvocation node) {
    AstNode? ancestor = node.parent;
    while (ancestor != null && ancestor is! MethodDeclaration) {
      ancestor = ancestor.parent;
    }
    if (ancestor is! MethodDeclaration) return false;
    final method = ancestor.name.lexeme;
    final parentCall = node.parent;
    if (node.methodName.name != 'of' ||
        parentCall is! MethodInvocation ||
        parentCall.methodName.name != 'pop')
      return false;
    AstNode? owner = ancestor.parent;
    while (owner != null && owner is! ClassDeclaration) {
      owner = owner.parent;
    }
    if (owner is! ClassDeclaration) return false;
    final ownerName = owner.namePart.typeName.lexeme;
    if (path ==
            'lib/presentation/design_system/components/select/app_select.dart' &&
        ownerName == '_SelectModalState' &&
        const {'_choose', '_close'}.contains(method)) {
      return true;
    }
    return path ==
            'lib/presentation/widgetbook/widgets/dialog/overlay/overlay_use_case.dart' &&
        ownerName == '_DialogOverlayState' &&
        method == '_close';
  }
}
