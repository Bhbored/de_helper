import 'package:de_helper/test_data/test_products.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/models/category.dart';
import 'package:de_helper/models/subcategory.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Product/product_detail_page.dart';
import 'package:de_helper/widgets/product_form_bottom_sheet.dart';

class ProductPage extends StatefulWidget {
  final Category? category;
  final SubCategory? subCategory;

  const ProductPage({
    super.key,
    this.category,
    this.subCategory,
  }) : assert(
         category != null || subCategory != null,
         'Either category or subCategory must be provided',
       );

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> _displayedProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadProducts() {
    List<Product> filtered;
    if (widget.subCategory != null) {
      filtered = testProducts
          .where((p) => p.subCategoryId == widget.subCategory!.id)
          .toList();
    } else {
      filtered = testProducts
          .where((p) => p.categoryId == widget.category!.id)
          .toList();
    }
    setState(() {
      _displayedProducts = filtered;
    });
  }

  void _filterProducts(String query) {
    setState(() {
      final baseList = widget.subCategory != null
          ? testProducts
                .where((p) => p.subCategoryId == widget.subCategory!.id)
                .toList()
          : testProducts
                .where((p) => p.categoryId == widget.category!.id)
                .toList();

      if (query.isEmpty) {
        _displayedProducts = baseList;
      } else {
        _displayedProducts = baseList
            .where(
              (product) =>
                  product.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterProducts('');
  }

  String _getTitle() {
    if (widget.subCategory != null) {
      return widget.subCategory!.name;
    }
    return widget.category!.name;
  }

  void _showAddProductBottomSheet() {
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
        _loadProducts();
        _filterProducts(_searchController.text);
      }
    });
  }

  void _showEditProductBottomSheet(Product product) {
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
        _loadProducts();
        _filterProducts(_searchController.text);
      }
    });
  }

  Future<bool> _showDeleteConfirmation(Product product) async {
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

  void _deleteProduct(Product product) {
    setState(() {
      testProducts.removeWhere((p) => p.id == product.id);
      _displayedProducts.removeWhere((p) => p.id == product.id);
    });
  }

  Widget _buildEmptyState() {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: screenWidth * 0.25,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding = screenWidth * 0.05;
    final title = _getTitle();

    return PageScaffold(
      title: title,
      onAction: _showAddProductBottomSheet,
      body: CustomScrollView(
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
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
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
                            onChanged: _filterProducts,
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
                                      onPressed: _clearSearch,
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
          _displayedProducts.isEmpty
              ? SliverFillRemaining(
                  child: _buildEmptyState(),
                )
              : SliverList(
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

                      final product = _displayedProducts[index - 1];

                      return Dismissible(
                        key: ValueKey(product.id),
                        direction: DismissDirection.horizontal,
                        background: Container(
                          color: isDark ? Colors.green[700] : Colors.blue,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: screenWidth * 0.05),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: screenWidth * 0.06,
                          ),
                        ),
                        secondaryBackground: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: screenWidth * 0.05),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: screenWidth * 0.06,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            _showEditProductBottomSheet(product);
                            return false;
                          } else if (direction == DismissDirection.endToStart) {
                            return await _showDeleteConfirmation(product);
                          }
                          return false;
                        },
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            _deleteProduct(product);
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
                                color: isDark ? Colors.grey[800] : Colors.white,
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
                    childCount: _displayedProducts.length + 1,
                  ),
                ),
        ],
      ),
    );
  }
}
