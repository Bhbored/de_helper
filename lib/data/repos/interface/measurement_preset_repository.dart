import '../../../models/measurement.dart';

abstract class MeasurementPresetRepository {
  Future<List<MeasurementPreset>> getAll();

  Future<MeasurementPreset?> getById(String id);

  Future<void> create(MeasurementPreset measurementPreset);

  Future<void> update(MeasurementPreset measurementPreset);

  Future<void> delete(String id);
}
