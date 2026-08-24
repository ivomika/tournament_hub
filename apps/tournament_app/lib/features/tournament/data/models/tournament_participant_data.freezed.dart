// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_participant_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TournamentParticipantData {

 String get id; String get nickname; String get source; int get position;
/// Create a copy of TournamentParticipantData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentParticipantDataCopyWith<TournamentParticipantData> get copyWith => _$TournamentParticipantDataCopyWithImpl<TournamentParticipantData>(this as TournamentParticipantData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentParticipantData&&(identical(other.id, id) || other.id == id)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.source, source) || other.source == source)&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,id,nickname,source,position);

@override
String toString() {
  return 'TournamentParticipantData(id: $id, nickname: $nickname, source: $source, position: $position)';
}


}

/// @nodoc
abstract mixin class $TournamentParticipantDataCopyWith<$Res>  {
  factory $TournamentParticipantDataCopyWith(TournamentParticipantData value, $Res Function(TournamentParticipantData) _then) = _$TournamentParticipantDataCopyWithImpl;
@useResult
$Res call({
 String id, String nickname, String source, int position
});




}
/// @nodoc
class _$TournamentParticipantDataCopyWithImpl<$Res>
    implements $TournamentParticipantDataCopyWith<$Res> {
  _$TournamentParticipantDataCopyWithImpl(this._self, this._then);

  final TournamentParticipantData _self;
  final $Res Function(TournamentParticipantData) _then;

/// Create a copy of TournamentParticipantData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nickname = null,Object? source = null,Object? position = null,}) {
  return _then(TournamentParticipantData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TournamentParticipantData].
extension TournamentParticipantDataPatterns on TournamentParticipantData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TournamentParticipantData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TournamentParticipantData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TournamentParticipantData value)  $default,){
final _that = this;
switch (_that) {
case _TournamentParticipantData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TournamentParticipantData value)?  $default,){
final _that = this;
switch (_that) {
case _TournamentParticipantData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nickname,  String source,  int position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TournamentParticipantData() when $default != null:
return $default(_that.id,_that.nickname,_that.source,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nickname,  String source,  int position)  $default,) {final _that = this;
switch (_that) {
case _TournamentParticipantData():
return $default(_that.id,_that.nickname,_that.source,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nickname,  String source,  int position)?  $default,) {final _that = this;
switch (_that) {
case _TournamentParticipantData() when $default != null:
return $default(_that.id,_that.nickname,_that.source,_that.position);case _:
  return null;

}
}

}

/// @nodoc


class _TournamentParticipantData implements TournamentParticipantData {
  const _TournamentParticipantData({required this.id, required this.nickname, required this.source, required this.position});


@override final  String id;
@override final  String nickname;
@override final  String source;
@override final  int position;

/// Create a copy of TournamentParticipantData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentParticipantDataCopyWith<_TournamentParticipantData> get copyWith => __$TournamentParticipantDataCopyWithImpl<_TournamentParticipantData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TournamentParticipantData&&(identical(other.id, id) || other.id == id)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.source, source) || other.source == source)&&(identical(other.position, position) || other.position == position));
}


@override
int get hashCode => Object.hash(runtimeType,id,nickname,source,position);

@override
String toString() {
  return 'TournamentParticipantData(id: $id, nickname: $nickname, source: $source, position: $position)';
}


}

/// @nodoc
abstract mixin class _$TournamentParticipantDataCopyWith<$Res> implements $TournamentParticipantDataCopyWith<$Res> {
  factory _$TournamentParticipantDataCopyWith(_TournamentParticipantData value, $Res Function(_TournamentParticipantData) _then) = __$TournamentParticipantDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String nickname, String source, int position
});




}
/// @nodoc
class __$TournamentParticipantDataCopyWithImpl<$Res>
    implements _$TournamentParticipantDataCopyWith<$Res> {
  __$TournamentParticipantDataCopyWithImpl(this._self, this._then);

  final _TournamentParticipantData _self;
  final $Res Function(_TournamentParticipantData) _then;

/// Create a copy of TournamentParticipantData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nickname = null,Object? source = null,Object? position = null,}) {
  return _then(_TournamentParticipantData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
