import 'package:flutter/material.dart';

import '../page_header/page_header.dart';
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
    super.key,
  });

  final String title;
  final String? subtitle;
  final String sectionLabel;
  final AppDestination currentDestination;
  final ValueChanged<AppDestination>? onDestinationSelected;
  final Widget? headerTrailing;
  final PageHeaderVariant headerVariant;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppShellTheme>()!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= theme.desktopBreakpoint;
        final pagePadding = desktop
            ? theme.pagePaddingDesktop
            : theme.pagePaddingCompact;
        final content = SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeader(
                  title: title,
                  subtitle: subtitle,
                  sectionLabel: sectionLabel,
                  trailing: headerTrailing,
                  variant: headerVariant,
                ),
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
            child: desktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      NavigationRail(
                        backgroundColor: theme.navigationBackground,
                        selectedIndex: currentDestination.index,
                        onDestinationSelected: onDestinationSelected == null
                            ? null
                            : (index) => onDestinationSelected!(
                                AppDestination.values[index],
                              ),
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.home_outlined),
                            selectedIcon: Icon(Icons.home),
                            label: Text('Главная'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.history),
                            label: Text('История'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.person_outline),
                            label: Text('Профиль'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.settings_outlined),
                            label: Text('Настройки'),
                          ),
                        ],
                      ),
                      VerticalDivider(color: theme.divider),
                      Expanded(child: content),
                    ],
                  )
                : content,
          ),
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  backgroundColor: theme.navigationBackground,
                  selectedIndex: currentDestination.index,
                  onDestinationSelected: onDestinationSelected == null
                      ? null
                      : (index) => onDestinationSelected!(
                          AppDestination.values[index],
                        ),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: 'Главная',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.history),
                      label: 'История',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person),
                      label: 'Профиль',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings),
                      label: 'Настройки',
                    ),
                  ],
                ),
        );
      },
    );
  }
}
