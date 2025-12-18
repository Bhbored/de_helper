import 'package:flutter/material.dart';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/test_data/test_categories.dart';
import 'package:de_helper/test_data/test_subcategories.dart';
import 'package:de_helper/test_data/test_colors.dart';
import 'package:de_helper/test_data/test_measurements.dart';
import 'package:de_helper/widgets/page_scaffold.dart';

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
          _buildDetailSection(
            context,
            screenWidth,
            screenHeight,
            isDark,
            'Basic Information',
            [
              _buildDetailItem(
                context,
                screenWidth,
                isDark,
                'Price',
                '\$${product.price.toStringAsFixed(2)}',
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: isDark ? Colors.grey[700] : Colors.grey[300],
              ),
              _buildDetailItem(
                context,
                screenWidth,
                isDark,
                'Quantity',
                product.quantity.toString(),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          _buildDetailSection(
            context,
            screenWidth,
            screenHeight,
            isDark,
            'Barcode Information',
            [
              _buildDetailItem(
                context,
                screenWidth,
                isDark,
                'Primary Barcode',
                product.barcode,
              ),
              if (product.secondaryBarcode != null &&
                  product.secondaryBarcode!.isNotEmpty) ...[
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
                _buildDetailItem(
                  context,
                  screenWidth,
                  isDark,
                  'Secondary Barcode',
                  product.secondaryBarcode!,
                ),
              ],
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          _buildDetailSection(
            context,
            screenWidth,
            screenHeight,
            isDark,
            'Category Information',
            [
              _buildDetailItem(
                context,
                screenWidth,
                isDark,
                'Category',
                _getCategoryName(),
              ),
              if (product.subCategoryId != null &&
                  _getSubCategoryName() != 'None') ...[
                Divider(
                  height: 1,
                  thickness: 1,
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                ),
                _buildDetailItem(
                  context,
                  screenWidth,
                  isDark,
                  'Subcategory',
                  _getSubCategoryName(),
                ),
              ],
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          _buildDetailSection(
            context,
            screenWidth,
            screenHeight,
            isDark,
            'Product Attributes',
            [
              _buildDetailItemWithColor(
                context,
                screenWidth,
                isDark,
                'Color',
                _getColorName(),
                _hexToColor(_getColorHex()),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: isDark ? Colors.grey[700] : Colors.grey[300],
              ),
              _buildDetailItem(
                context,
                screenWidth,
                isDark,
                'Measurement Unit',
                _getMeasurementName(),
              ),
            ],
          ),
          if (product.cost > 0 ||
              product.profitMargin > 0 ||
              product.manualCost != null) ...[
            SizedBox(height: screenHeight * 0.02),
            _buildDetailSection(
              context,
              screenWidth,
              screenHeight,
              isDark,
              'Financial Information',
              [
                if (product.cost > 0) ...[
                  _buildDetailItem(
                    context,
                    screenWidth,
                    isDark,
                    'Cost',
                    '\$${product.cost.toStringAsFixed(2)}',
                  ),
                  if (product.profitMargin > 0 || product.manualCost != null)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                    ),
                ],
                if (product.profitMargin > 0) ...[
                  _buildDetailItem(
                    context,
                    screenWidth,
                    isDark,
                    'Profit Margin',
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
                  _buildDetailItem(
                    context,
                    screenWidth,
                    isDark,
                    'Manual Cost',
                    '\$${product.manualCost!.toStringAsFixed(2)}',
                  ),
              ],
            ),
          ],
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }

  Widget _buildDetailSection(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    bool isDark,
    String title,
    List<Widget> children,
  ) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenWidth * 0.04,
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.048,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.grey[900],
                letterSpacing: 0.5,
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    double screenWidth,
    bool isDark,
    String label,
    String value,
  ) {
    if (value.isEmpty || value == 'Unknown' || value == 'None') {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenWidth * 0.035,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth * 0.32,
            child: Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItemWithColor(
    BuildContext context,
    double screenWidth,
    bool isDark,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth * 0.3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: screenWidth * 0.038,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(screenWidth * 0.01),
                    border: Border.all(
                      color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: screenWidth * 0.038,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : Colors.grey[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
