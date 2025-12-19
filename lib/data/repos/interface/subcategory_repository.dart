import '../../../models/subcategory.dart';

abstract class SubCategoryRepository {
  Future<List<SubCategory>> getAll();

  Future<SubCategory?> getById(String id);

  Future<void> create(SubCategory subCategory);

  Future<void> update(SubCategory subCategory);

  Future<void> delete(String id);

  Future<List<SubCategory>> getByCategoryId(String categoryId);
}
