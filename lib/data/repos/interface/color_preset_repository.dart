import '../../../models/color_preset.dart';

abstract class ColorPresetRepository {
  Future<List<ColorPreset>> getAll();

  Future<ColorPreset?> getById(String id);

  Future<void> create(ColorPreset colorPreset);

  Future<void> update(ColorPreset colorPreset);

  Future<void> delete(String id);
}
