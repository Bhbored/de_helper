// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ColorNotifier)
const colorProvider = ColorNotifierProvider._();

final class ColorNotifierProvider
    extends $AsyncNotifierProvider<ColorNotifier, List<ColorPreset>> {
  const ColorNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorNotifierHash();

  @$internal
  @override
  ColorNotifier create() => ColorNotifier();
}

String _$colorNotifierHash() => r'a95647cb9794328ea428d9998673d1827b1ecc69';

abstract class _$ColorNotifier extends $AsyncNotifier<List<ColorPreset>> {
  FutureOr<List<ColorPreset>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<ColorPreset>>, List<ColorPreset>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ColorPreset>>, List<ColorPreset>>,
              AsyncValue<List<ColorPreset>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
