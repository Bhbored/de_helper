// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productRepo)
const productRepoProvider = ProductRepoProvider._();

final class ProductRepoProvider
    extends
        $FunctionalProvider<
          ProductRepositoryImpl,
          ProductRepositoryImpl,
          ProductRepositoryImpl
        >
    with $Provider<ProductRepositoryImpl> {
  const ProductRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepoHash();

  @$internal
  @override
  $ProviderElement<ProductRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRepositoryImpl create(Ref ref) {
    return productRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepositoryImpl>(value),
    );
  }
}

String _$productRepoHash() => r'5daecaeb55678571f7ad593f94494cfb1dc83487';
