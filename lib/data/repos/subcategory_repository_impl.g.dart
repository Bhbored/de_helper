// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcategory_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(subcategoryRepo)
const subcategoryRepoProvider = SubcategoryRepoProvider._();

final class SubcategoryRepoProvider
    extends
        $FunctionalProvider<
          SubCategoryRepositoryImpl,
          SubCategoryRepositoryImpl,
          SubCategoryRepositoryImpl
        >
    with $Provider<SubCategoryRepositoryImpl> {
  const SubcategoryRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subcategoryRepoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subcategoryRepoHash();

  @$internal
  @override
  $ProviderElement<SubCategoryRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubCategoryRepositoryImpl create(Ref ref) {
    return subcategoryRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubCategoryRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubCategoryRepositoryImpl>(value),
    );
  }
}

String _$subcategoryRepoHash() => r'0b918348c276282613ecff061c343f618a00a053';
