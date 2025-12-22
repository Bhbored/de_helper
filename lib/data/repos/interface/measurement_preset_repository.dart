import '../../../models/measurement.dart';

abstract class MeasurementPresetRepository {
  Future<List<MeasurementPreset>> getAll();

  Future<MeasurementPreset?> getById(String id);

  Future<MeasurementPreset?> getByName(String name);

  Future<void> create(MeasurementPreset measurementPreset);

  Future<void> update(MeasurementPreset measurementPreset);

  Future<void> delete(String id);
}
