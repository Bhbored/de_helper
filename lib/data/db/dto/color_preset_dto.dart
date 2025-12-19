import 'package:drift/drift.dart';

import '../../../models/color_preset.dart' as domain;
import '../app_database.dart';

extension ColorPresetToDb on domain.ColorPreset {
  ColorPresetsCompanion toCompanion() {
    return ColorPresetsCompanion.insert(
      id: id,
      name: Value(name),
      hexCode: Value(hexCode),
    );
  }
}

extension ColorPresetFromDb on ColorPreset {
  domain.ColorPreset toDomain() {
    return domain.ColorPreset(
      id: id,
      name: name,
      hexCode: hexCode,
    );
  }
}
