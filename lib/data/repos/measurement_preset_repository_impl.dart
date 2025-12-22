import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/measurement.dart';
import '../db/app_database.dart' hide MeasurementPreset;
import '../db/dto/measurement_preset_dto.dart';
import 'interface/measurement_preset_repository.dart';
part 'measurement_preset_repository_impl.g.dart';

@Riverpod(keepAlive: true)
MeasurementPresetRepositoryImpl measurmentRepo(Ref ref) {
  final db = ref.watch(getDbProvider);
  return MeasurementPresetRepositoryImpl(db);
}

class MeasurementPresetRepositoryImpl implements MeasurementPresetRepository {
  final AppDatabase _db;

  MeasurementPresetRepositoryImpl(this._db);

  @override
  Future<List<MeasurementPreset>> getAll() async {
    final measurementPresets = await _db.select(_db.measurementPresets).get();
    return measurementPresets.map((m) => m.toDomain()).toList();
  }

  @override
  Future<MeasurementPreset?> getById(String id) async {
    final measurementPreset = await (_db.select(
      _db.measurementPresets,
    )..where((m) => m.id.equals(id))).getSingleOrNull();
    return measurementPreset?.toDomain();
  }

  @override
  Future<MeasurementPreset?> getByName(String name) async {
    final measurementPreset = await (_db.select(
      _db.measurementPresets,
    )..where((m) => m.name.equals(name))).getSingleOrNull();
    return measurementPreset?.toDomain();
  }

  @override
  Future<void> create(MeasurementPreset measurementPreset) async {
    await _db
        .into(_db.measurementPresets)
        .insert(measurementPreset.toCompanion());
  }

  @override
  Future<void> update(MeasurementPreset measurementPreset) async {
    await (_db.update(_db.measurementPresets)
          ..where((m) => m.id.equals(measurementPreset.id)))
        .write(measurementPreset.toCompanion());
  }

  @override
  Future<void> delete(String id) async {
    await (_db.delete(
      _db.measurementPresets,
    )..where((m) => m.id.equals(id))).go();
  }
}
