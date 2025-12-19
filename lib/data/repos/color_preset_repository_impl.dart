import '../../models/color_preset.dart';
import '../db/app_database.dart' hide ColorPreset;
import '../db/dto/color_preset_dto.dart';
import 'interface/color_preset_repository.dart';

class ColorPresetRepositoryImpl implements ColorPresetRepository {
  final AppDatabase _db;

  ColorPresetRepositoryImpl(this._db);

  @override
  Future<List<ColorPreset>> getAll() async {
    final colorPresets = await _db.select(_db.colorPresets).get();
    return colorPresets.map((c) => c.toDomain()).toList();
  }

  @override
  Future<ColorPreset?> getById(String id) async {
    final colorPreset = await (_db.select(
      _db.colorPresets,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
    return colorPreset?.toDomain();
  }

  @override
  Future<void> create(ColorPreset colorPreset) async {
    await _db.into(_db.colorPresets).insert(colorPreset.toCompanion());
  }

  @override
  Future<void> update(ColorPreset colorPreset) async {
    await (_db.update(_db.colorPresets)
          ..where((c) => c.id.equals(colorPreset.id)))
        .write(colorPreset.toCompanion());
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(_db.colorPresets)..where((c) => c.id.equals(id))).go();
  }
}
