import 'package:de_helper/models/category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'category_provider.g.dart';

@riverpod
class CategroyNotifier extends _$CategroyNotifier {
  @override
  FutureOr<List<Category>> build() async {
    return [];
  }
}
