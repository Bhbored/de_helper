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
        isAutoDispose: false,
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
    r'6ac53b2db784e2d9fce8922cc4527ad74c8eb756';

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
