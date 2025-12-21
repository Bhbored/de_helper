import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
part 'product.freezed.dart';
part 'product.g.dart';

@freezed
sealed class Product with _$Product {
  const Product._();
  const factory Product({
    required String id,
    required String name,
    required String categoryId,
    String? subCategoryId,
    required int quantity,
    required double price,
    double? manualCost,
    @Default(0) double profitMargin,
    required String barcode,
    String? secondaryBarcode,
    required String colorPresetId,
    required String measurementPresetId,
  }) = _Product;

  factory Product.create({
    String? id,
    required String name,
    required String categoryId,
    String? subCategoryId,
    required int quantity,
    required double price,
    double? manualCost,
    double profitMargin = 0,
    required String barcode,
    String? secondaryBarcode,
    required String colorPresetId,
    required String measurementPresetId,
  }) {
    return Product(
      id: id ?? const Uuid().v4(),
      name: name,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      quantity: quantity,
      price: price,
      manualCost: manualCost,
      profitMargin: profitMargin,
      barcode: barcode,
      secondaryBarcode: secondaryBarcode,
      colorPresetId: colorPresetId,
      measurementPresetId: measurementPresetId,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  double get cost {
    if (manualCost != null) return manualCost!;
    if (profitMargin <= 0) return 0;
    return price * profitMargin;
  }
}
