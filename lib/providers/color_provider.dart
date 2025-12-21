import 'package:de_helper/data/repos/color_preset_repository_impl.dart';
import 'package:de_helper/models/color_preset.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'color_provider.g.dart';

@riverpod
class ColorNotifier extends _$ColorNotifier {
  ColorPresetRepositoryImpl get _repo => ref.read(colorRepoProvider);

  @override
  FutureOr<List<ColorPreset>> build() async {
    return _repo.getAll();
  }

  Future<void> refreshProduct() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.getAll());
  }

  Future<void> addProduct(ColorPreset color) async {
    final current = state.value ?? [];
    state = AsyncValue.data([...current, color]);
    try {
      await _repo.create(color);
      refreshProduct();
    } catch (e) {
      state = AsyncValue.data(current);
      throw StateError('erorr adding Product ${color.name}');
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

  Future<void> updateProduct(ColorPreset cat) async {
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
        .where(
          (cat) =>
              (cat.name?.toLowerCase() ?? '').contains(query.toLowerCase()) ||
              (cat.hexCode?.toLowerCase() ?? '').contains(query.toLowerCase()),
        )
        .toList();
    state = AsyncValue.data(newList);
  }

  void sortCategories(List<ColorPreset> newList) {
    state = AsyncValue.data(newList);
  }

  Future<void> deleteSelection(List<ColorPreset> colors) async {
    List<String> ids = [];
    for (var x in colors) {
      ids.add(x.id);
    }
    for (var y in ids) {
      _repo.delete(y);
    }
    refreshProduct();
  }
}
