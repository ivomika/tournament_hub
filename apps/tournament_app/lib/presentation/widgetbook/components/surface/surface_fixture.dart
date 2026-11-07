import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class SurfaceFixture extends StatelessWidget {
  const SurfaceFixture({this.raised = false, this.nested = false, super.key});
  final bool raised, nested;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context), l = FoundationLocalizations.of(context);
    return AppSurface(
      tone: raised ? AppSurfaceTone.raised : AppSurfaceTone.adaptive,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: t.extension<FoundationLayout>()!.fullWidth,
            child: Text(
              raised ? l.raisedSurfaceSample : l.surfaceSample,
              style: t.textTheme.bodySmall!.copyWith(
                color: t.colorScheme.onSurfaceVariant,
                letterSpacing: t.extension<AppTypeRoles>()!.normalTracking,
              ),
            ),
          ),
          if (nested)
            AppSurface(
              tone: AppSurfaceTone.raised,
              shape: AppSurfaceShape.nested,
              child: Text(l.surfaceLongSample, style: t.textTheme.bodySmall),
            ),
        ],
      ),
    );
  }
}
