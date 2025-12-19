import '../../models/subcategory.dart';
import '../db/app_database.dart' hide SubCategory;
import '../db/dto/subcategory_dto.dart';
import 'interface/subcategory_repository.dart';

class SubCategoryRepositoryImpl implements SubCategoryRepository {
  final AppDatabase _db;

  SubCategoryRepositoryImpl(this._db);

  @override
  Future<List<SubCategory>> getAll() async {
    final subCategories = await _db.select(_db.subCategories).get();
    return subCategories.map((s) => s.toDomain()).toList();
  }

  @override
  Future<SubCategory?> getById(String id) async {
    final subCategory = await (_db.select(
      _db.subCategories,
    )..where((s) => s.id.equals(id))).getSingleOrNull();
    return subCategory?.toDomain();
  }

  @override
  Future<void> create(SubCategory subCategory) async {
    await _db.into(_db.subCategories).insert(subCategory.toCompanion());
  }

  @override
  Future<void> update(SubCategory subCategory) async {
    await (_db.update(_db.subCategories)
          ..where((s) => s.id.equals(subCategory.id)))
        .write(subCategory.toCompanion());
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.subCategories)..where((s) => s.id.equals(id))).go();
  }

  @override
  Future<List<SubCategory>> getByCategoryId(String categoryId) async {
    final subCategories = await (_db.select(
      _db.subCategories,
    )..where((s) => s.categoryId.equals(categoryId))).get();
    return subCategories.map((s) => s.toDomain()).toList();
  }
}
