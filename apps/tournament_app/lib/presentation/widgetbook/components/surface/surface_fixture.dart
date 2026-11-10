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
    final appearance = Theme.of(context),
        localizations = FoundationLocalizations.of(context);
    return AppSurface(
      tone: raised ? AppSurfaceTone.raised : AppSurfaceTone.adaptive,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: appearance.extension<FoundationLayout>()!.fullWidth,
            child: Text(
              raised
                  ? localizations.raisedSurfaceSample
                  : localizations.surfaceSample,
              style: appearance.textTheme.bodySmall!.copyWith(
                color: appearance.colorScheme.onSurfaceVariant,
                letterSpacing: appearance
                    .extension<AppTypeRoles>()!
                    .normalTracking,
              ),
            ),
          ),
          if (nested)
            AppSurface(
              tone: AppSurfaceTone.raised,
              shape: AppSurfaceShape.nested,
              child: Text(
                localizations.surfaceLongSample,
                style: appearance.textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
