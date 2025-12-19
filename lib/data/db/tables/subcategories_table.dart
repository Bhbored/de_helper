import 'package:drift/drift.dart';

class SubCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get categoryId => text()();

  @override
  Set<Column> get primaryKey => {id};
}
