import 'package:de_helper/data/repos/category_repository_impl.dart';
import 'package:de_helper/models/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'category_provider.g.dart';

@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  CategoryRepositoryImpl get _repository => ref.read(categoryRepoProvider);
  @override
  FutureOr<List<Category>> build() async {
    return _repository.getAll();
  }

  Future<void> addCategory(Category newCategory) async {
    final current = state.value ?? [];
    state = AsyncValue.data([...current, newCategory]);
    try {
      await _repository.create(newCategory);
    } catch (e) {
      state = AsyncValue.data(current);
      throw StateError('erorr adding Category ${newCategory.name}');
    }
  }

  Future<void> deleteCategory(String id) async {
    final current = state.value ?? [];
    final categoryToBeDeleted = current.firstWhere(
      (x) => x.id == id,
      orElse: () => throw StateError('Category $id isnt found '),
    );
    state = AsyncValue.data(current.where((x) => x.id != id).toList());
    try {
      _repository.delete(id);
    } catch (e) {
      state = AsyncValue.data([...current, categoryToBeDeleted]);
      rethrow;
    }
  }

  Future<void> updateCategory(Category cat) async {
    final id = cat.id;
    final current = state.value ?? [];
    final noteIndex = current.indexWhere((x) => x.id == id);
    if (noteIndex == -1) throw StateError('Category with id $id not found');

    final oldTask = current[noteIndex];
    final updatedNotes = [...current];
    updatedNotes[noteIndex] = cat;
    state = AsyncValue.data(updatedNotes);

    try {
      await _repository.update(cat);
    } catch (e) {
      final rolledBackNotes = [...current];
      rolledBackNotes[noteIndex] = oldTask;
      state = AsyncValue.data(rolledBackNotes);
      rethrow;
    }
  }

  Future<void> refreshCategories() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getAll());
  }
}
