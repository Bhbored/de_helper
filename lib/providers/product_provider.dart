import 'package:de_helper/models/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'product_provider.g.dart';

@riverpod
class ProdcutNotifier extends _$ProdcutNotifier {
  @override
  FutureOr<List<Product>> build() async {
    return [];
  }
}
