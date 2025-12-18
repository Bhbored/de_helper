import 'package:flutter/material.dart';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/test_data/test_categories.dart';
import 'package:de_helper/test_data/test_subcategories.dart';
import 'package:de_helper/test_data/test_colors.dart';
import 'package:de_helper/test_data/test_measurements.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Product/widgets/product_detail_section.dart';
import 'package:de_helper/pages/Product/widgets/product_detail_item.dart';
import 'package:de_helper/pages/Product/widgets/product_detail_item_with_color.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  String _getCategoryName() {
    try {
      final category = testCategories.firstWhere(
        (c) => c.id == product.categoryId,
      );
      return category.name;
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getSubCategoryName() {
    if (product.subCategoryId == null) return 'None';
    try {
      final subCategory = testSubCategories.firstWhere(
        (s) => s.id == product.subCategoryId,
      );
      return subCategory.name;
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getColorName() {
    try {
      final color = testColors.firstWhere(
        (c) => c.id == product.colorPresetId,
      );
      return color.displayLabel;
    } catch (e) {
      return 'Unknown';
    }
  }

  String _getColorHex() {
    try {
      final color = testColors.firstWhere(
        (c) => c.id == product.colorPresetId,
      );
      return color.hexCode ?? '#000000';
    } catch (e) {
      return '#000000';
    }
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    }
    return Colors.grey;
  }

  String _getMeasurementName() {
    try {
      final measurement = testMeasurements.firstWhere(
        (m) => m.id == product.measurementPresetId,
      );
      return measurement.name;
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final horizontalPadding = screenWidth * 0.05;

    return PageScaffold(
      title: product.name,
      body: ListView(
        padding: EdgeInsets.all(horizontalPadding),
        children: [
          SizedBox(height: screenHeight * 0.02),
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
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
            child: Row(
              children: [
                Container(
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.12,
                  decoration: BoxDecoration(
                    color: _hexToColor(_getColorHex()),
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.green[300] : Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),
          ProductDetailSection(
            isDark: isDark,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            title: 'Basic Information',
            children: [
              ProductDetailItem(
                isDark: isDark,
                screenWidth: screenWidth,
                label: 'Price',
                value: '\$${product.price.toStringAsFixed(2)}',
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: isDark ? Colors.grey[700] : Colors.grey[300],
              ),
              ProductDetailItem(
                isDark: isDark,
                screenWidth: screenWidth,
                label: 'Quantity',
                value: product.quantity.toString(),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          ProductDetailSection(
            isDark: isDark,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            title: 'Barcode Information',
            children: [
              ProductDetailItem(
                isDark: isDark,
                screenWidth: screenWidth,
                label: 'Primary Barcode',
                value: product.barcode,
              ),
              if (product.secondaryBarcode != null &&
                  product.secondaryBarcode!.isNotEmpty) ...[
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
                ProductDetailItem(
                  isDark: isDark,
                  screenWidth: screenWidth,
                  label: 'Secondary Barcode',
                  value: product.secondaryBarcode!,
                ),
              ],
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          ProductDetailSection(
            isDark: isDark,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            title: 'Category Information',
            children: [
              ProductDetailItem(
                isDark: isDark,
                screenWidth: screenWidth,
                label: 'Category',
                value: _getCategoryName(),
              ),
              if (product.subCategoryId != null &&
                  _getSubCategoryName() != 'None') ...[
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
                ProductDetailItem(
                  isDark: isDark,
                  screenWidth: screenWidth,
                  label: 'Subcategory',
                  value: _getSubCategoryName(),
                ),
              ],
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          ProductDetailSection(
            isDark: isDark,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            title: 'Product Attributes',
            children: [
              ProductDetailItemWithColor(
                isDark: isDark,
                screenWidth: screenWidth,
                label: 'Color',
                value: _getColorName(),
                color: _hexToColor(_getColorHex()),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: isDark ? Colors.grey[700] : Colors.grey[300],
              ),
              ProductDetailItem(
                isDark: isDark,
                screenWidth: screenWidth,
                label: 'Measurement Unit',
                value: _getMeasurementName(),
              ),
            ],
          ),
          if (product.cost > 0 ||
              product.profitMargin > 0 ||
              product.manualCost != null) ...[
            SizedBox(height: screenHeight * 0.02),
            ProductDetailSection(
              isDark: isDark,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              title: 'Financial Information',
              children: [
                if (product.cost > 0) ...[
                  ProductDetailItem(
                    isDark: isDark,
                    screenWidth: screenWidth,
                    label: 'Cost',
                    value: '\$${product.cost.toStringAsFixed(2)}',
                  ),
                  if (product.profitMargin > 0 || product.manualCost != null)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),
                ],
                if (product.profitMargin > 0) ...[
                  ProductDetailItem(
                    isDark: isDark,
                    screenWidth: screenWidth,
                    label: 'Profit Margin',
                    value:
                        '${(product.profitMargin * 100).toStringAsFixed(2)}%',
                  ),
                  if (product.manualCost != null)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),
                ],
                if (product.manualCost != null)
                  ProductDetailItem(
                    isDark: isDark,
                    screenWidth: screenWidth,
                    label: 'Manual Cost',
                    value: '\$${product.manualCost!.toStringAsFixed(2)}',
                  ),
              ],
            ),
          ],
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}
