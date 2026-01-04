import 'dart:async';
import 'package:de_helper/data/repos/product_repository_impl.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Product/widgets/all_products_header.dart';
import 'package:de_helper/pages/Product/widgets/all_products_list.dart';
import 'package:de_helper/pages/Product/widgets/all_products_selection_header.dart';
import 'package:de_helper/pages/Product/widgets/product_form_bottom_sheet.dart';
import 'package:de_helper/utility/barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:de_helper/models/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class AllProductsPage extends ConsumerStatefulWidget {
  const AllProductsPage({super.key});

  @override
  ConsumerState<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends ConsumerState<AllProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Product? copied;
  List<Product>? copiedProducts;
  bool _showScrollButton = false;
  bool _isAtBottom = false;
  Timer? _scrollHideTimer;
  bool _isSelectionMode = false;
  final Set<String> _selectedProductIds = {};
  int _currentPage = 0;
  int _itemsPerPage = 10;
  String sortType = 'Name';
  bool _priceSortAscending = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.delayed(const Duration(milliseconds: 100), () {
      ref.read(prodcutProvider.notifier).refreshProduct();
    });
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

  void sortProducts() {
    final products = ref.read(prodcutProvider);
    final sorted = products.value;
    if (sorted == null || sorted.isEmpty) return;
    switch (sortType) {
      case 'Name':
        sorted.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case 'Price':
        sorted.sort((a, b) {
          if (_priceSortAscending) {
            return a.price.compareTo(b.price);
          } else {
            return b.price.compareTo(a.price);
          }
        });
        break;
    }
    ref.read(prodcutProvider.notifier).sortProducts(sorted);
  }

  void filterProducts(String query) {
    setState(() {
      _currentPage = 0;
    });
    if (query.isEmpty) {
      ref.read(prodcutProvider.notifier).refreshProduct().then((_) {
        if (mounted) {
          sortProducts();
        }
      });
    } else {
      ref.read(prodcutProvider.notifier).refreshProduct().then((_) {
        if (mounted) {
          ref.read(prodcutProvider.notifier).filterByNameOrBarcode(query);
          sortProducts();
        }
      });
    }
  }

  void clearSearch() {
    _searchController.clear();
    filterProducts('');
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

  void toggleSelectAll(List<Product> allProducts) {
    setState(() {
      if (_selectedProductIds.length == allProducts.length) {
        _selectedProductIds.clear();
        if (_selectedProductIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedProductIds.clear();
        for (var product in allProducts) {
          _selectedProductIds.add(product.id);
        }
        if (!_isSelectionMode) {
          _isSelectionMode = true;
        }
      }
    });
  }

  Future<void> handleDeleteSelected(List<Product> products) async {
    copiedProducts = List<Product>.from(products);
    copied = null;
    await ref.read(prodcutProvider.notifier).deleteSelection(products);
    setState(() {
      _selectedProductIds.clear();
      _isSelectionMode = false;
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
                copiedProducts = null;
                await ref
                    .read(prodcutProvider.notifier)
                    .deleteProduct(product.id);
                if (context.mounted) {
                  Navigator.of(context).pop(true);
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  void showEditProductBottomSheet(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ProductFormBottomSheet(product: product),
      ),
    ).then((editedProduct) {
      if (editedProduct != null) {
        filterProducts(_searchController.text);
      }
    });
  }

  Future<void> scanBarcode() async {
    final barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (barcode != null && barcode.isNotEmpty) {
      _searchController.text = barcode;
      filterProducts(barcode);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(prodcutProvider, (previous, next) {
      if (copied != null &&
          previous != null &&
          next.value != null &&
          next.value!.length < previous.value!.length) {
        final productToShow = copied!;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product "${productToShow.name}" deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                if (mounted) {
                  copied = null;
                  await ref
                      .read(prodcutProvider.notifier)
                      .addProduct(productToShow);
                }
              },
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (copiedProducts != null &&
          copiedProducts!.isNotEmpty &&
          previous != null &&
          next.value != null &&
          next.value!.length < previous.value!.length) {
        final productsToShow = List<Product>.from(copiedProducts!);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${productsToShow.length} products deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                if (mounted) {
                  copiedProducts = null;
                  for (var product in productsToShow) {
                    await ref
                        .read(prodcutProvider.notifier)
                        .addProduct(product);
                  }
                }
              },
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    final products = ref.watch(prodcutProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _searchController.text.isEmpty &&
          products.value != null &&
          products.value!.isEmpty) {
        ref.read(prodcutProvider.notifier).refreshProduct();
      }
      if (mounted && products.value != null) {
        final totalPages = (products.value!.length / _itemsPerPage).ceil();
        if (_currentPage >= totalPages && totalPages > 0) {
          setState(() {
            _currentPage = totalPages - 1;
          });
        }
      }
    });

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding = screenWidth * 0.05;

    return PageScaffold(
      title: 'All Products',
      titleIcon: Icons.production_quantity_limits_sharp,
      onAction: _isSelectionMode ? null : null,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(prodcutProvider);
          ref.read(prodcutProvider.future);
          exitSelectionMode();
        },
        child: products.when(
          data: (productList) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    AllProductsHeader(
                      productCount: productList.length,
                      searchController: _searchController,
                      onChanged: filterProducts,
                      onClear: clearSearch,
                      onScanBarcode: scanBarcode,
                      sortType: sortType,
                      priceSortAscending: _priceSortAscending,
                      onSortByName: () {
                        setState(() {
                          sortType = 'Name';
                          sortProducts();
                        });
                      },
                      onSortByPrice: () {
                        setState(() {
                          if (sortType == 'Price') {
                            _priceSortAscending = !_priceSortAscending;
                          } else {
                            sortType = 'Price';
                            _priceSortAscending = true;
                          }
                          sortProducts();
                        });
                      },
                      horizontalPadding: horizontalPadding,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      isDark: isDark,
                    ),
                    if (_isSelectionMode && _selectedProductIds.isNotEmpty)
                      AllProductsSelectionHeader(
                        selectedCount: _selectedProductIds.length,
                        totalCount: productList.length,
                        isAllSelected:
                            _selectedProductIds.length == productList.length &&
                            productList.isNotEmpty,
                        onToggleSelectAll: () => toggleSelectAll(productList),
                        onCancel: exitSelectionMode,
                        onDelete: () {
                          final selectedProducts = productList
                              .where(
                                (product) =>
                                    _selectedProductIds.contains(product.id),
                              )
                              .toList();
                          handleDeleteSelected(selectedProducts);
                        },
                        horizontalPadding: horizontalPadding,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        isDark: isDark,
                      ),
                    AllProductsList(
                      products: productList,
                      selectedProductIds: _selectedProductIds,
                      isSelectionMode: _isSelectionMode,
                      onToggleSelection: (productId) {
                        setState(() {
                          toggleSelection(productId);
                        });
                      },
                      onLongPress: (productId) {
                        if (!_isSelectionMode) {
                          setState(() {
                            _isSelectionMode = true;
                            _selectedProductIds.add(productId);
                          });
                        }
                      },
                      onEdit: (product) => showEditProductBottomSheet(product),
                      onDelete: (product) => showDeleteConfirmation(product),
                      currentPage: _currentPage,
                      itemsPerPage: _itemsPerPage,
                      horizontalPadding: horizontalPadding,
                    ),
                    if (productList.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Builder(
                          builder: (context) {
                            final totalPages =
                                (productList.length / _itemsPerPage).ceil();
                            final isFirstPage = _currentPage == 0;
                            final isLastPage = _currentPage >= totalPages - 1;

                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                                vertical: screenHeight * 0.02,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: isFirstPage
                                        ? null
                                        : () {
                                            setState(() {
                                              _currentPage--;
                                            });
                                          },
                                    icon: Icon(Icons.arrow_back_ios),
                                    color: isFirstPage
                                        ? Colors.grey.withValues(alpha: 0.3)
                                        : isDark
                                        ? Colors.green[300]
                                        : Colors.blue,
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.grey[800]
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        screenWidth * 0.025,
                                      ),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.grey[600]!
                                            : Colors.grey[300]!,
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.03,
                                    ),
                                    child: DropdownButton<int>(
                                      value: _itemsPerPage,
                                      underline: Container(),
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: isDark
                                            ? Colors.grey[300]
                                            : Colors.grey[700],
                                      ),
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.grey[900],
                                      ),
                                      dropdownColor: isDark
                                          ? Colors.grey[800]
                                          : Colors.white,
                                      items: [10, 50, 100].map((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(
                                            value.toString(),
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.035,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.grey[900],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (int? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            _itemsPerPage = newValue;
                                            _currentPage = 0;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.05),
                                  Text(
                                    '${_currentPage + 1} of $totalPages',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.grey[900],
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.05),
                                  IconButton(
                                    onPressed: isLastPage
                                        ? null
                                        : () {
                                            setState(() {
                                              _currentPage++;
                                            });
                                          },
                                    icon: Icon(Icons.arrow_forward_ios),
                                    color: isLastPage
                                        ? Colors.grey.withValues(alpha: 0.3)
                                        : isDark
                                        ? Colors.green[300]
                                        : Colors.blue,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
                if (_showScrollButton && !_isSelectionMode)
                  Positioned(
                    left: screenWidth * 0.05,
                    bottom: screenHeight * 0.02,
                    child: FloatingActionButton(
                      heroTag: 'all_products_scroll_button',
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
            );
          },
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
