import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/navigation_item/app_navigation_item.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class NavigationFixture extends StatefulWidget {
  const NavigationFixture({
    this.state,
    this.disabled = false,
    this.long = false,
    super.key,
  });
  final WidgetState? state;
  final bool disabled, long;
  @override
  State<NavigationFixture> createState() => _NavigationFixtureState();
}

class _NavigationFixtureState extends State<NavigationFixture> {
  final _states = WidgetStatesController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_apply);
  }

  void _apply(Duration elapsed) {
    if (mounted && widget.state != null) _states.update(widget.state!, true);
  }

  @override
  void didUpdateWidget(covariant NavigationFixture old) {
    super.didUpdateWidget(old);
    if (old.state != widget.state) {
      _states.value = {};
      WidgetsBinding.instance.addPostFrameCallback(_apply);
    }
  }

  void _open() {}
  @override
  void dispose() {
    _states.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = FoundationLocalizations.of(context),
        desktop =
            MediaQuery.sizeOf(context).width >
            Theme.of(context).extension<AppResponsive>()!.mobileToDesktopWidth;
    final child = AppNavigationItem(
      label: widget.long ? l.navigationLong : l.navigationSettings,
      glyph: AppGlyph.settings,
      onPressed: widget.disabled ? null : _open,
      statesController: _states,
    );
    return desktop
        ? child
        : AppSurface(
            shape: AppSurfaceShape.nested,
            tone: AppSurfaceTone.surface,
            inset: AppSurfaceInset.none,
            child: child,
          );
  }
}
