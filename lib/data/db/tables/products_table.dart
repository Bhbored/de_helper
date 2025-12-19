import 'package:drift/drift.dart';

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  TextColumn get categoryId => text()();
  TextColumn get subCategoryId => text().nullable()();

  IntColumn get quantity => integer()();
  RealColumn get price => real()();
  RealColumn get manualCost => real().nullable()();
  RealColumn get profitMargin => real().withDefault(const Constant(0))();

  TextColumn get barcode => text()();
  TextColumn get secondaryBarcode => text().nullable()();

  TextColumn get colorPresetId => text()();
  TextColumn get measurementPresetId => text()();

  @override
  Set<Column> get primaryKey => {id};
}
