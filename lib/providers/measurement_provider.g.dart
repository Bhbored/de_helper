// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MeasurementNotifier)
const measurementProvider = MeasurementNotifierProvider._();

final class MeasurementNotifierProvider
    extends
        $AsyncNotifierProvider<MeasurementNotifier, List<MeasurementPreset>> {
  const MeasurementNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'measurementProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$measurementNotifierHash();

  @$internal
  @override
  MeasurementNotifier create() => MeasurementNotifier();
}

String _$measurementNotifierHash() =>
    r'0ce124e2f5565854b24c4276427b468a89efaa9c';

abstract class _$MeasurementNotifier
    extends $AsyncNotifier<List<MeasurementPreset>> {
  FutureOr<List<MeasurementPreset>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<MeasurementPreset>>,
              List<MeasurementPreset>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MeasurementPreset>>,
                List<MeasurementPreset>
              >,
              AsyncValue<List<MeasurementPreset>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
