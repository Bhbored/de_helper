// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'color_preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ColorPreset {

 String get id; String? get name; String? get hexCode;
/// Create a copy of ColorPreset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ColorPresetCopyWith<ColorPreset> get copyWith => _$ColorPresetCopyWithImpl<ColorPreset>(this as ColorPreset, _$identity);

  /// Serializes this ColorPreset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ColorPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hexCode, hexCode) || other.hexCode == hexCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hexCode);

@override
String toString() {
  return 'ColorPreset(id: $id, name: $name, hexCode: $hexCode)';
}


}

/// @nodoc
abstract mixin class $ColorPresetCopyWith<$Res>  {
  factory $ColorPresetCopyWith(ColorPreset value, $Res Function(ColorPreset) _then) = _$ColorPresetCopyWithImpl;
@useResult
$Res call({
 String id, String? name, String? hexCode
});




}
/// @nodoc
class _$ColorPresetCopyWithImpl<$Res>
    implements $ColorPresetCopyWith<$Res> {
  _$ColorPresetCopyWithImpl(this._self, this._then);

  final ColorPreset _self;
  final $Res Function(ColorPreset) _then;

/// Create a copy of ColorPreset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? hexCode = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,hexCode: freezed == hexCode ? _self.hexCode : hexCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ColorPreset].
extension ColorPresetPatterns on ColorPreset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ColorPreset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ColorPreset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ColorPreset value)  $default,){
final _that = this;
switch (_that) {
case _ColorPreset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ColorPreset value)?  $default,){
final _that = this;
switch (_that) {
case _ColorPreset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name,  String? hexCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ColorPreset() when $default != null:
return $default(_that.id,_that.name,_that.hexCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name,  String? hexCode)  $default,) {final _that = this;
switch (_that) {
case _ColorPreset():
return $default(_that.id,_that.name,_that.hexCode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name,  String? hexCode)?  $default,) {final _that = this;
switch (_that) {
case _ColorPreset() when $default != null:
return $default(_that.id,_that.name,_that.hexCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ColorPreset extends ColorPreset {
  const _ColorPreset({required this.id, this.name, this.hexCode}): super._();
  factory _ColorPreset.fromJson(Map<String, dynamic> json) => _$ColorPresetFromJson(json);

@override final  String id;
@override final  String? name;
@override final  String? hexCode;

/// Create a copy of ColorPreset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColorPresetCopyWith<_ColorPreset> get copyWith => __$ColorPresetCopyWithImpl<_ColorPreset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ColorPresetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColorPreset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.hexCode, hexCode) || other.hexCode == hexCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,hexCode);

@override
String toString() {
  return 'ColorPreset(id: $id, name: $name, hexCode: $hexCode)';
}


}

/// @nodoc
abstract mixin class _$ColorPresetCopyWith<$Res> implements $ColorPresetCopyWith<$Res> {
  factory _$ColorPresetCopyWith(_ColorPreset value, $Res Function(_ColorPreset) _then) = __$ColorPresetCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name, String? hexCode
});




}
/// @nodoc
class __$ColorPresetCopyWithImpl<$Res>
    implements _$ColorPresetCopyWith<$Res> {
  __$ColorPresetCopyWithImpl(this._self, this._then);

  final _ColorPreset _self;
  final $Res Function(_ColorPreset) _then;

/// Create a copy of ColorPreset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? hexCode = freezed,}) {
  return _then(_ColorPreset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,hexCode: freezed == hexCode ? _self.hexCode : hexCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
