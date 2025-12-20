import 'package:de_helper/providers/helpers_providers.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/models/category.dart';
import 'package:de_helper/models/subcategory.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Product/product_detail_page.dart';
import 'package:de_helper/pages/Product/widgets/product_form_bottom_sheet.dart';
import 'package:de_helper/pages/Product/widgets/product_empty_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({
    super.key,
    required this.category,
    required this.subCategory,
  });
  final Category? category;
  final SubCategory? subCategory;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  final TextEditingController _searchController = TextEditingController();
  Product? copied;
  int? deleteIndex;
  String sortType = 'Products';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayedProducts = widget.subCategory != null
        ? ref.watch(productsBySubProvider(widget.subCategory!.id))
        : ref.watch(productsByCatProvider(widget.category!.id));
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding = screenWidth * 0.05;

    void filterProducts(String query) {
      if (query.isEmpty) {
        ref.read(prodcutProvider.notifier).refreshProduct();
      } else {
        ref.read(prodcutProvider.notifier).filterByName(query);
      }
    }

    void clearSearch() {
      _searchController.clear();
      filterProducts('');
    }

    String getTitle() {
      if (widget.subCategory != null) {
        return widget.subCategory!.name;
      }
      return widget.category!.name;
    }

    void showAddProductBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        useSafeArea: true,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ProductFormBottomSheet(
            category: widget.category,
            subCategory: widget.subCategory,
          ),
        ),
      ).then((product) {
        if (product != null) {
          filterProducts(_searchController.text);
        }
      });
    }

    void showEditProductBottomSheet(Product product) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        useSafeArea: true,
        builder: (context) => SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ProductFormBottomSheet(
            category: widget.category,
            subCategory: widget.subCategory,
            product: product,
          ),
        ),
      ).then((editedProduct) {
        if (editedProduct != null) {
          filterProducts(_searchController.text);
        }
      });
    }

    Future<bool> showDeleteConfirmation(Product product) async {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final screenWidth = MediaQuery.of(context).size.width;

      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey[800] : Colors.white,
            title: Text(
              'Delete Product',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            content: Text(
              'Are you sure you want to delete "${product.name}"?',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
      return result ?? false;
    }

    // void deleteProduct(Product product) {
    //   setState(() {
    //     testProducts.removeWhere((p) => p.id == product.id);
    //     displayedProducts.removeWhere((p) => p.id == product.id);
    //   });
    // }

    final title = getTitle();

    return PageScaffold(
      title: title,
      onAction: showAddProductBottomSheet,
      body: displayedProducts.when(
        data: (data) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.06),
                  topRight: Radius.circular(screenWidth * 0.06),
                ),
                child: Container(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _searchController,
                          builder: (context, value, child) {
                            return TextField(
                              controller: _searchController,
                              onChanged: filterProducts,
                              decoration: InputDecoration(
                                hintText: 'Search products...',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[400],
                                ),
                                suffixIcon: value.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.grey[400],
                                        ),
                                        onPressed: clearSearch,
                                      )
                                    : null,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
                                  vertical: screenHeight * 0.02,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            displayedProducts.value!.isEmpty
                ? SliverFillRemaining(
                    child: ProductEmptyState(
                      isDark: isDark,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                Container(
                                  height: screenHeight * 0.06,
                                  color: isDark
                                      ? Colors.grey[850]
                                      : Colors.grey[100],
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.06),
                                      SizedBox(
                                        width: screenWidth * 0.20,
                                        child: Text(
                                          'Name',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.grey[300]
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.06),
                                      Container(
                                        width: screenWidth * 0.12,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Price',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.grey[300]
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.20),
                                      Expanded(
                                        child: Text(
                                          'Barcode',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.grey[300]
                                                : Colors.grey[700],
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.06),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: isDark
                                      ? Colors.grey[700]
                                      : Colors.grey[300],
                                ),
                              ],
                            );
                          }

                          final product = displayedProducts.value![index - 1];

                          return Dismissible(
                            key: ValueKey(product.id),
                            direction: DismissDirection.horizontal,
                            background: Container(
                              color: isDark ? Colors.green[700] : Colors.blue,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.05,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: screenWidth * 0.06,
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(
                                right: screenWidth * 0.05,
                              ),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: screenWidth * 0.06,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                showEditProductBottomSheet(product);
                                return false;
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                return await showDeleteConfirmation(product);
                              }
                              return false;
                            },
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                // deleteProduct(product);
                              }
                            },
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
                                      product: product,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: screenHeight * 0.08,
                                    color: isDark
                                        ? Colors.grey[800]
                                        : Colors.white,
                                    child: Row(
                                      children: [
                                        SizedBox(width: screenWidth * 0.06),
                                        SizedBox(
                                          width: screenWidth * 0.20,
                                          child: Text(
                                            product.name,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.035,
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.grey[900],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.06),
                                        Container(
                                          width: screenWidth * 0.12,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '\$${product.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.035,
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.green[300]
                                                  : Colors.green[700],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.20),
                                        Expanded(
                                          child: Text(
                                            product.barcode,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.032,
                                              color: isDark
                                                  ? Colors.grey[300]
                                                  : Colors.grey[700],
                                            ),
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.06),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 0,
                                    thickness: 1,
                                    color: isDark
                                        ? Colors.grey[700]
                                        : Colors.grey[300],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: displayedProducts.value!.length + 1,
                      ),
                    ),
                  ),
          ],
        ),
        error: (e, s) => Center(
          child: Text(
            e.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        loading: () {
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
