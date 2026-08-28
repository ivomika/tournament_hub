import 'package:flutter/material.dart';

import '../ds_text/ds_text.dart';
import 'app_shell_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    required this.title,
    required this.child,
    this.subtitle,
    this.sectionLabel = 'TOURNAMENT HUB',
    super.key,
  });

  final String title;
  final String? subtitle;
  final String sectionLabel;
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
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: theme.contentMaxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(color: theme.accent),
                          child: SizedBox(
                            width: theme.brandMarkWidth,
                            height: theme.headingGap,
                          ),
                        ),
                        SizedBox(width: theme.labelGap),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DsText(
                                sectionLabel,
                                variant: DsTextVariant.label,
                              ),
                              SizedBox(height: theme.labelGap),
                              DsText(title, variant: DsTextVariant.heading),
                              if (subtitle != null) ...[
                                SizedBox(height: theme.labelGap),
                                DsText(
                                  subtitle!,
                                  variant: DsTextVariant.secondary,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: theme.headingGap),
                    child,
                  ],
                ),
              ),
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
                    children: [
                      NavigationRail(
                        backgroundColor: theme.navigationBackground,
                        selectedIndex: 0,
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
                  selectedIndex: 0,
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
                  ],
                ),
        );
      },
    );
  }
}
