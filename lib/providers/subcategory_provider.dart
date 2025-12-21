import 'package:de_helper/data/repos/subcategory_repository_impl.dart';
import 'package:de_helper/models/subcategory.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'subcategory_provider.g.dart';

@Riverpod(keepAlive: true)
class SubcategoryNotifier extends _$SubcategoryNotifier {
  SubCategoryRepositoryImpl get _repository =>
      ref.read(subcategoryRepoProvider);

  @override
  FutureOr<List<SubCategory>> build() async {
    print('fetched all subcategory ');
    return _repository.getAll();
  }

  Future<void> addCategory(SubCategory newCategory) async {
    final current = state.value ?? [];
    state = AsyncValue.data([...current, newCategory]);
    try {
      await _repository.create(newCategory);
      refreshCategories();
    } catch (e) {
      state = AsyncValue.data(current);
      throw StateError('erorr adding Category ${newCategory.name}');
    }
  }

  Future<void> addInPlace(SubCategory newCategory, int index) async {
    final current = state.value ?? [];
    current.insert(index, newCategory);
    state = AsyncValue.data([...current]);
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
      refreshCategories();
    } catch (e) {
      state = AsyncValue.data([...current, categoryToBeDeleted]);
      rethrow;
    }
  }

  Future<void> updateCategory(SubCategory cat) async {
    final id = cat.id;
    final current = state.value ?? [];
    final noteIndex = current.indexWhere((x) => x.id == id);
    if (noteIndex == -1) throw StateError('Subcategory with id $id not found');

    final oldTask = current[noteIndex];
    final updatedNotes = [...current];
    updatedNotes[noteIndex] = cat;
    state = AsyncValue.data(updatedNotes);

    try {
      await _repository.update(cat);
      refreshCategories();
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

  int getIndex(SubCategory cat) {
    final current = state.value ?? [];
    final index = current.indexOf(cat);
    return index;
  }

  void sortCategories(List<SubCategory> newList) {
    state = AsyncValue.data(newList);
  }

  void filterByName(String query) {
    final current = state.value ?? [];
    final newList = current
        .where(
          (cat) => cat.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    state = AsyncValue.data(newList);
  }

  Future<void> deleteSelection(List<SubCategory> subcategories) async {
    List<String> ids = [];
    for (var x in subcategories) {
      ids.add(x.id);
    }
    for (var y in ids) {
      _repository.delete(y);
    }
    refreshCategories();
  }
}
