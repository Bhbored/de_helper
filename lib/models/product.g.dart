// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  categoryId: json['categoryId'] as String,
  subCategoryId: json['subCategoryId'] as String?,
  quantity: (json['quantity'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  manualCost: (json['manualCost'] as num?)?.toDouble(),
  profitMargin: (json['profitMargin'] as num?)?.toDouble() ?? 0,
  barcode: json['barcode'] as String,
  secondaryBarcode: json['secondaryBarcode'] as String?,
  colorPresetId: json['colorPresetId'] as String,
  measurementPresetId: json['measurementPresetId'] as String,
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'categoryId': instance.categoryId,
  'subCategoryId': instance.subCategoryId,
  'quantity': instance.quantity,
  'price': instance.price,
  'manualCost': instance.manualCost,
  'profitMargin': instance.profitMargin,
  'barcode': instance.barcode,
  'secondaryBarcode': instance.secondaryBarcode,
  'colorPresetId': instance.colorPresetId,
  'measurementPresetId': instance.measurementPresetId,
};
