import 'package:drift/drift.dart';

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  // IconData → stored as int
  IntColumn get iconCodePoint => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
