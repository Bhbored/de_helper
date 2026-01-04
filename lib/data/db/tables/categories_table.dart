import 'package:drift/drift.dart';

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  IntColumn get iconCodePoint => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
