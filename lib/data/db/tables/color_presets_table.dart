import 'package:drift/drift.dart';

class ColorPresets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  TextColumn get hexCode => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
