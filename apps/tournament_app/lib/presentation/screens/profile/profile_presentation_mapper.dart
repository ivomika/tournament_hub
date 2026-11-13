import 'package:flutter/widgets.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen_state.dart';

abstract final class ProfilePresentationMapper {
  static ProfileScreenState map(LocalProfile profile) {
    final name = profile.name?.value ?? '';
    return ProfileScreenState(name: name, initials: _initials(name));
  }

  static String _initials(String name) {
    final words = name
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '';
    final first = words.first.characters.first.toUpperCase();
    if (words.length == 1) return first;
    return '$first${words.last.characters.first.toUpperCase()}';
  }
}
