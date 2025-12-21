// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_preset_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(colorRepo)
const colorRepoProvider = ColorRepoProvider._();

final class ColorRepoProvider
    extends
        $FunctionalProvider<
          ColorPresetRepositoryImpl,
          ColorPresetRepositoryImpl,
          ColorPresetRepositoryImpl
        >
    with $Provider<ColorPresetRepositoryImpl> {
  const ColorRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorRepoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorRepoHash();

  @$internal
  @override
  $ProviderElement<ColorPresetRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ColorPresetRepositoryImpl create(Ref ref) {
    return colorRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ColorPresetRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ColorPresetRepositoryImpl>(value),
    );
  }
}

String _$colorRepoHash() => r'5cde2cf26b297ff2615572d06a7355edea4fe9c7';
