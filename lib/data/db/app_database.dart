import 'dart:io';
import 'package:de_helper/data/db/tables/categories_table.dart';
import 'package:de_helper/data/db/tables/color_presets_table.dart';
import 'package:de_helper/data/db/tables/measurement_presets_table.dart';
import 'package:de_helper/data/db/tables/products_table.dart';
import 'package:de_helper/data/db/tables/subcategories_table.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

@Riverpod(keepAlive: true)
AppDatabase getDb(Ref ref) {
  return AppDatabase();
}

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

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
  );

  Future<void> deleteDatabase() async {
    await delete(categories).go();
    await delete(subCategories).go();
    await delete(colorPresets).go();
    await delete(measurementPresets).go();
    await delete(products).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/de_helper.sqlite');
    return NativeDatabase(file);
  });
}
