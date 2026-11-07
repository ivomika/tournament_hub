enum AppBracketState { ready, current, pending }

sealed class AppBracketSlot {
  const AppBracketSlot();
}

class AppBracketParticipant extends AppBracketSlot {
  const AppBracketParticipant({
    required this.primary,
    required this.secondary,
    required this.initials,
  });
  final String primary, secondary, initials;
}

class AppBracketPlaceholder extends AppBracketSlot {
  const AppBracketPlaceholder(this.text);
  final String text;
}
