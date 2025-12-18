// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'measurement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeasurementPreset {

 String get id; String get name;
/// Create a copy of MeasurementPreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurementPresetCopyWith<MeasurementPreset> get copyWith => _$MeasurementPresetCopyWithImpl<MeasurementPreset>(this as MeasurementPreset, _$identity);

  /// Serializes this MeasurementPreset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasurementPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MeasurementPreset(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $MeasurementPresetCopyWith<$Res>  {
  factory $MeasurementPresetCopyWith(MeasurementPreset value, $Res Function(MeasurementPreset) _then) = _$MeasurementPresetCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$MeasurementPresetCopyWithImpl<$Res>
    implements $MeasurementPresetCopyWith<$Res> {
  _$MeasurementPresetCopyWithImpl(this._self, this._then);

  final MeasurementPreset _self;
  final $Res Function(MeasurementPreset) _then;

/// Create a copy of MeasurementPreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MeasurementPreset].
extension MeasurementPresetPatterns on MeasurementPreset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasurementPreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasurementPreset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasurementPreset value)  $default,){
final _that = this;
switch (_that) {
case _MeasurementPreset():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasurementPreset value)?  $default,){
final _that = this;
switch (_that) {
case _MeasurementPreset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasurementPreset() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _MeasurementPreset():
return $default(_that.id,_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _MeasurementPreset() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeasurementPreset implements MeasurementPreset {
  const _MeasurementPreset({required this.id, required this.name});
  factory _MeasurementPreset.fromJson(Map<String, dynamic> json) => _$MeasurementPresetFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of MeasurementPreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurementPresetCopyWith<_MeasurementPreset> get copyWith => __$MeasurementPresetCopyWithImpl<_MeasurementPreset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeasurementPresetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeasurementPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MeasurementPreset(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$MeasurementPresetCopyWith<$Res> implements $MeasurementPresetCopyWith<$Res> {
  factory _$MeasurementPresetCopyWith(_MeasurementPreset value, $Res Function(_MeasurementPreset) _then) = __$MeasurementPresetCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$MeasurementPresetCopyWithImpl<$Res>
    implements _$MeasurementPresetCopyWith<$Res> {
  __$MeasurementPresetCopyWithImpl(this._self, this._then);

  final _MeasurementPreset _self;
  final $Res Function(_MeasurementPreset) _then;

/// Create a copy of MeasurementPreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_MeasurementPreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
