import 'package:de_helper/models/product.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'helpers_providers.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<Product>> productsByCat(Ref ref, String catId) async {
  var products = await ref.watch(prodcutProvider.future);
  var filterProducts = products.where((x) => x.categoryId == catId).toList();
  return filterProducts;
}

@Riverpod(keepAlive: true)
FutureOr<List<Product>> productsBySub(Ref ref, String subId) async {
  var products = await ref.watch(prodcutProvider.future);
  var filterProducts = products.where((x) => x.subCategoryId == subId).toList();
  return filterProducts;
}

@Riverpod(keepAlive: true)
FutureOr<List<Product>> productsByColor(Ref ref, String colorId) async {
  var products = await ref.watch(prodcutProvider.future);
  var filterProducts = products
      .where((x) => x.colorPresetId == colorId)
      .toList();
  return filterProducts;
}

@Riverpod(keepAlive: true)
FutureOr<List<Product>> productsByMeasurement(
  Ref ref,
  String measurementId,
) async {
  var products = await ref.watch(prodcutProvider.future);
  var filterProducts = products
      .where((x) => x.measurementPresetId == measurementId)
      .toList();
  return filterProducts;
}
