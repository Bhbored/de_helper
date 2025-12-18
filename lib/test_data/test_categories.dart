import 'package:de_helper/models/category.dart';
import 'package:flutter/material.dart';

final electronicsCategory = Category.create(
  name: 'Electronics',
  icon: Icons.inventory_2,
);
final booksCategory = Category.create(
  name: 'Books',
  icon: Icons.menu_book,
);
final apparelCategory = Category.create(
  name: 'Apparel',
  icon: Icons.checkroom,
);
final kitchenwareCategory = Category.create(
  name: 'Kitchenware',
  icon: Icons.kitchen,
);
final furnitureCategory = Category.create(
  name: 'Furniture',
  icon: Icons.chair,
);
final sportsCategory = Category.create(
  name: 'Sports',
  icon: Icons.sports_soccer,
);
final toysCategory = Category.create(
  name: 'Toys',
  icon: Icons.toys,
);
final beautyCategory = Category.create(
  name: 'Beauty',
  icon: Icons.face,
);
final automotiveCategory = Category.create(
  name: 'Automotive',
  icon: Icons.directions_car,
);
final homeGardenCategory = Category.create(
  name: 'Home & Garden',
  icon: Icons.home,
);

List<Category> testCategories = [
  electronicsCategory,
  booksCategory,
  apparelCategory,
  kitchenwareCategory,
  furnitureCategory,
  sportsCategory,
  toysCategory,
  beautyCategory,
  automotiveCategory,
  homeGardenCategory,
];
