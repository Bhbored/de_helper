// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryRepo)
const categoryRepoProvider = CategoryRepoProvider._();

final class CategoryRepoProvider
    extends
        $FunctionalProvider<
          CategoryRepositoryImpl,
          CategoryRepositoryImpl,
          CategoryRepositoryImpl
        >
    with $Provider<CategoryRepositoryImpl> {
  const CategoryRepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepoHash();

  @$internal
  @override
  $ProviderElement<CategoryRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRepositoryImpl create(Ref ref) {
    return categoryRepo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepositoryImpl>(value),
    );
  }
}

String _$categoryRepoHash() => r'f82b54a12c0a6602d4994a93d790c0255a839d18';
