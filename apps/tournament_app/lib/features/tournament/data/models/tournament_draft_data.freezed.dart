// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_draft_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TournamentDraftData {

 String get id; String get name; String get status; List<TournamentParticipantData> get participants;
/// Create a copy of TournamentDraftData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TournamentDraftDataCopyWith<TournamentDraftData> get copyWith => _$TournamentDraftDataCopyWithImpl<TournamentDraftData>(this as TournamentDraftData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TournamentDraftData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.participants, participants));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,status,const DeepCollectionEquality().hash(participants));

@override
String toString() {
  return 'TournamentDraftData(id: $id, name: $name, status: $status, participants: $participants)';
}


}

/// @nodoc
abstract mixin class $TournamentDraftDataCopyWith<$Res>  {
  factory $TournamentDraftDataCopyWith(TournamentDraftData value, $Res Function(TournamentDraftData) _then) = _$TournamentDraftDataCopyWithImpl;
@useResult
$Res call({
 String id, String name, String status, List<TournamentParticipantData> participants
});




}
/// @nodoc
class _$TournamentDraftDataCopyWithImpl<$Res>
    implements $TournamentDraftDataCopyWith<$Res> {
  _$TournamentDraftDataCopyWithImpl(this._self, this._then);

  final TournamentDraftData _self;
  final $Res Function(TournamentDraftData) _then;

/// Create a copy of TournamentDraftData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? participants = null,}) {
  return _then(TournamentDraftData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<TournamentParticipantData>,
  ));
}

}


/// Adds pattern-matching-related methods to [TournamentDraftData].
extension TournamentDraftDataPatterns on TournamentDraftData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TournamentDraftData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TournamentDraftData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TournamentDraftData value)  $default,){
final _that = this;
switch (_that) {
case _TournamentDraftData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TournamentDraftData value)?  $default,){
final _that = this;
switch (_that) {
case _TournamentDraftData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String status,  List<TournamentParticipantData> participants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TournamentDraftData() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.participants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String status,  List<TournamentParticipantData> participants)  $default,) {final _that = this;
switch (_that) {
case _TournamentDraftData():
return $default(_that.id,_that.name,_that.status,_that.participants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String status,  List<TournamentParticipantData> participants)?  $default,) {final _that = this;
switch (_that) {
case _TournamentDraftData() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.participants);case _:
  return null;

}
}

}

/// @nodoc


class _TournamentDraftData implements TournamentDraftData {
  const _TournamentDraftData({required this.id, required this.name, required this.status, required  List<TournamentParticipantData> participants}): _participants = participants;


@override final  String id;
@override final  String name;
@override final  String status;
 final  List<TournamentParticipantData> _participants;
@override List<TournamentParticipantData> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}


/// Create a copy of TournamentDraftData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TournamentDraftDataCopyWith<_TournamentDraftData> get copyWith => __$TournamentDraftDataCopyWithImpl<_TournamentDraftData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TournamentDraftData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._participants, _participants));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,status,const DeepCollectionEquality().hash(_participants));

@override
String toString() {
  return 'TournamentDraftData(id: $id, name: $name, status: $status, participants: $participants)';
}


}

/// @nodoc
abstract mixin class _$TournamentDraftDataCopyWith<$Res> implements $TournamentDraftDataCopyWith<$Res> {
  factory _$TournamentDraftDataCopyWith(_TournamentDraftData value, $Res Function(_TournamentDraftData) _then) = __$TournamentDraftDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String status, List<TournamentParticipantData> participants
});




}
/// @nodoc
class __$TournamentDraftDataCopyWithImpl<$Res>
    implements _$TournamentDraftDataCopyWith<$Res> {
  __$TournamentDraftDataCopyWithImpl(this._self, this._then);

  final _TournamentDraftData _self;
  final $Res Function(_TournamentDraftData) _then;

/// Create a copy of TournamentDraftData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? participants = null,}) {
  return _then(_TournamentDraftData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<TournamentParticipantData>,
  ));
}


}

// dart format on
