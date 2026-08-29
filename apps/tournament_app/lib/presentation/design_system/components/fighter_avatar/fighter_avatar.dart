import 'package:flutter/material.dart';

import 'fighter_avatar_theme.dart';

enum FighterArtworkVariant { compact, standard, matchup, hero }

class FighterAvatar extends StatelessWidget {
  const FighterAvatar({
    required this.fighterId,
    required this.fighterName,
    this.variant = FighterArtworkVariant.standard,
    super.key,
  });

  final String fighterId;
  final String fighterName;
  final FighterArtworkVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<FighterAvatarTheme>()!;
    final (size, placeholderSize) = switch (variant) {
      FighterArtworkVariant.compact => (
        theme.compactSize,
        theme.compactPlaceholderSize,
      ),
      FighterArtworkVariant.standard => (
        theme.standardSize,
        theme.standardPlaceholderSize,
      ),
      FighterArtworkVariant.matchup => (
        theme.matchupSize,
        theme.matchupPlaceholderSize,
      ),
      FighterArtworkVariant.hero => (theme.heroSize, theme.heroPlaceholderSize),
    };
    final prominent =
        variant == FighterArtworkVariant.matchup ||
        variant == FighterArtworkVariant.hero;
    return Semantics(
      image: true,
      label: 'Изображение персонажа $fighterName',
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: prominent ? theme.prominentBackground : theme.background,
          border: Border.all(
            color: prominent ? theme.prominentBorder : theme.border,
          ),
          borderRadius: BorderRadius.circular(theme.radius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(theme.radius),
          child: Image.asset(
            'assets/fighters/$fighterId.png',
            width: size,
            height: size,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => SizedBox.square(
              dimension: size,
              child: Icon(
                Icons.sports_martial_arts,
                color: theme.foreground,
                size: placeholderSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
