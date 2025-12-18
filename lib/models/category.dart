import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
part 'category.freezed.dart';
part 'category.g.dart';

final uuid = const Uuid().v4();

@freezed
sealed class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
  }) = _Category;

  factory Category.create({
    String? id,
    required String name,
  }) {
    return Category(
      id: id ?? uuid,
      name: name,
    );
  }
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
