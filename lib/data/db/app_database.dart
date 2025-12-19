import 'dart:io';

import 'package:de_helper/data/db/tables/categories_table.dart';
import 'package:de_helper/data/db/tables/color_presets_table.dart';
import 'package:de_helper/data/db/tables/measurement_presets_table.dart';
import 'package:de_helper/data/db/tables/products_table.dart';
import 'package:de_helper/data/db/tables/subcategories_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    SubCategories,
    ColorPresets,
    MeasurementPresets,
    Products,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/de_helper.sqlite');
    return NativeDatabase(file);
  });
}
