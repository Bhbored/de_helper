// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helpers_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productsByCat)
const productsByCatProvider = ProductsByCatFamily._();

final class ProductsByCatProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const ProductsByCatProvider._({
    required ProductsByCatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productsByCatProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsByCatHash();

  @override
  String toString() {
    return r'productsByCatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    final argument = this.argument as String;
    return productsByCat(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByCatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsByCatHash() => r'11b0a3d71668d4ed2f0e093cb8a4a66bd27617bc';

final class ProductsByCatFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
  const ProductsByCatFamily._()
    : super(
        retry: null,
        name: r'productsByCatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ProductsByCatProvider call(String catId) =>
      ProductsByCatProvider._(argument: catId, from: this);

  @override
  String toString() => r'productsByCatProvider';
}

@ProviderFor(productsBySub)
const productsBySubProvider = ProductsBySubFamily._();

final class ProductsBySubProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const ProductsBySubProvider._({
    required ProductsBySubFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productsBySubProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsBySubHash();

  @override
  String toString() {
    return r'productsBySubProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    final argument = this.argument as String;
    return productsBySub(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsBySubProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsBySubHash() => r'c85757b195b885b532d788a5e3b709fb0c0c9263';

final class ProductsBySubFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
  const ProductsBySubFamily._()
    : super(
        retry: null,
        name: r'productsBySubProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ProductsBySubProvider call(String subId) =>
      ProductsBySubProvider._(argument: subId, from: this);

  @override
  String toString() => r'productsBySubProvider';
}

@ProviderFor(productsByColor)
const productsByColorProvider = ProductsByColorFamily._();

final class ProductsByColorProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const ProductsByColorProvider._({
    required ProductsByColorFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productsByColorProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsByColorHash();

  @override
  String toString() {
    return r'productsByColorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    final argument = this.argument as String;
    return productsByColor(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByColorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsByColorHash() => r'76f133d71b4bf68846e419a6c7fa67499c56e93c';

final class ProductsByColorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
  const ProductsByColorFamily._()
    : super(
        retry: null,
        name: r'productsByColorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ProductsByColorProvider call(String colorId) =>
      ProductsByColorProvider._(argument: colorId, from: this);

  @override
  String toString() => r'productsByColorProvider';
}

@ProviderFor(productsByMeasurement)
const productsByMeasurementProvider = ProductsByMeasurementFamily._();

final class ProductsByMeasurementProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          FutureOr<List<Product>>
        >
    with $FutureModifier<List<Product>>, $FutureProvider<List<Product>> {
  const ProductsByMeasurementProvider._({
    required ProductsByMeasurementFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productsByMeasurementProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productsByMeasurementHash();

  @override
  String toString() {
    return r'productsByMeasurementProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Product>> create(Ref ref) {
    final argument = this.argument as String;
    return productsByMeasurement(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductsByMeasurementProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productsByMeasurementHash() =>
    r'd036623c65e734c43d696a5c71333a19aa1930a1';

final class ProductsByMeasurementFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Product>>, String> {
  const ProductsByMeasurementFamily._()
    : super(
        retry: null,
        name: r'productsByMeasurementProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ProductsByMeasurementProvider call(String measurementId) =>
      ProductsByMeasurementProvider._(argument: measurementId, from: this);

  @override
  String toString() => r'productsByMeasurementProvider';
}
