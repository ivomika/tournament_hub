import 'dart:convert';

import 'package:tournament_app/domain/identifiers/unique_identifier.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/domain/profile/profile_exception.dart';
import 'package:tournament_app/domain/profile/profile_id.dart';
import 'package:tournament_app/domain/profile/profile_name.dart';

abstract final class ProfileCodec {
  static final _identifierFormat = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  static String encode(LocalProfile profile) => jsonEncode({
    'version': 1,
    'id': profile.id.value.value,
    'name': profile.name?.value,
  });

  static LocalProfile decode(String payload) {
    try {
      final Object? decoded = jsonDecode(payload);
      if (decoded case {'version': 1, 'id': final String identifier}) {
        final Object? name = (decoded as Map<String, Object?>)['name'];
        if (!_identifierFormat.hasMatch(identifier) ||
            (name != null && name is! String)) {
          throw const FormatException('Invalid local profile fields');
        }
        final input = name as String?;
        return LocalProfile(
          id: ProfileId(UniqueIdentifier(identifier)),
          name: input == null || input.trim().isEmpty
              ? null
              : ProfileName(input),
        );
      }
      throw const FormatException('Unsupported local profile record');
    } catch (error) {
      throw ProfileException(ProfileFailureReason.corrupt, cause: error);
    }
  }
}
