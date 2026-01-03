import 'package:de_helper/providers/category_provider.dart';
import 'package:de_helper/providers/subcategory_provider.dart';
import 'package:de_helper/providers/color_provider.dart';
import 'package:de_helper/providers/measurement_provider.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Product/product_detail_page.dart';
import 'package:de_helper/pages/Product/widgets/product_empty_state.dart';
import 'package:de_helper/utility/product_data_source.dart';
import 'package:de_helper/utility/barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AllProductsPage extends ConsumerStatefulWidget {
  const AllProductsPage({super.key});

  @override
  ConsumerState<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends ConsumerState<AllProductsPage> {
  final DataGridController _dataGridController = DataGridController();
  final TextEditingController _searchController = TextEditingController();
  ProductDataSource? _productDataSource;

  @override
  void dispose() {
    _searchController.dispose();
    _dataGridController.dispose();
    super.dispose();
  }

  void filterProducts(String query) {
    if (query.isEmpty) {
      ref.read(prodcutProvider.notifier).refreshProduct();
    } else {
      ref.read(prodcutProvider.notifier).filterByNameOrBarcode(query);
    }
  }

  Future<void> scanBarcode() async {
    final barcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (barcode != null && barcode.isNotEmpty) {
      _searchController.text = barcode;
      ref.read(prodcutProvider.notifier).filterByBarcode(barcode);
    }
  }

  void clearSearch() {
    _searchController.clear();
    filterProducts('');
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
          final categories = ref.watch(categoryProvider);
          final subcategories = ref.watch(subcategoryProvider);
          final colors = ref.watch(colorProvider);
          final measurements = ref.watch(measurementProvider);

          if (categories.value == null ||
              subcategories.value == null ||
              colors.value == null ||
              measurements.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          try {
            if (_productDataSource == null) {
              _productDataSource = ProductDataSource(
                products: productList,
                categories: categories.value!,
                subcategories: subcategories.value!,
                colors: colors.value!,
                measurements: measurements.value!,
                onProductTap: (product) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
                isDark: isDark,
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              );
            } else {
              _productDataSource!.updateProducts(productList);
            }
          } catch (e) {
            return Center(
              child: Text(
                'Error initializing data: $e',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          final totalProducts = productList.length;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding * 0.5,
                ),
                child: Card(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
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
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: productList.isEmpty
                    ? ProductEmptyState(
                        isDark: isDark,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: screenHeight * 0.01,
                          vertical: screenHeight * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _productDataSource == null
                            ? const Center(child: CircularProgressIndicator())
                            : RepaintBoundary(
                                child: SfDataGrid(
                                  key: ValueKey(
                                    'products_grid_${_productDataSource!.rows.length}',
                                  ),
                                  source: _productDataSource!,
                                  controller: _dataGridController,
                                  selectionMode: SelectionMode.multiple,
                                  allowSorting: true,
                                  allowFiltering: false,
                                  allowTriStateSorting: true,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
                                  columnWidthMode: ColumnWidthMode.none,
                                  columns: [
                                    GridColumn(
                                      columnName: 'name',
                                      width: 150,
                                      allowFiltering: false,
                                      label: _DataGridHeaderCell(
                                        text: 'Name',
                                        isDark: isDark,
                                        screenWidth: screenWidth,
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'category',
                                      width: 150,
                                      allowFiltering: false,
                                      label: _DataGridHeaderCell(
                                        text: 'Category',
                                        isDark: isDark,
                                        screenWidth: screenWidth,
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'subcategory',
                                      width: 160,
                                      allowFiltering: false,
                                      label: _DataGridHeaderCell(
                                        text: 'Subcategory',
                                        isDark: isDark,
                                        screenWidth: screenWidth,
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'quantity',
                                      width: 130,
                                      allowFiltering: false,
                                      label: _DataGridHeaderCell(
                                        text: 'Quantity',
                                        isDark: isDark,
                                        screenWidth: screenWidth,
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'price',
                                      width: 130,
                                      allowFiltering: false,
                                      label: _DataGridHeaderCell(
                                        text: 'Price',
                                        isDark: isDark,
                                        screenWidth: screenWidth,
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'barcode',
                                      width: 160,
                                      allowSorting: false,
                                      allowFiltering: false,
                                      label: _DataGridHeaderCell(
                                        text: 'Barcode',
                                        isDark: isDark,
                                        screenWidth: screenWidth,
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'secondaryBarcode',
                                      width: 160,
                                      allowSorting: false,
                                      allowFiltering: false,
                                      label: _DataGridHeaderCell(
                                        text: 'Secondary Barcode',
                                        isDark: isDark,
                                        screenWidth: screenWidth,
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'actions',
                                      width: 100,
                                      allowSorting: false,
                                      allowFiltering: false,
                                      label: _DataGridHeaderCell(
                                        text: 'Actions',
                                        isDark: isDark,
                                        screenWidth: screenWidth,
                                      ),
                                    ),
                                  ],
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

class _DataGridHeaderCell extends StatelessWidget {
  final String text;
  final bool isDark;
  final double screenWidth;

  const _DataGridHeaderCell({
    required this.text,
    required this.isDark,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.grey[900],
        ),
        maxLines: 1,
      ),
    );
  }
}
