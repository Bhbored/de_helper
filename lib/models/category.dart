import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
part 'category.freezed.dart';

final uuid = const Uuid().v4();

@freezed
sealed class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required IconData icon,
  }) = _Category;

  factory Category.create({
    String? id,
    required String name,
    required IconData icon,
  }) {
    return Category(
      id: id ?? uuid,
      name: name,
      icon: icon,
    );
  }
}
