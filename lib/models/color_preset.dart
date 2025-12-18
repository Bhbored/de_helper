import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'color_preset.freezed.dart';
part 'color_preset.g.dart';

final uuid = const Uuid().v4();

@freezed
sealed class ColorPreset with _$ColorPreset {
  const ColorPreset._();

  const factory ColorPreset({
    required String id,
    String? name,
    String? hexCode,
  }) = _ColorPreset;

  factory ColorPreset.create({
    String? id,
    String? name,
    String? hexCode,
  }) {
    return ColorPreset(
      id: id ?? uuid,
      name: name,
      hexCode: hexCode,
    );
  }
  factory ColorPreset.fromJson(Map<String, dynamic> json) =>
      _$ColorPresetFromJson(json);

  String get displayLabel => name ?? hexCode ?? 'Unnamed Color';
}
