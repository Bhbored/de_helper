import 'package:de_helper/models/subcategory.dart';
import 'test_categories.dart';

List<SubCategory> testSubCategories = [
  SubCategory.create(
    name: 'Laptops',
    categoryId: electronicsCategory.id,
  ),
  SubCategory.create(
    name: 'Phones',
    categoryId: electronicsCategory.id,
  ),
  SubCategory.create(
    name: 'Fiction',
    categoryId: booksCategory.id,
  ),
  SubCategory.create(
    name: 'Non-Fiction',
    categoryId: booksCategory.id,
  ),
  SubCategory.create(
    name: 'Men\'s Clothing',
    categoryId: apparelCategory.id,
  ),
  SubCategory.create(
    name: 'Women\'s Clothing',
    categoryId: apparelCategory.id,
  ),
  SubCategory.create(
    name: 'Cookware',
    categoryId: kitchenwareCategory.id,
  ),
  SubCategory.create(
    name: 'Bakeware',
    categoryId: kitchenwareCategory.id,
  ),
];
