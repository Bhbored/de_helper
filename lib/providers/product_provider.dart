import 'package:de_helper/data/repos/product_repository_impl.dart';
import 'package:de_helper/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'product_provider.g.dart';

@Riverpod(keepAlive: true)
class ProdcutNotifier extends _$ProdcutNotifier {
  ProductRepositoryImpl get _repo => ref.read(productRepoProvider);
  @override
  FutureOr<List<Product>> build() async {
    return _repo.getAll();
  }

  Future<void> refreshProduct() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.getAll());
  }

  Future<void> addProduct(Product newProduct) async {
    final current = state.value ?? [];
    state = AsyncValue.data([...current, newProduct]);
    try {
      await _repo.create(newProduct);
      refreshProduct();
    } catch (e) {
      state = AsyncValue.data(current);
      throw StateError('erorr adding Product ${newProduct.name}');
    }
  }

  Future<void> deleteProduct(String id) async {
    final current = state.value ?? [];
    final categoryToBeDeleted = current.firstWhere(
      (x) => x.id == id,
      orElse: () => throw StateError('Category $id isnt found '),
    );
    state = AsyncValue.data(current.where((x) => x.id != id).toList());
    try {
      _repo.delete(id);
      refreshProduct();
    } catch (e) {
      state = AsyncValue.data([...current, categoryToBeDeleted]);
      rethrow;
    }
  }

  Future<void> updateProduct(Product cat) async {
    final id = cat.id;
    final current = state.value ?? [];
    final noteIndex = current.indexWhere((x) => x.id == id);
    if (noteIndex == -1) throw StateError('Product with id $id not found');

    final oldTask = current[noteIndex];
    final updatedNotes = [...current];
    updatedNotes[noteIndex] = cat;
    state = AsyncValue.data(updatedNotes);

    try {
      await _repo.update(cat);
      refreshProduct();
    } catch (e) {
      final rolledBackNotes = [...current];
      rolledBackNotes[noteIndex] = oldTask;
      state = AsyncValue.data(rolledBackNotes);
      rethrow;
    }
  }

  void filterByName(String query) {
    final current = state.value ?? [];
    final newList = current
        .where((cat) => cat.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    state = AsyncValue.data(newList);
  }

  void filterByBarcode(String barcode) {
    final current = state.value ?? [];
    final barcodeLower = barcode.toLowerCase();
    final newList = current
        .where(
          (cat) =>
              cat.barcode.toLowerCase().contains(barcodeLower) ||
              (cat.secondaryBarcode != null &&
                  cat.secondaryBarcode!.toLowerCase().contains(barcodeLower)),
        )
        .toList();
    state = AsyncValue.data(newList);
  }

  void filterByNameOrBarcode(String query) {
    final current = state.value ?? [];
    final queryLower = query.toLowerCase();
    final newList = current.where((product) {
      final nameMatch = product.name.toLowerCase().contains(queryLower);
      final barcodeMatch =
          product.barcode.toLowerCase().contains(queryLower) ||
          (product.secondaryBarcode != null &&
              product.secondaryBarcode!.toLowerCase().contains(queryLower));
      return nameMatch || barcodeMatch;
    }).toList();
    state = AsyncValue.data(newList);
  }

  Future<void> deleteSelection(List<Product> products) async {
    if (products.isEmpty) return;

    final current = state.value ?? [];
    List<String> ids = [];
    for (var x in products) {
      ids.add(x.id);
    }
    state = AsyncValue.data(current.where((x) => !ids.contains(x.id)).toList());
    try {
      for (var y in ids) {
        _repo.delete(y);
      }
      refreshProduct();
    } catch (e) {
      state = AsyncValue.data(current);
      rethrow;
    }
  }

  Future<void> updateSelection(
    List<Product> products,
    String newCategoryId,
  ) async {
    if (products.isEmpty) return;
    try {
      for (final product in products) {
        await _repo.update(
          product.copyWith(categoryId: newCategoryId, subCategoryId: null),
        );
      }
      refreshProduct();
    } catch (e) {
      throw StateError('Error updating products: $e');
    }
  }

  void sortProducts(List<Product> newList) {
    state = AsyncValue.data(newList);
  }
}
