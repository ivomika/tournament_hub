import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_profile_data.freezed.dart';

@freezed
abstract class LocalProfileData with _$LocalProfileData {
  const factory LocalProfileData({
    required String id,
    required String nickname,
  }) = _LocalProfileData;
}
