import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
part 'measurement.freezed.dart';
part 'measurement.g.dart';

@freezed
sealed class MeasurementPreset with _$MeasurementPreset {
  const factory MeasurementPreset({
    required String id,
    required String name,
  }) = _MeasurementPreset;

  factory MeasurementPreset.create({
    String? id,
    required String name,
  }) {
    return MeasurementPreset(
      id: id ?? Uuid().v4(),
      name: name,
    );
  }
  factory MeasurementPreset.fromJson(Map<String, dynamic> json) =>
      _$MeasurementPresetFromJson(json);
}
