import 'package:de_helper/data/repos/measurement_preset_repository_impl.dart';
import 'package:de_helper/models/measurement.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'measurement_provider.g.dart';

@Riverpod(keepAlive: true)
class MeasurementNotifier extends _$MeasurementNotifier {
  MeasurementPresetRepositoryImpl get _repo => ref.read(measurmentRepoProvider);
  @override
  FutureOr<List<MeasurementPreset>> build() async {
    return _repo.getAll();
  }

  Future<void> refreshMeasurement() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.getAll());
  }

  Future<void> addMeasurement(MeasurementPreset measurment) async {
    final current = state.value ?? [];
    state = AsyncValue.data([...current, measurment]);
    try {
      await _repo.create(measurment);
      refreshMeasurement();
    } catch (e) {
      state = AsyncValue.data(current);
      throw StateError('erorr adding Product ${measurment.name}');
    }
  }

  Future<void> deleteMeasurement(String id) async {
    final current = state.value ?? [];
    final categoryToBeDeleted = current.firstWhere(
      (x) => x.id == id,
      orElse: () => throw StateError('Category $id isnt found '),
    );

    // Prevent deletion of NULL preset
    if (categoryToBeDeleted.name == 'NULL') {
      throw StateError('Cannot delete NULL preset');
    }

    state = AsyncValue.data(current.where((x) => x.id != id).toList());
    try {
      _repo.delete(id);
      refreshMeasurement();
    } catch (e) {
      state = AsyncValue.data([...current, categoryToBeDeleted]);
      rethrow;
    }
  }

  Future<void> updateMeasurement(MeasurementPreset cat) async {
    final id = cat.id;
    final current = state.value ?? [];
    final noteIndex = current.indexWhere((x) => x.id == id);
    if (noteIndex == -1) throw StateError('Product with id $id not found');

    if (cat.name == 'NULL') {
      throw StateError('Cannot update NULL preset');
    }

    final oldTask = current[noteIndex];
    final updatedNotes = [...current];
    updatedNotes[noteIndex] = cat;
    state = AsyncValue.data(updatedNotes);

    try {
      await _repo.update(cat);
      refreshMeasurement();
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
          (cat) => (cat.name.toLowerCase()).contains(query.toLowerCase()),
        )
        .toList();
    state = AsyncValue.data(newList);
  }

  void sortMeasurement(List<MeasurementPreset> newList) {
    state = AsyncValue.data(newList);
  }

  Future<void> deleteSelection(List<MeasurementPreset> measurments) async {
    final measurementsToDelete = measurments
        .where((m) => m.name != 'NULL')
        .toList();
    if (measurementsToDelete.isEmpty) return;

    List<String> ids = [];
    for (var x in measurementsToDelete) {
      ids.add(x.id);
    }
    for (var y in ids) {
      _repo.delete(y);
    }
    refreshMeasurement();
  }
}
