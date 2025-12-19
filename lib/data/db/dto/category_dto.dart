import 'package:flutter/material.dart';

import '../../../models/category.dart' as domain;
import '../app_database.dart';

extension CategoryToDb on domain.Category {
  CategoriesCompanion toCompanion() {
    return CategoriesCompanion.insert(
      id: id,
      name: name,
      iconCodePoint: icon.codePoint,
    );
  }
}

extension CategoryFromDb on Category {
  domain.Category toDomain() {
    return domain.Category(
      id: id,
      name: name,
      icon: IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
    );
  }
}
