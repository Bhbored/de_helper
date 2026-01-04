import 'package:flutter/material.dart';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/models/category.dart';
import 'package:de_helper/models/subcategory.dart';
import 'package:de_helper/models/color_preset.dart';
import 'package:de_helper/models/measurement.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/pages/Product/product_detail_page.dart';

class AllProductsCard extends StatelessWidget {
  final Product product;
  final Category category;
  final SubCategory? subcategory;
  final ColorPreset? color;
  final MeasurementPreset? measurement;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final Future<bool> Function()? onDelete;

  const AllProductsCard({
    super.key,
    required this.product,
    required this.category,
    this.subcategory,
    this.color,
    this.measurement,
    required this.isSelected,
    required this.isSelectionMode,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDelete,
  });

  Widget _buildChip(
    IconData icon,
    String label,
    Color color,
    bool isDark,
    double screenWidth,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.025,
        vertical: screenWidth * 0.01,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(screenWidth * 0.015),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: screenWidth * 0.03, color: color),
          SizedBox(width: screenWidth * 0.01),
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.w600,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStat(
    IconData icon,
    String value,
    Color color,
    bool isDark,
    double screenWidth,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: screenWidth * 0.035, color: color),
        SizedBox(width: screenWidth * 0.01),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: -0.3,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final horizontalPadding = screenWidth * 0.05;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      behavior: isSelectionMode
          ? HitTestBehavior.opaque
          : HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.015),
        child: Stack(
          children: [
            Opacity(
              opacity: isSelected ? 0.5 : 1.0,
              child: Dismissible(
                key: ValueKey(product.id),
                direction: isSelectionMode
                    ? DismissDirection.none
                    : DismissDirection.horizontal,
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
                    onEdit?.call();
                    return false;
                  } else if (direction == DismissDirection.endToStart) {
                    return await onDelete?.call() ?? false;
                  }
                  return false;
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {}
                },
                child: InkWell(
                  onTap: isSelectionMode
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailPage(product: product),
                            ),
                          );
                        },
                  child: Container(
                    margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding * 0.8,
                        vertical: horizontalPadding * 0.6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.042,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.grey[900],
                                    letterSpacing: -0.3,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: screenHeight * 0.015,
                            thickness: 1,
                            color: isDark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                          ),
                          Row(
                            children: [
                              _buildChip(
                                Icons.category,
                                category.name,
                                isDark
                                    ? AppColors.primaryDark
                                    : AppColors.primaryLight,
                                isDark,
                                screenWidth,
                              ),
                              if (subcategory != null) ...[
                                SizedBox(width: screenWidth * 0.015),
                                _buildChip(
                                  Icons.description,
                                  subcategory!.name,
                                  isDark
                                      ? AppColors.secondaryDark
                                      : AppColors.secondaryLight,
                                  isDark,
                                  screenWidth,
                                ),
                              ],
                            ],
                          ),
                          Divider(
                            height: screenHeight * 0.01,
                            thickness: 1,
                            color: isDark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: _buildCompactStat(
                                  Icons.inventory_2,
                                  product.quantity.toString(),
                                  isDark
                                      ? Colors.orange[300]!
                                      : Colors.orange[700]!,
                                  isDark,
                                  screenWidth,
                                ),
                              ),
                              VerticalDivider(
                                width: screenWidth * 0.02,
                                thickness: 1,
                                color: isDark
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                              ),
                              Expanded(
                                child: _buildCompactStat(
                                  Icons.attach_money,
                                  '\$${product.price.toStringAsFixed(2)}',
                                  isDark
                                      ? Colors.green[300]!
                                      : Colors.green[700]!,
                                  isDark,
                                  screenWidth,
                                ),
                              ),
                              VerticalDivider(
                                width: screenWidth * 0.02,
                                thickness: 1,
                                color: isDark
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                              ),
                              Expanded(
                                child: _buildCompactStat(
                                  Icons.shopping_cart,
                                  '\$${product.cost.toStringAsFixed(2)}',
                                  isDark ? Colors.red[300]! : Colors.red[700]!,
                                  isDark,
                                  screenWidth,
                                ),
                              ),
                              VerticalDivider(
                                width: screenWidth * 0.02,
                                thickness: 1,
                                color: isDark
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                              ),
                              Expanded(
                                child: _buildCompactStat(
                                  Icons.trending_up,
                                  '${product.profitMargin.toStringAsFixed(1)}%',
                                  isDark
                                      ? Colors.teal[300]!
                                      : Colors.teal[700]!,
                                  isDark,
                                  screenWidth,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: screenHeight * 0.01,
                            thickness: 1,
                            color: isDark
                                ? Colors.grey[700]!
                                : Colors.grey[300]!,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.qr_code,
                                size: screenWidth * 0.035,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              SizedBox(width: screenWidth * 0.015),
                              Expanded(
                                child: Text(
                                  product.barcode,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (product.secondaryBarcode != null) ...[
                                SizedBox(width: screenWidth * 0.015),
                                Expanded(
                                  child: Text(
                                    product.secondaryBarcode!,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.grey[300]
                                          : Colors.grey[700],
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (color != null || measurement != null) ...[
                            Divider(
                              height: screenHeight * 0.01,
                              thickness: 1,
                              color: isDark
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!,
                            ),
                            Row(
                              children: [
                                if (color != null)
                                  _buildChip(
                                    Icons.palette,
                                    color!.displayLabel,
                                    isDark
                                        ? Colors.pink[300]!
                                        : Colors.pink[700]!,
                                    isDark,
                                    screenWidth,
                                  ),
                                if (measurement != null) ...[
                                  SizedBox(width: screenWidth * 0.015),
                                  _buildChip(
                                    Icons.straighten,
                                    measurement!.name,
                                    isDark
                                        ? Colors.cyan[300]!
                                        : Colors.cyan[700]!,
                                    isDark,
                                    screenWidth,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isSelectionMode)
              Positioned(
                top: screenWidth * 0.02,
                right: screenWidth * 0.02,
                child: Container(
                  width: screenWidth * 0.08,
                  height: screenWidth * 0.08,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
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
  }
}
