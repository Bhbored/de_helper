import 'package:de_helper/data/repos/interface/category_repository.dart';

import '../../models/category.dart';
import '../db/app_database.dart' hide Category;
import '../db/dto/category_dto.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final AppDatabase _db;

  CategoryRepositoryImpl(this._db);

  @override
  Future<List<Category>> getAll() async {
    final categories = await _db.select(_db.categories).get();
    return categories.map((c) => c.toDomain()).toList();
  }

  @override
  Future<Category?> getById(String id) async {
    final category = await (_db.select(
      _db.categories,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
    return category?.toDomain();
  }

  @override
  Future<void> create(Category category) async {
    await _db.into(_db.categories).insert(category.toCompanion());
  }

  @override
  Future<void> update(Category category) async {
    await (_db.update(
      _db.categories,
    )..where((c) => c.id.equals(category.id))).write(category.toCompanion());
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.categories)..where((c) => c.id.equals(id))).go();
  }
}
