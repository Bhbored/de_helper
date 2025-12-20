import 'package:de_helper/data/repos/product_repository_impl.dart';
import 'package:de_helper/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'product_provider.g.dart';

@riverpod
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
    } catch (e) {
      state = AsyncValue.data([...current, categoryToBeDeleted]);
      rethrow;
    }
  }

  Future<void> updateProduct(Product cat) async {
    final id = cat.id;
    final current = state.value ?? [];
    final noteIndex = current.indexWhere((x) => x.id == id);
    if (noteIndex == -1) throw StateError('Category with id $id not found');

    final oldTask = current[noteIndex];
    final updatedNotes = [...current];
    updatedNotes[noteIndex] = cat;
    state = AsyncValue.data(updatedNotes);

    try {
      await _repo.update(cat);
    } catch (e) {
      final rolledBackNotes = [...current];
      rolledBackNotes[noteIndex] = oldTask;
      state = AsyncValue.data(rolledBackNotes);
      rethrow;
    }
  }
}
