// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CategroyNotifier)
const categroyProvider = CategroyNotifierProvider._();

final class CategroyNotifierProvider
    extends $AsyncNotifierProvider<CategroyNotifier, List<Category>> {
  const CategroyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categroyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categroyNotifierHash();

  @$internal
  @override
  CategroyNotifier create() => CategroyNotifier();
}

String _$categroyNotifierHash() => r'7a567de168296c207f45f758c84dfbd154f0719e';

abstract class _$CategroyNotifier extends $AsyncNotifier<List<Category>> {
  FutureOr<List<Category>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Category>>, List<Category>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Category>>, List<Category>>,
              AsyncValue<List<Category>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
