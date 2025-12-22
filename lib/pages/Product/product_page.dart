import 'dart:async';
import 'package:de_helper/providers/helpers_providers.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:de_helper/providers/category_provider.dart';
import 'package:de_helper/providers/subcategory_provider.dart';
import 'package:de_helper/providers/color_provider.dart';
import 'package:de_helper/providers/measurement_provider.dart';
import 'package:de_helper/utility/excel_export.dart';
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
  final ScrollController _scrollController = ScrollController();
  Product? copied;
  String sortType = 'Products';
  bool _showScrollButton = false;
  bool _isAtBottom = false;
  Timer? _scrollHideTimer;
  bool _isSelectionMode = false;
  final Set<String> _selectedProductIds = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollHideTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    final isAtBottom = position.pixels >= position.maxScrollExtent - 50;
    final isAtTop = position.pixels <= 50;

    setState(() {
      _isAtBottom = isAtBottom;
      _showScrollButton = !isAtTop;
    });

    _scrollHideTimer?.cancel();
    _scrollHideTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        final currentPosition = _scrollController.position;
        final currentIsAtBottom =
            currentPosition.pixels >= currentPosition.maxScrollExtent - 50;
        final currentIsAtTop = currentPosition.pixels <= 50;
        setState(() {
          _isAtBottom = currentIsAtBottom;
          _showScrollButton = !currentIsAtTop;
        });
      }
    });
  }

  void _scrollToPosition() {
    if (_isAtBottom) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(prodcutProvider, (previous, next) {
      if (copied != null && next.value!.length < previous!.value!.length) {
        final categoryToShow = copied!;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product "${categoryToShow.name}" deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                if (mounted) {
                  await ref.read(prodcutProvider.notifier).addProduct(copied!);
                  copied = null;
                }
              },
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
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
                onPressed: () async {
                  copied = product;
                  await ref
                      .read(prodcutProvider.notifier)
                      .deleteProduct(product.id);
                  if (context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
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

    void toggleSelection(String productId) {
      setState(() {
        if (_selectedProductIds.contains(productId)) {
          _selectedProductIds.remove(productId);
          if (_selectedProductIds.isEmpty) {
            _isSelectionMode = false;
          }
        } else {
          _selectedProductIds.add(productId);
          if (!_isSelectionMode) {
            _isSelectionMode = true;
          }
        }
      });
    }

    void exitSelectionMode() {
      setState(() {
        _isSelectionMode = false;
        _selectedProductIds.clear();
      });
    }

    Future<void> handleDeleteSelected(List<Product> products) async {
      await ref.read(prodcutProvider.notifier).deleteSelection(products);
    }

    Future<void> handleAlterCategorySelected(
      List<Product> products,
      Category? newCategory,
    ) async {
      await ref
          .read(prodcutProvider.notifier)
          .updateSelection(products, newCategory!.id);
    }

    final title = getTitle();

    IconData? categoryIcon;
    if (widget.category != null) {
      categoryIcon = widget.category!.icon;
    } else if (widget.subCategory != null) {
      final categories = ref.watch(categoryProvider);
      if (categories.value != null) {
        try {
          final parentCategory = categories.value!.firstWhere(
            (c) => c.id == widget.subCategory!.categoryId,
          );
          categoryIcon = parentCategory.icon;
        } catch (e) {
          categoryIcon = Icons.category;
        }
      }
    }

    Future<void> exportToExcel() async {
      final displayedProducts = widget.subCategory != null
          ? ref.read(productsBySubProvider(widget.subCategory!.id))
          : ref.read(productsByCatProvider(widget.category!.id));

      await displayedProducts.when(
        data: (products) async {
          if (products.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No products to export'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );

          try {
            final categories = await ref.read(categoryProvider.future);
            final subCategories = await ref.read(subcategoryProvider.future);
            final colors = await ref.read(colorProvider.future);
            final measurements = await ref.read(measurementProvider.future);

            final filePath = await ExcelExport.exportProducts(
              products: products,
              category: widget.category!,
              allCategories: categories,
              allSubCategories: subCategories,
              allColors: colors,
              allMeasurements: measurements,
            );

            if (mounted) {
              Navigator.of(context).pop();
            }

            if (filePath != null) {
              await ExcelExport.shareFile(filePath);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Products exported successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to export products'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            }
          } catch (e) {
            if (mounted) Navigator.of(context).pop();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          }
        },
        error: (error, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading products: $error'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        loading: () {},
      );
    }

    final List<Widget>? appBarActions =
        (widget.category != null && widget.subCategory == null)
        ? [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: exportToExcel,
              tooltip: 'Export to Excel',
            ),
          ]
        : null;

    return PageScaffold(
      title: title,
      titleIcon: categoryIcon,
      onAction: _isSelectionMode ? null : showAddProductBottomSheet,
      showDrawer: false,
      actions: appBarActions,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(prodcutProvider);
          ref.read(prodcutProvider.future);
          exitSelectionMode();
        },
        child: displayedProducts.when(
          data: (data) => Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
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
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
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
                  if (_isSelectionMode && _selectedProductIds.isNotEmpty)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SelectionHeaderDelegate(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: screenHeight * 0.015,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: exitSelectionMode,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  '${_selectedProductIds.length} selected',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.grey[900],
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Flexible(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: Container(
                                        height: screenHeight * 0.035,
                                        width: screenWidth * 0.5,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.02,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isDark
                                                ? Colors.grey[600]!
                                                : Colors.grey[400]!,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            screenWidth * 0.02,
                                          ),
                                          color: isDark
                                              ? Colors.grey[800]
                                              : Colors.grey[100],
                                        ),
                                        child: Builder(
                                          builder: (context) {
                                            Category? currentCategory =
                                                widget.category;
                                            if (currentCategory == null &&
                                                widget.subCategory != null) {
                                              final categories = ref.watch(
                                                categoryProvider,
                                              );
                                              if (categories.value != null) {
                                                try {
                                                  currentCategory = categories
                                                      .value!
                                                      .firstWhere(
                                                        (c) =>
                                                            c.id ==
                                                            widget
                                                                .subCategory!
                                                                .categoryId,
                                                      );
                                                } catch (e) {
                                                  currentCategory = null;
                                                }
                                              }
                                            }
                                            return DropdownButton<Category?>(
                                              value: currentCategory,
                                              isExpanded: true,
                                              isDense: true,
                                              iconSize: screenWidth * 0.04,
                                              underline: const SizedBox(),
                                              hint: Text(
                                                'Alter Category',
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.03,
                                                  color: isDark
                                                      ? Colors.grey[300]
                                                      : Colors.grey[700],
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              items: [
                                                ...ref
                                                    .watch(categoryProvider)
                                                    .when(
                                                      data: (categories) => categories
                                                          .map(
                                                            (
                                                              category,
                                                            ) => DropdownMenuItem<Category?>(
                                                              value: category,
                                                              child: Text(
                                                                category.name,
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      screenWidth *
                                                                      0.03,
                                                                  color: isDark
                                                                      ? Colors
                                                                            .white
                                                                      : Colors
                                                                            .grey[900],
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                      loading: () => [],
                                                      error: (_, __) => [],
                                                    ),
                                              ],
                                              menuMaxHeight: screenHeight * 0.4,
                                              onChanged: (Category? newCategory) {
                                                if (newCategory != null) {
                                                  final selectedProducts = data
                                                      .where(
                                                        (product) =>
                                                            _selectedProductIds
                                                                .contains(
                                                                  product.id,
                                                                ),
                                                      )
                                                      .toList();
                                                  handleAlterCategorySelected(
                                                    selectedProducts,
                                                    newCategory,
                                                  );
                                                  setState(() {
                                                    _selectedProductIds.clear();
                                                    _isSelectionMode = false;
                                                  });
                                                }
                                              },
                                              dropdownColor: isDark
                                                  ? Colors.grey[800]
                                                  : Colors.white,
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.03,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.grey[900],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.015),
                                    ElevatedButton(
                                      onPressed: () {
                                        final selectedProducts = data
                                            .where(
                                              (product) => _selectedProductIds
                                                  .contains(product.id),
                                            )
                                            .toList();
                                        handleDeleteSelected(selectedProducts);
                                        setState(() {
                                          _selectedProductIds.clear();
                                          _isSelectionMode = false;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.04,
                                          vertical: screenHeight * 0.015,
                                        ),
                                      ),
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        height: screenHeight * 0.08,
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
                                              width: screenWidth * 0.18,
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
                                            SizedBox(width: screenWidth * 0.12),
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

                                final product =
                                    displayedProducts.value![index - 1];
                                final isSelected = _selectedProductIds.contains(
                                  product.id,
                                );

                                return GestureDetector(
                                  onLongPress: () {
                                    if (!_isSelectionMode) {
                                      setState(() {
                                        _isSelectionMode = true;
                                        _selectedProductIds.add(product.id);
                                      });
                                    }
                                  },
                                  onTap: _isSelectionMode
                                      ? () {
                                          toggleSelection(product.id);
                                        }
                                      : null,
                                  behavior: _isSelectionMode
                                      ? HitTestBehavior.opaque
                                      : HitTestBehavior.translucent,
                                  child: Dismissible(
                                    key: ValueKey(product.id),
                                    direction: _isSelectionMode
                                        ? DismissDirection.none
                                        : DismissDirection.horizontal,
                                    background: Container(
                                      color: isDark
                                          ? Colors.green[700]
                                          : Colors.blue,
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
                                      if (direction ==
                                          DismissDirection.startToEnd) {
                                        showEditProductBottomSheet(product);
                                        return false;
                                      } else if (direction ==
                                          DismissDirection.endToStart) {
                                        return await showDeleteConfirmation(
                                          product,
                                        );
                                      }
                                      return false;
                                    },
                                    onDismissed: (direction) {
                                      if (direction ==
                                          DismissDirection.endToStart) {}
                                    },
                                    child: Stack(
                                      children: [
                                        Opacity(
                                          opacity: isSelected ? 0.5 : 1.0,
                                          child: InkWell(
                                            onTap: _isSelectionMode
                                                ? null
                                                : () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetailPage(
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
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.06,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.20,
                                                        child: Text(
                                                          product.name,
                                                          style: TextStyle(
                                                            fontSize:
                                                                screenWidth *
                                                                0.035,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors
                                                                      .grey[900],
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.06,
                                                      ),
                                                      Container(
                                                        width:
                                                            screenWidth * 0.18,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          '\$${product.price.toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                            fontSize:
                                                                screenWidth *
                                                                0.035,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: isDark
                                                                ? Colors
                                                                      .green[300]
                                                                : Colors
                                                                      .green[700],
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.12,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          product.barcode,
                                                          style: TextStyle(
                                                            fontSize:
                                                                screenWidth *
                                                                0.032,
                                                            color: isDark
                                                                ? Colors
                                                                      .grey[300]
                                                                : Colors
                                                                      .grey[700],
                                                          ),
                                                          textAlign:
                                                              TextAlign.start,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.06,
                                                      ),
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
                                        ),
                                        if (_isSelectionMode)
                                          Positioned(
                                            top: screenWidth * 0.02,
                                            right: screenWidth * 0.02,
                                            child: Container(
                                              width: screenWidth * 0.08,
                                              height: screenWidth * 0.08,
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: isSelected
                                                      ? Colors.blue
                                                      : Colors.grey,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      screenWidth * 0.02,
                                                    ),
                                              ),
                                              child: isSelected
                                                  ? Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: screenWidth * 0.05,
                                                    )
                                                  : null,
                                            ),
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
              if (_showScrollButton && !_isSelectionMode)
                Positioned(
                  left: screenWidth * 0.05,
                  bottom: screenHeight * 0.02,
                  child: FloatingActionButton(
                    heroTag: 'product_scroll_button',
                    mini: true,
                    onPressed: _scrollToPosition,
                    backgroundColor: isDark ? Colors.green[700] : Colors.blue,
                    child: Icon(
                      _isAtBottom ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.white,
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
      ),
    );
  }
}

class _SelectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SelectionHeaderDelegate({
    required this.child,
    required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_SelectionHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
