import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/share_link/app_share_link_theme.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

/// Displays supplied address and delegates copy intent; no Clipboard/service access.
class AppShareLink extends StatelessWidget {
  const AppShareLink({
    required this.role,
    required this.address,
    required this.copyLabel,
    required this.onCopy,
    this.copyFocusNode,
    super.key,
  });
  final String role, address, copyLabel;
  final VoidCallback? onCopy;
  final FocusNode? copyFocusNode;
  @override
  Widget build(BuildContext context) {
    final t = AppShareLinkTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(color: t.background, borderRadius: t.radius),
      child: Padding(
        padding: t.padding,
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$role\n${address.replaceAll('/', '/\u2060')}',
                semanticsLabel: '$role\n$address',
                style: t.style,
              ),
            ),
            SizedBox(width: t.gap),
            AppButton(
              label: copyLabel,
              kind: AppButtonKind.shareIcon,
              glyph: AppGlyph.shareLink,
              onPressed: onCopy,
              focusNode: copyFocusNode,
            ),
          ],
        ),
      ),
    );
  }
}
