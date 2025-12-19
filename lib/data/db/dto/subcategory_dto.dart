import '../../../models/subcategory.dart' as domain;
import '../app_database.dart';

extension SubCategoryToDb on domain.SubCategory {
  SubCategoriesCompanion toCompanion() {
    return SubCategoriesCompanion.insert(
      id: id,
      name: name,
      categoryId: categoryId,
    );
  }
}

extension SubCategoryFromDb on SubCategory {
  domain.SubCategory toDomain() {
    return domain.SubCategory(
      id: id,
      name: name,
      categoryId: categoryId,
    );
  }
}
