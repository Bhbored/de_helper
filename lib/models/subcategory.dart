import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
part 'subcategory.freezed.dart';
part 'subcategory.g.dart';

final uuid = const Uuid().v4();

@freezed
sealed class SubCategory with _$SubCategory {
  const factory SubCategory({
    required String id,
    required String name,
    required String categoryId,
  }) = _SubCategory;

  factory SubCategory.create({
    String? id,
    required String name,
    required String categoryId,
  }) {
    return SubCategory(
      id: id ?? uuid,
      name: name,
      categoryId: categoryId,
    );
  }
  factory SubCategory.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryFromJson(json);
}
