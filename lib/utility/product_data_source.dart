import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/models/category.dart';
import 'package:de_helper/models/subcategory.dart';

class ProductDataSource extends DataGridSource {
  ProductDataSource({
    required List<Product> products,
    required List<Category> categories,
    required List<SubCategory> subcategories,
    required List<dynamic> colors,
    required List<dynamic> measurements,
    required this.onProductTap,
    required this.isDark,
    required this.screenWidth,
    required this.screenHeight,
  }) {
    _products = products;
    _categories = categories;
    _subcategories = subcategories;
    _buildDataGridRows();
  }

  List<Product> _products = [];
  List<Category> _categories = [];
  List<SubCategory> _subcategories = [];
  List<DataGridRow> _dataGridRows = [];
  final Function(Product) onProductTap;
  final bool isDark;
  final double screenWidth;
  final double screenHeight;

  void _buildDataGridRows() {
    try {
      _dataGridRows = _products.map<DataGridRow>((product) {
        try {
          final category = _categories.isNotEmpty
              ? _categories.firstWhere(
                  (c) => c.id == product.categoryId,
                  orElse: () =>
                      Category(id: '', name: 'Unknown', icon: Icons.category),
                )
              : Category(id: '', name: 'Unknown', icon: Icons.category);

          final subcategory =
              product.subCategoryId != null && _subcategories.isNotEmpty
              ? _subcategories.firstWhere(
                  (s) => s.id == product.subCategoryId,
                  orElse: () =>
                      SubCategory(id: '', name: 'Unknown', categoryId: ''),
                )
              : null;

          final nameValue = (product.name.isNotEmpty
              ? product.name
              : 'Unknown');
          final categoryValue = (category.name.isNotEmpty
              ? category.name
              : 'Unknown');
          final subcategoryValue =
              (subcategory != null && subcategory.name.isNotEmpty)
              ? subcategory.name
              : 'N/A';
          final quantityValue = product.quantity.toString();
          final priceValue = product.price.toStringAsFixed(2);
          final barcodeValue = product.barcode.isNotEmpty
              ? product.barcode
              : '';
          final secondaryBarcodeValue =
              (product.secondaryBarcode?.isNotEmpty == true)
              ? product.secondaryBarcode!
              : 'N/A';

          return DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'name', value: nameValue),
              DataGridCell<String>(
                columnName: 'category',
                value: categoryValue,
              ),
              DataGridCell<String>(
                columnName: 'subcategory',
                value: subcategoryValue,
              ),
              DataGridCell<String>(
                columnName: 'quantity',
                value: quantityValue,
              ),
              DataGridCell<String>(columnName: 'price', value: priceValue),
              DataGridCell<String>(columnName: 'barcode', value: barcodeValue),
              DataGridCell<String>(
                columnName: 'secondaryBarcode',
                value: secondaryBarcodeValue,
              ),
              DataGridCell<String>(columnName: 'actions', value: ''),
            ],
          );
        } catch (e) {
          return DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'name', value: 'Error'),
              DataGridCell<String>(columnName: 'category', value: 'N/A'),
              DataGridCell<String>(columnName: 'subcategory', value: 'N/A'),
              DataGridCell<String>(columnName: 'quantity', value: '0'),
              DataGridCell<String>(columnName: 'price', value: '0.00'),
              DataGridCell<String>(columnName: 'barcode', value: ''),
              DataGridCell<String>(
                columnName: 'secondaryBarcode',
                value: 'N/A',
              ),
              DataGridCell<String>(columnName: 'actions', value: ''),
            ],
          );
        }
      }).toList();
    } catch (e) {
      _dataGridRows = [];
    }
  }

  @override
  List<DataGridRow> get rows {
    if (_dataGridRows.isEmpty) {
      return [];
    }
    try {
      return List<DataGridRow>.unmodifiable(_dataGridRows);
    } catch (e) {
      return [];
    }
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    try {
      Product? product;
      try {
        final nameCell = row.getCells().firstWhere(
          (cell) => cell.columnName == 'name',
        );
        final productName = nameCell.value?.toString();
        if (productName != null &&
            productName.isNotEmpty &&
            _products.isNotEmpty) {
          product = _products.firstWhere(
            (p) => p.name == productName,
            orElse: () => _products.first,
          );
        }
      } catch (e) {
        product = null;
      }

      return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          if (dataGridCell.columnName == 'actions') {
            if (product != null) {
              final currentProduct = product;
              return Container(
                alignment: Alignment.center,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                child: GestureDetector(
                  onTap: () {
                    try {
                      onProductTap(currentProduct);
                    } catch (e) {
                      // Ignore tap errors
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.01),
                    child: Icon(
                      Icons.visibility,
                      size: screenWidth * 0.04,
                      color: isDark ? Colors.green[300] : Colors.blue,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }

          Widget cellWidget;
          try {
            if (dataGridCell.columnName == 'price') {
              final value = dataGridCell.value?.toString() ?? '';
              cellWidget = Text(
                '\$$value',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: isDark ? Colors.white : Colors.grey[900],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              );
            } else if (dataGridCell.columnName == 'quantity') {
              final value = dataGridCell.value?.toString() ?? '';
              cellWidget = Text(
                value,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: isDark ? Colors.white : Colors.grey[900],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              );
            } else {
              cellWidget = Text(
                dataGridCell.value?.toString() ?? '',
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: isDark ? Colors.white : Colors.grey[900],
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              );
            }
          } catch (e) {
            cellWidget = Text(
              '',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            );
          }

          return Container(
            alignment:
                (dataGridCell.columnName == 'quantity' ||
                    dataGridCell.columnName == 'price')
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.02,
              vertical: screenHeight * 0.01,
            ),
            constraints: const BoxConstraints(),
            child: cellWidget,
          );
        }).toList(),
      );
    } catch (e) {
      return DataGridRowAdapter(
        cells: List.generate(
          8,
          (index) => Container(padding: EdgeInsets.all(8), child: Text('')),
        ),
      );
    }
  }

  Product? getProductFromRow(DataGridRow row) {
    try {
      final nameCell = row.getCells().firstWhere(
        (cell) => cell.columnName == 'name',
      );
      final productName = nameCell.value as String;
      return _products.firstWhere(
        (p) => p.name == productName,
        orElse: () => _products.first,
      );
    } catch (e) {
      return null;
    }
  }

  void updateProducts(List<Product> products) {
    try {
      _products = products;
      _buildDataGridRows();
      notifyListeners();
    } catch (e) {
      _dataGridRows = [];
      notifyListeners();
    }
  }
}
