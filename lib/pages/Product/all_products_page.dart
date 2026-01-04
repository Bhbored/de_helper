import 'dart:ui';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/providers/category_provider.dart';
import 'package:de_helper/providers/subcategory_provider.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Product/product_detail_page.dart';
import 'package:de_helper/pages/Product/widgets/product_empty_state.dart';
import 'package:de_helper/utility/barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/models/category.dart';
import 'package:de_helper/models/subcategory.dart';

class AllProductsPage extends ConsumerStatefulWidget {
  const AllProductsPage({super.key});

  @override
  ConsumerState<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends ConsumerState<AllProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  PlutoGridStateManager? _stateManager;
  List<Product>? _allProducts;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterProducts(String query) {
    setState(() {
      // Filtering is now handled in the build method
    });
  }

  List<Product> _filterProducts(List<Product> allProducts, String query) {
    if (query.isEmpty) {
      return allProducts;
    }
    final queryLower = query.toLowerCase();
    return allProducts.where((product) {
      final nameMatch = product.name.toLowerCase().contains(queryLower);
      final barcodeMatch =
          product.barcode.toLowerCase().contains(queryLower) ||
          (product.secondaryBarcode != null &&
              product.secondaryBarcode!.toLowerCase().contains(queryLower));
      return nameMatch || barcodeMatch;
    }).toList();
  }

  Future<void> scanBarcode() async {
    final barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (barcode != null && barcode.isNotEmpty) {
      _searchController.text = barcode;
      setState(() {
        // Filtering is handled in build method
      });
    }
  }

  void clearSearch() {
    _searchController.clear();
    filterProducts('');
  }

  List<PlutoColumn> _buildColumns(bool isDark, double screenWidth) {
    return [
      PlutoColumn(
        title: 'Name',
        field: 'name',
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Category',
        field: 'category',
        type: PlutoColumnType.text(),
        width: 150,
      ),
      PlutoColumn(
        title: 'Subcategory',
        field: 'subcategory',
        type: PlutoColumnType.text(),
        width: 160,
      ),
      PlutoColumn(
        title: 'Quantity',
        field: 'quantity',
        type: PlutoColumnType.number(),
        width: 130,
      ),
      PlutoColumn(
        title: 'Price',
        field: 'price',
        type: PlutoColumnType.text(),
        width: 130,
      ),
      PlutoColumn(
        title: 'Barcode',
        field: 'barcode',
        type: PlutoColumnType.text(),
        width: 160,
      ),
      PlutoColumn(
        title: 'Secondary Barcode',
        field: 'secondaryBarcode',
        type: PlutoColumnType.text(),
        width: 160,
      ),
      PlutoColumn(
        title: 'Actions',
        field: 'actions',
        type: PlutoColumnType.text(),
        width: 100,
        enableSorting: false,
        enableFilterMenuItem: false,
      ),
    ];
  }

