// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_profile_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalProfileData {

 String get id; String get nickname;
/// Create a copy of LocalProfileData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalProfileDataCopyWith<LocalProfileData> get copyWith => _$LocalProfileDataCopyWithImpl<LocalProfileData>(this as LocalProfileData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalProfileData&&(identical(other.id, id) || other.id == id)&&(identical(other.nickname, nickname) || other.nickname == nickname));
}


@override
int get hashCode => Object.hash(runtimeType,id,nickname);

@override
String toString() {
  return 'LocalProfileData(id: $id, nickname: $nickname)';
}


}

/// @nodoc
abstract mixin class $LocalProfileDataCopyWith<$Res>  {
  factory $LocalProfileDataCopyWith(LocalProfileData value, $Res Function(LocalProfileData) _then) = _$LocalProfileDataCopyWithImpl;
@useResult
$Res call({
 String id, String nickname
});




}
/// @nodoc
class _$LocalProfileDataCopyWithImpl<$Res>
    implements $LocalProfileDataCopyWith<$Res> {
  _$LocalProfileDataCopyWithImpl(this._self, this._then);

  final LocalProfileData _self;
  final $Res Function(LocalProfileData) _then;

/// Create a copy of LocalProfileData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nickname = null,}) {
  return _then(LocalProfileData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LocalProfileData].
extension LocalProfileDataPatterns on LocalProfileData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalProfileData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalProfileData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalProfileData value)  $default,){
final _that = this;
switch (_that) {
case _LocalProfileData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalProfileData value)?  $default,){
final _that = this;
switch (_that) {
case _LocalProfileData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nickname)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalProfileData() when $default != null:
return $default(_that.id,_that.nickname);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nickname)  $default,) {final _that = this;
switch (_that) {
case _LocalProfileData():
return $default(_that.id,_that.nickname);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nickname)?  $default,) {final _that = this;
switch (_that) {
case _LocalProfileData() when $default != null:
return $default(_that.id,_that.nickname);case _:
  return null;

}
}

}

/// @nodoc


class _LocalProfileData implements LocalProfileData {
  const _LocalProfileData({required this.id, required this.nickname});
  

@override final  String id;
@override final  String nickname;

/// Create a copy of LocalProfileData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalProfileDataCopyWith<_LocalProfileData> get copyWith => __$LocalProfileDataCopyWithImpl<_LocalProfileData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalProfileData&&(identical(other.id, id) || other.id == id)&&(identical(other.nickname, nickname) || other.nickname == nickname));
}


@override
int get hashCode => Object.hash(runtimeType,id,nickname);

@override
String toString() {
  return 'LocalProfileData(id: $id, nickname: $nickname)';
}


}

/// @nodoc
abstract mixin class _$LocalProfileDataCopyWith<$Res> implements $LocalProfileDataCopyWith<$Res> {
  factory _$LocalProfileDataCopyWith(_LocalProfileData value, $Res Function(_LocalProfileData) _then) = __$LocalProfileDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String nickname
});




}
/// @nodoc
class __$LocalProfileDataCopyWithImpl<$Res>
    implements _$LocalProfileDataCopyWith<$Res> {
  __$LocalProfileDataCopyWithImpl(this._self, this._then);

  final _LocalProfileData _self;
  final $Res Function(_LocalProfileData) _then;

/// Create a copy of LocalProfileData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nickname = null,}) {
  return _then(_LocalProfileData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
