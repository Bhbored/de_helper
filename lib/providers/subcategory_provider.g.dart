// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcategory_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SubcategoryNotifier)
const subcategoryProvider = SubcategoryNotifierProvider._();

final class SubcategoryNotifierProvider
    extends $AsyncNotifierProvider<SubcategoryNotifier, List<SubCategory>> {
  const SubcategoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subcategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subcategoryNotifierHash();

  @$internal
  @override
  SubcategoryNotifier create() => SubcategoryNotifier();
}

String _$subcategoryNotifierHash() =>
    r'a3612f1fcf57a7634f74532504dda464c7510001';

abstract class _$SubcategoryNotifier extends $AsyncNotifier<List<SubCategory>> {
  FutureOr<List<SubCategory>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<SubCategory>>, List<SubCategory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SubCategory>>, List<SubCategory>>,
              AsyncValue<List<SubCategory>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
