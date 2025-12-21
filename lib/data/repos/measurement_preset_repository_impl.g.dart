// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_preset_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(measurmentRepo)
const measurmentRepoProvider = MeasurmentRepoProvider._();

final class MeasurmentRepoProvider
    extends
        $FunctionalProvider<
          MeasurementPresetRepositoryImpl,
          MeasurementPresetRepositoryImpl,
          MeasurementPresetRepositoryImpl
        >
    with $Provider<MeasurementPresetRepositoryImpl> {
  const MeasurmentRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'measurmentRepoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$measurmentRepoHash();

  @$internal
  @override
  $ProviderElement<MeasurementPresetRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MeasurementPresetRepositoryImpl create(Ref ref) {
    return measurmentRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeasurementPresetRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeasurementPresetRepositoryImpl>(
        value,
      ),
    );
  }
}

String _$measurmentRepoHash() => r'0d478e7c7e05c0bc6aec30a948bfce40d9d67fb1';
