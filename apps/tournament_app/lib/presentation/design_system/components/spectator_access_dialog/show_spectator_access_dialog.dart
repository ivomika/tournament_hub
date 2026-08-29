import 'package:flutter/material.dart';

import 'spectator_access_dialog.dart';
import 'spectator_access_view_data.dart';

Future<void> showSpectatorAccessDialog(
  BuildContext context, {
  required SpectatorAccessViewData data,
  VoidCallback? onCopyAddress,
  VoidCallback? onShare,
  VoidCallback? onRetry,
}) => showDialog<void>(
  context: context,
  useSafeArea: false,
  builder: (dialogContext) => Dialog.fullscreen(
    child: SpectatorAccessDialog(
      data: data,
      onClose: () => Navigator.of(dialogContext).pop(),
      onCopyAddress: onCopyAddress,
      onShare: onShare,
      onRetry: onRetry,
    ),
  ),
);