  List<PlutoRow> _buildRows(
    List<Product> productList,
    List<Category> categories,
    List<SubCategory> subcategories,
  ) {
    return productList.map<PlutoRow>((product) {
      final category = categories.firstWhere(
        (c) => c.id == product.categoryId,
        orElse: () => categories.first,
      );
      final subcategory = product.subCategoryId != null
          ? subcategories.firstWhere(
              (s) => s.id == product.subCategoryId,
              orElse: () => subcategories.first,
            )
          : null;

      return PlutoRow(
        key: ValueKey(product.id),
        cells: {
          'name': PlutoCell(value: product.name),
          'category': PlutoCell(value: category.name),
          'subcategory': PlutoCell(value: subcategory?.name ?? 'N/A'),
          'quantity': PlutoCell(value: product.quantity),
          'price': PlutoCell(value: '\$${product.price.toStringAsFixed(2)}'),
          'barcode': PlutoCell(value: product.barcode),
          'secondaryBarcode': PlutoCell(
            value: product.secondaryBarcode ?? 'N/A',
          ),
          'actions': PlutoCell(value: product),
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(prodcutProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _searchController.text.isEmpty &&
          products.value != null &&
          products.value!.isEmpty) {
        ref.read(prodcutProvider.notifier).refreshProduct();
      }
      if (mounted) {
        if (_searchController.text.isEmpty) {
          ref.read(prodcutProvider.notifier).refreshProduct();
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
      onAction: null,
      body: products.when(
        data: (productList) {
          // Store the full list when search is empty (meaning we have the full list from provider)
          if (_searchController.text.isEmpty) {
            _allProducts = List.from(productList);
          }
          _allProducts ??= List.from(productList);

          final categories = ref.watch(categoryProvider);
          final subcategories = ref.watch(subcategoryProvider);

          if (categories.value == null || subcategories.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter products locally based on search query
          final filteredProducts = _filterProducts(
            _allProducts ?? productList,
            _searchController.text,
          );

          final totalProducts = filteredProducts.length;
          final columns = _buildColumns(isDark, screenWidth);
          final rows = _buildRows(
            filteredProducts,
            categories.value!,
            subcategories.value!,
          );

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding * 0.5,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: isDark ? AppGradients.glassDark : AppGradients.glass,
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        border: Border.all(
                          color: isDark ? Colors.white10 : Colors.white24,
                        ),
                      ),
                      child: Padding(
                    padding: EdgeInsets.all(horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Products',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.grey[900],
                              ),
                            ),
                            Text(
                              totalProducts.toString(),
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.green[300]
                                    : Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.grey[900]
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(
                                    screenWidth * 0.025,
                                  ),
                                ),
                                child: ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _searchController,
                                  builder: (context, value, child) {
                                    return TextField(
                                      controller: _searchController,
                                      onChanged: filterProducts,
                                      decoration: InputDecoration(
                                        hintText: 'Search Products...',
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
                                          horizontal: horizontalPadding * 0.5,
                                          vertical: screenHeight * 0.015,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Container(
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey[900]
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(
                                  screenWidth * 0.025,
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.qr_code_scanner,
                                  color: isDark
                                      ? Colors.green[300]
                                      : Colors.blue[700],
                                ),
                                onPressed: scanBarcode,
                                tooltip: 'Scan Barcode',
                                padding: EdgeInsets.all(screenWidth * 0.03),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: filteredProducts.isEmpty
                    ? ProductEmptyState(
                        isDark: isDark,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      )
                    : PlutoGrid(
                        mode: PlutoGridMode.multiSelect,
                        columns: columns,
                        rows: rows,
                        onLoaded: (PlutoGridOnLoadedEvent event) {
                          _stateManager = event.stateManager;
                          _stateManager!.setSelectingMode(
                            PlutoGridSelectingMode.row,
                          );
                          // Clear any default cell activation
                          _stateManager!.clearCurrentCell();
                          // Also clear after frame to ensure it's cleared
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (_stateManager != null && mounted) {
                              _stateManager!.clearCurrentCell();
                            }
                          });
                        },
                        onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) {
                          final product = event.row.cells['actions']!.value;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                        configuration: PlutoGridConfiguration(
                          style: PlutoGridStyleConfig(
                            gridBackgroundColor: isDark
                                ? Colors.grey[900]!
                                : Colors.white,
                            borderColor: isDark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                            activatedColor: isDark
                                ? Colors.yellow[500]!.withValues(alpha: 0.8)
                                : Colors.yellow[300]!,
                            activatedBorderColor: Colors.transparent,
                            inactivatedBorderColor: isDark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                            checkedColor: isDark
                                ? Colors.yellow[500]!.withValues(alpha: 0.8)
                                : Colors.yellow[300]!,
                            rowColor: isDark ? Colors.grey[900]! : Colors.white,
                            oddRowColor: isDark
                                ? Colors.grey[800]!
                                : Colors.grey[50]!,
                            columnTextStyle: TextStyle(
                              color: isDark ? Colors.white : Colors.grey[900]!,
                            ),
                            cellTextStyle: TextStyle(
                              color: isDark ? Colors.white : Colors.grey[900]!,
                            ),
                          ),
                          columnSize: PlutoGridColumnSizeConfig(
                            autoSizeMode: PlutoAutoSizeMode.none,
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            error.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
