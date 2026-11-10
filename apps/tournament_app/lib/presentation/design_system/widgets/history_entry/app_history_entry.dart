import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/history_entry/app_history_entry_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

class AppHistoryEntry extends StatelessWidget {
  const AppHistoryEntry({
    required this.name,
    required this.dateLabel,
    required this.winnerCharacter,
    required this.winnerName,
    required this.initials,
    required this.onOpen,
    this.prominent = false,
    super.key,
  });
  final String name, dateLabel, winnerCharacter, winnerName, initials;
  final VoidCallback? onOpen;
  final bool prominent;
  @override
  Widget build(BuildContext context) {
    final appearance = AppHistoryEntryTheme.of(context, prominent);
    return InkWell(
      onTap: onOpen,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: appearance.minHeight),
        child: DecoratedBox(
          decoration: appearance.decoration,
          child: Padding(
            padding: appearance.padding,
            child: Column(
              mainAxisSize: appearance.min,
              crossAxisAlignment: appearance.stretch,
              children: [
                Text(dateLabel, style: appearance.caption),
                SizedBox(height: appearance.small),
                Text(name, style: appearance.title),
                SizedBox(height: appearance.small),
                Row(
                  children: [
                    AppIcon(
                      AppGlyph.trophy,
                      color: appearance.accentHero.color,
                    ),
                    SizedBox(width: appearance.small),
                    Expanded(
                      child: AppIdentity(
                        primary: winnerCharacter,
                        initials: initials,
                        secondary: winnerName,
                        theme: appearance.identity,
                      ),
                    ),
                    if (onOpen != null) ...[
                      SizedBox(width: appearance.small),
                      AppIcon(AppGlyph.chevron, color: appearance.body.color),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
