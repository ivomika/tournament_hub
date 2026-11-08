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
    final t = AppHistoryEntryTheme.of(context, prominent);
    return InkWell(
      onTap: onOpen,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: t.minHeight),
        child: DecoratedBox(
          decoration: t.decoration,
          child: Padding(
            padding: t.padding,
            child: Column(
              mainAxisSize: t.min,
              crossAxisAlignment: t.stretch,
              children: [
                Text(dateLabel, style: t.caption),
                SizedBox(height: t.small),
                Text(name, style: t.title),
                SizedBox(height: t.small),
                Row(
                  children: [
                    AppIcon(AppGlyph.trophy, color: t.accentHero.color),
                    SizedBox(width: t.small),
                    Expanded(
                      child: AppIdentity(
                        primary: winnerCharacter,
                        initials: initials,
                        secondary: winnerName,
                        theme: t.identity,
                      ),
                    ),
                    if (onOpen != null) ...[
                      SizedBox(width: t.small),
                      AppIcon(AppGlyph.chevron, color: t.body.color),
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
