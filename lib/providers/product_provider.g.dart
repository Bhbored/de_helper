// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProdcutNotifier)
const prodcutProvider = ProdcutNotifierProvider._();

final class ProdcutNotifierProvider
    extends $AsyncNotifierProvider<ProdcutNotifier, List<Product>> {
  const ProdcutNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prodcutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prodcutNotifierHash();

  @$internal
  @override
  ProdcutNotifier create() => ProdcutNotifier();
}

String _$prodcutNotifierHash() => r'92d366579b0aabd3a078f943be98539d9f423b38';

abstract class _$ProdcutNotifier extends $AsyncNotifier<List<Product>> {
  FutureOr<List<Product>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Product>>, List<Product>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Product>>, List<Product>>,
              AsyncValue<List<Product>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
