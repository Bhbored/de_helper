import '../../../models/measurement.dart' as domain;
import '../app_database.dart';

extension MeasurementToDb on domain.MeasurementPreset {
  MeasurementPresetsCompanion toCompanion() {
    return MeasurementPresetsCompanion.insert(
      id: id,
      name: name,
    );
  }
}

extension MeasurementFromDb on MeasurementPreset {
  domain.MeasurementPreset toDomain() {
    return domain.MeasurementPreset(
      id: id,
      name: name,
    );
  }
}
