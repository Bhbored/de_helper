import '../../../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getAll();

  Future<Product?> getById(String id);

  Future<void> create(Product product);

  Future<void> update(Product product);

  Future<void> delete(String id);

  Future<List<Product>> getByCategoryId(String categoryId);

  Future<List<Product>> getBySubCategoryId(String subCategoryId);

  Future<List<Product>> getByColorPresetId(String colorPresetId);

  Future<List<Product>> getByMeasurementPresetId(String measurementPresetId);

  Future<Product?> getByBarcode(String barcode);

  Future<Product?> getBySecondaryBarcode(String secondaryBarcode);
}
