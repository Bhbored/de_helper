// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Product {

 String get id; String get name; String get categoryId; String? get subCategoryId; int get quantity; double get price; double? get manualCost; double get profitMargin; String get barcode; String? get secondaryBarcode; String get colorPresetId; String get measurementPresetId;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.subCategoryId, subCategoryId) || other.subCategoryId == subCategoryId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.manualCost, manualCost) || other.manualCost == manualCost)&&(identical(other.profitMargin, profitMargin) || other.profitMargin == profitMargin)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.secondaryBarcode, secondaryBarcode) || other.secondaryBarcode == secondaryBarcode)&&(identical(other.colorPresetId, colorPresetId) || other.colorPresetId == colorPresetId)&&(identical(other.measurementPresetId, measurementPresetId) || other.measurementPresetId == measurementPresetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,subCategoryId,quantity,price,manualCost,profitMargin,barcode,secondaryBarcode,colorPresetId,measurementPresetId);

@override
String toString() {
  return 'Product(id: $id, name: $name, categoryId: $categoryId, subCategoryId: $subCategoryId, quantity: $quantity, price: $price, manualCost: $manualCost, profitMargin: $profitMargin, barcode: $barcode, secondaryBarcode: $secondaryBarcode, colorPresetId: $colorPresetId, measurementPresetId: $measurementPresetId)';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String categoryId, String? subCategoryId, int quantity, double price, double? manualCost, double profitMargin, String barcode, String? secondaryBarcode, String colorPresetId, String measurementPresetId
});




}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? categoryId = null,Object? subCategoryId = freezed,Object? quantity = null,Object? price = null,Object? manualCost = freezed,Object? profitMargin = null,Object? barcode = null,Object? secondaryBarcode = freezed,Object? colorPresetId = null,Object? measurementPresetId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,subCategoryId: freezed == subCategoryId ? _self.subCategoryId : subCategoryId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,manualCost: freezed == manualCost ? _self.manualCost : manualCost // ignore: cast_nullable_to_non_nullable
as double?,profitMargin: null == profitMargin ? _self.profitMargin : profitMargin // ignore: cast_nullable_to_non_nullable
as double,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,secondaryBarcode: freezed == secondaryBarcode ? _self.secondaryBarcode : secondaryBarcode // ignore: cast_nullable_to_non_nullable
as String?,colorPresetId: null == colorPresetId ? _self.colorPresetId : colorPresetId // ignore: cast_nullable_to_non_nullable
as String,measurementPresetId: null == measurementPresetId ? _self.measurementPresetId : measurementPresetId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String categoryId,  String? subCategoryId,  int quantity,  double price,  double? manualCost,  double profitMargin,  String barcode,  String? secondaryBarcode,  String colorPresetId,  String measurementPresetId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.subCategoryId,_that.quantity,_that.price,_that.manualCost,_that.profitMargin,_that.barcode,_that.secondaryBarcode,_that.colorPresetId,_that.measurementPresetId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String categoryId,  String? subCategoryId,  int quantity,  double price,  double? manualCost,  double profitMargin,  String barcode,  String? secondaryBarcode,  String colorPresetId,  String measurementPresetId)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.name,_that.categoryId,_that.subCategoryId,_that.quantity,_that.price,_that.manualCost,_that.profitMargin,_that.barcode,_that.secondaryBarcode,_that.colorPresetId,_that.measurementPresetId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String categoryId,  String? subCategoryId,  int quantity,  double price,  double? manualCost,  double profitMargin,  String barcode,  String? secondaryBarcode,  String colorPresetId,  String measurementPresetId)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.subCategoryId,_that.quantity,_that.price,_that.manualCost,_that.profitMargin,_that.barcode,_that.secondaryBarcode,_that.colorPresetId,_that.measurementPresetId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Product extends Product {
  const _Product({required this.id, required this.name, required this.categoryId, this.subCategoryId, required this.quantity, required this.price, this.manualCost, this.profitMargin = 0, required this.barcode, this.secondaryBarcode, required this.colorPresetId, required this.measurementPresetId}): super._();
  factory _Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

@override final  String id;
@override final  String name;
@override final  String categoryId;
@override final  String? subCategoryId;
@override final  int quantity;
@override final  double price;
@override final  double? manualCost;
@override@JsonKey() final  double profitMargin;
@override final  String barcode;
@override final  String? secondaryBarcode;
@override final  String colorPresetId;
@override final  String measurementPresetId;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.subCategoryId, subCategoryId) || other.subCategoryId == subCategoryId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.price, price) || other.price == price)&&(identical(other.manualCost, manualCost) || other.manualCost == manualCost)&&(identical(other.profitMargin, profitMargin) || other.profitMargin == profitMargin)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.secondaryBarcode, secondaryBarcode) || other.secondaryBarcode == secondaryBarcode)&&(identical(other.colorPresetId, colorPresetId) || other.colorPresetId == colorPresetId)&&(identical(other.measurementPresetId, measurementPresetId) || other.measurementPresetId == measurementPresetId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,subCategoryId,quantity,price,manualCost,profitMargin,barcode,secondaryBarcode,colorPresetId,measurementPresetId);

@override
String toString() {
  return 'Product(id: $id, name: $name, categoryId: $categoryId, subCategoryId: $subCategoryId, quantity: $quantity, price: $price, manualCost: $manualCost, profitMargin: $profitMargin, barcode: $barcode, secondaryBarcode: $secondaryBarcode, colorPresetId: $colorPresetId, measurementPresetId: $measurementPresetId)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String categoryId, String? subCategoryId, int quantity, double price, double? manualCost, double profitMargin, String barcode, String? secondaryBarcode, String colorPresetId, String measurementPresetId
});




}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? categoryId = null,Object? subCategoryId = freezed,Object? quantity = null,Object? price = null,Object? manualCost = freezed,Object? profitMargin = null,Object? barcode = null,Object? secondaryBarcode = freezed,Object? colorPresetId = null,Object? measurementPresetId = null,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,subCategoryId: freezed == subCategoryId ? _self.subCategoryId : subCategoryId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,manualCost: freezed == manualCost ? _self.manualCost : manualCost // ignore: cast_nullable_to_non_nullable
as double?,profitMargin: null == profitMargin ? _self.profitMargin : profitMargin // ignore: cast_nullable_to_non_nullable
as double,barcode: null == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String,secondaryBarcode: freezed == secondaryBarcode ? _self.secondaryBarcode : secondaryBarcode // ignore: cast_nullable_to_non_nullable
as String?,colorPresetId: null == colorPresetId ? _self.colorPresetId : colorPresetId // ignore: cast_nullable_to_non_nullable
as String,measurementPresetId: null == measurementPresetId ? _self.measurementPresetId : measurementPresetId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
