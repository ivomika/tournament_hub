import 'package:flutter/material.dart';

import '../ds_text/ds_text.dart';
import 'app_shell_theme.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppShellTheme>()!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= theme.desktopBreakpoint;
        final content = SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(theme.pagePadding),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: theme.contentMaxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DsText(title, variant: DsTextVariant.heading),
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
          body: desktop
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
