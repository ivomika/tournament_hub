import 'package:flutter/material.dart';

import '../action_dock/action_dock.dart';
import '../page_header/page_header.dart';
import '../responsive_actions/responsive_actions.dart';
import 'app_navigation_role.dart';
import 'app_shell_theme.dart';

enum AppDestination { home, history, profile, settings }

class AppShell extends StatelessWidget {
  const AppShell({
    required this.title,
    required this.child,
    this.subtitle,
    this.sectionLabel = 'TOURNAMENT HUB',
    this.currentDestination = AppDestination.home,
    this.onDestinationSelected,
    this.headerTrailing,
    this.headerVariant = PageHeaderVariant.standard,
    this.pageActions,
    this.actionDock,
    this.navigationRole = AppNavigationRole.host,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String sectionLabel;
  final AppDestination currentDestination;
  final ValueChanged<AppDestination>? onDestinationSelected;
  final Widget? headerTrailing;
  final PageHeaderVariant headerVariant;
  final ResponsiveActions? pageActions;
  final ActionDock? actionDock;
  final AppNavigationRole navigationRole;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppShellTheme>()!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= theme.desktopBreakpoint;
        final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
        final keyboardOpen = keyboardInset > 0;
        final defaultFontSize =
            DefaultTextStyle.of(context).style.fontSize ??
            Theme.of(context).textTheme.bodyMedium!.fontSize!;
        final textScale =
            MediaQuery.textScalerOf(context).scale(defaultFontSize) /
            defaultFontSize;
        final pagePadding = desktop
            ? theme.pagePaddingDesktop
            : constraints.maxWidth >= theme.mediumBreakpoint
            ? theme.pagePaddingMedium
            : theme.pagePaddingCompact;
        final destinations = _destinationsFor(navigationRole);
        final selectedIndex = destinations.indexOf(currentDestination);
        final showMobileDock = !desktop && actionDock != null;
        final fixedStackMaxFraction =
            constraints.maxWidth > constraints.maxHeight
            ? theme.landscapeFixedStackMaxFraction
            : theme.portraitFixedStackMaxFraction;
        final fixedStackFits =
            theme.navigationHeight + theme.actionDockEstimatedHeight <=
            constraints.maxHeight * fixedStackMaxFraction;
        final showMobileNavigation =
            !desktop &&
            destinations.isNotEmpty &&
            !keyboardOpen &&
            (!showMobileDock ||
                (fixedStackFits &&
                    textScale <= theme.navigationWithDockMaxTextScale));
        final content = SafeArea(
          child: SingleChildScrollView(
            key: const Key('app-shell-scroll-view'),
            padding: EdgeInsets.fromLTRB(
              pagePadding,
              pagePadding,
              pagePadding,
              pagePadding +
                  (showMobileDock ? theme.contentGap : EdgeInsets.zero.bottom),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeader(
                  title: title,
                  subtitle: subtitle,
                  sectionLabel: sectionLabel,
                  trailing:
                      desktop &&
                          (headerTrailing != null ||
                              pageActions != null ||
                              actionDock != null)
                      ? _DesktopTrailing(
                          contextWidget: headerTrailing,
                          actions: actionDock != null
                              ? ActionDock.toolbar(
                                  primary: actionDock!.primary,
                                  contextual: actionDock!.contextual,
                                  secondary: actionDock!.secondary,
                                  destructive: actionDock!.destructive,
                                )
                              : pageActions == null
                              ? null
                              : ResponsiveActions(
                                  primary: pageActions!.primary,
                                  secondary: pageActions!.secondary,
                                  destructive: pageActions!.destructive,
                                  overflow: pageActions!.overflow,
                                  layout: ResponsiveActionsLayout.horizontal,
                                ),
                          gap: theme.contentGap,
                        )
                      : headerTrailing,
                  variant: headerVariant,
                ),
                if (!desktop && pageActions != null && actionDock == null) ...[
                  SizedBox(height: theme.contentGap),
                  ResponsiveActions(
                    primary: pageActions!.primary,
                    secondary: pageActions!.secondary,
                    destructive: pageActions!.destructive,
                    overflow: pageActions!.overflow,
                  ),
                ],
                SizedBox(height: theme.contentGap),
                Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: theme.contentMaxWidth,
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        );
        return Scaffold(
          backgroundColor: theme.background,
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [theme.elevatedBackground, theme.background],
              ),
            ),
            child: desktop && destinations.isNotEmpty
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      NavigationRail(
                        backgroundColor: theme.navigationBackground,
                        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
                        onDestinationSelected: onDestinationSelected == null
                            ? null
                            : (index) =>
                                  onDestinationSelected!(destinations[index]),
                        destinations: [
                          for (final destination in destinations)
                            _railDestination(destination),
                        ],
                      ),
                      VerticalDivider(color: theme.divider),
                      Expanded(child: content),
                    ],
                  )
                : content,
          ),
          bottomNavigationBar: !showMobileDock && !showMobileNavigation
              ? null
              : Padding(
                  padding: EdgeInsets.only(
                    bottom: showMobileDock
                        ? keyboardInset
                        : EdgeInsets.zero.bottom,
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showMobileDock) actionDock!,
                        if (showMobileNavigation)
                          NavigationBar(
                            height: theme.navigationHeight,
                            backgroundColor: theme.navigationBackground,
                            selectedIndex: selectedIndex < 0
                                ? 0
                                : selectedIndex,
                            onDestinationSelected: onDestinationSelected == null
                                ? null
                                : (index) => onDestinationSelected!(
                                    destinations[index],
                                  ),
                            destinations: [
                              for (final destination in destinations)
                                _barDestination(destination),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  List<AppDestination> _destinationsFor(AppNavigationRole role) =>
      switch (role) {
        AppNavigationRole.host => AppDestination.values,
        AppNavigationRole.participant => const [
          AppDestination.home,
          AppDestination.profile,
        ],
        AppNavigationRole.spectator => const [],
        AppNavigationRole.focused => const [],
      };

  NavigationRailDestination _railDestination(AppDestination destination) =>
      switch (destination) {
        AppDestination.home => const NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Главная'),
        ),
        AppDestination.history => const NavigationRailDestination(
          icon: Icon(Icons.history),
          label: Text('История'),
        ),
        AppDestination.profile => const NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Профиль'),
        ),
        AppDestination.settings => const NavigationRailDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: Text('Настройки'),
        ),
      };

  NavigationDestination _barDestination(AppDestination destination) =>
      switch (destination) {
        AppDestination.home => const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Главная',
        ),
        AppDestination.history => const NavigationDestination(
          icon: Icon(Icons.history),
          label: 'История',
        ),
        AppDestination.profile => const NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Профиль',
        ),
        AppDestination.settings => const NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Настройки',
        ),
      };
}

class _DesktopTrailing extends StatelessWidget {
  const _DesktopTrailing({
    required this.contextWidget,
    required this.actions,
    required this.gap,
  });

  final Widget? contextWidget;
  final Widget? actions;
  final double gap;

  @override
  Widget build(BuildContext context) {
    if (contextWidget == null && actions == null) {
      return const SizedBox.shrink();
    }
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: gap,
      runSpacing: gap,
      children: [?contextWidget, ?actions],
    );
  }
}
