import 'package:drift/drift.dart';

import '../../../models/product.dart' as domain;
import '../app_database.dart';

extension ProductToDb on domain.Product {
  ProductsCompanion toCompanion() {
    return ProductsCompanion.insert(
      id: id,
      name: name,
      categoryId: categoryId,
      subCategoryId: Value(subCategoryId),
      quantity: quantity,
      price: price,
      manualCost: Value(manualCost),
      profitMargin: Value(profitMargin),
      barcode: barcode,
      secondaryBarcode: Value(secondaryBarcode),
      colorPresetId: colorPresetId,
      measurementPresetId: measurementPresetId,
    );
  }
}

extension ProductFromDb on Product {
  domain.Product toDomain() {
    return domain.Product(
      id: id,
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
}
