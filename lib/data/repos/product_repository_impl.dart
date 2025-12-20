import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/product.dart';
import '../db/app_database.dart' hide Product;
import '../db/dto/product_dto.dart';
import 'interface/product_repository.dart';
part 'product_repository_impl.g.dart';

@Riverpod(keepAlive: true)
ProductRepositoryImpl productRepo(Ref ref) {
  final db = ref.watch(getDbProvider);
  return ProductRepositoryImpl(db);
}

class ProductRepositoryImpl implements ProductRepository {
  final AppDatabase _db;

  ProductRepositoryImpl(this._db);

  @override
  Future<List<Product>> getAll() async {
    final products = await _db.select(_db.products).get();
    return products.map((p) => p.toDomain()).toList();
  }

  @override
  Future<Product?> getById(String id) async {
    final product = await (_db.select(
      _db.products,
    )..where((p) => p.id.equals(id))).getSingleOrNull();
    return product?.toDomain();
  }

  @override
  Future<void> create(Product product) async {
    await _db.into(_db.products).insert(product.toCompanion());
  }

  @override
  Future<void> update(Product product) async {
    await (_db.update(
      _db.products,
    )..where((p) => p.id.equals(product.id))).write(product.toCompanion());
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.products)..where((p) => p.id.equals(id))).go();
  }

  @override
  Future<List<Product>> getByCategoryId(String categoryId) async {
    final products = await (_db.select(
      _db.products,
    )..where((p) => p.categoryId.equals(categoryId))).get();
    return products.map((p) => p.toDomain()).toList();
  }

  @override
  Future<List<Product>> getBySubCategoryId(String subCategoryId) async {
    final products = await (_db.select(
      _db.products,
    )..where((p) => p.subCategoryId.equals(subCategoryId))).get();
    return products.map((p) => p.toDomain()).toList();
  }

  @override
  Future<List<Product>> getByColorPresetId(String colorPresetId) async {
    final products = await (_db.select(
      _db.products,
    )..where((p) => p.colorPresetId.equals(colorPresetId))).get();
    return products.map((p) => p.toDomain()).toList();
  }

  @override
  Future<List<Product>> getByMeasurementPresetId(
    String measurementPresetId,
  ) async {
    final products = await (_db.select(
      _db.products,
    )..where((p) => p.measurementPresetId.equals(measurementPresetId))).get();
    return products.map((p) => p.toDomain()).toList();
  }

  @override
  Future<Product?> getByBarcode(String barcode) async {
    final product = await (_db.select(
      _db.products,
    )..where((p) => p.barcode.equals(barcode))).getSingleOrNull();
    return product?.toDomain();
  }

  @override
  Future<Product?> getBySecondaryBarcode(String secondaryBarcode) async {
    final product =
        await (_db.select(_db.products)
              ..where((p) => p.secondaryBarcode.equals(secondaryBarcode)))
            .getSingleOrNull();
    return product?.toDomain();
  }
}
