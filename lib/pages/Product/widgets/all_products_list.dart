import 'package:flutter/material.dart';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/providers/category_provider.dart';
import 'package:de_helper/providers/subcategory_provider.dart';
import 'package:de_helper/providers/color_provider.dart';
import 'package:de_helper/providers/measurement_provider.dart';
import 'package:de_helper/pages/Product/widgets/all_products_card.dart';
import 'package:de_helper/pages/Product/widgets/product_empty_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllProductsList extends ConsumerWidget {
  final List<Product> products;
  final Set<String> selectedProductIds;
  final bool isSelectionMode;
  final Function(String) onToggleSelection;
  final Function(String) onLongPress;
  final Function(Product) onEdit;
  final Future<bool> Function(Product) onDelete;
  final int currentPage;
  final int itemsPerPage;
  final double horizontalPadding;

  const AllProductsList({
    super.key,
    required this.products,
    required this.selectedProductIds,
    required this.isSelectionMode,
    required this.onToggleSelection,
    required this.onLongPress,
    required this.onEdit,
    required this.onDelete,
    required this.currentPage,
    required this.itemsPerPage,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryProvider);
    final subcategories = ref.watch(subcategoryProvider);
    final colors = ref.watch(colorProvider);
    final measurements = ref.watch(measurementProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (categories.value == null || subcategories.value == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (products.isEmpty) {
      return SliverFillRemaining(
        child: ProductEmptyState(
          isDark: isDark,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
      );
    }

    final paginatedProducts = products
        .skip(currentPage * itemsPerPage)
        .take(itemsPerPage)
        .toList();

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final product = paginatedProducts[index];
          final category = categories.value!.firstWhere(
            (c) => c.id == product.categoryId,
            orElse: () => categories.value!.first,
          );
          final subcategory = product.subCategoryId != null
              ? subcategories.value!.firstWhere(
                  (s) => s.id == product.subCategoryId,
                  orElse: () => subcategories.value!.first,
                )
              : null;
          final color = colors.value?.firstWhere(
            (c) => c.id == product.colorPresetId,
            orElse: () => colors.value!.first,
          );
          final measurement = measurements.value?.firstWhere(
            (m) => m.id == product.measurementPresetId,
            orElse: () => measurements.value!.first,
          );
          final isSelected = selectedProductIds.contains(product.id);

          return AllProductsCard(
            product: product,
            category: category,
            subcategory: subcategory,
            color: color,
            measurement: measurement,
            isSelected: isSelected,
            isSelectionMode: isSelectionMode,
            onTap: () => onToggleSelection(product.id),
            onLongPress: () => onLongPress(product.id),
            onEdit: () => onEdit(product),
            onDelete: () => onDelete(product),
          );
        }, childCount: paginatedProducts.length),
      ),
    );
  }
}
