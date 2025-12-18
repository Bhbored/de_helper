import 'package:flutter/material.dart';
import 'package:de_helper/models/subcategory.dart';
import 'package:de_helper/test_data/test_categories.dart';
import 'package:de_helper/pages/Product/product_page.dart';

class SubcategoryCard extends StatelessWidget {
  final SubCategory subcategory;
  final int productCount;
  final bool isDark;
  final double screenWidth;
  final double screenHeight;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const SubcategoryCard({
    super.key,
    required this.subcategory,
    required this.productCount,
    required this.isDark,
    required this.screenWidth,
    required this.screenHeight,
    this.onEdit,
    this.onDelete,
  });

  IconData _getCategoryIcon() {
    final category = testCategories.firstWhere(
      (c) => c.id == subcategory.categoryId,
      orElse: () => testCategories.first,
    );
    return category.icon;
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = screenWidth * 0.12;
    final iconContainerSize = screenWidth * 0.13;
    final categoryIcon = _getCategoryIcon();

    return Dismissible(
      key: Key(subcategory.id),
      direction: DismissDirection.horizontal,
      background: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.green[700] : Colors.blue,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: screenWidth * 0.05),
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: screenWidth * 0.06,
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: screenWidth * 0.05),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: screenWidth * 0.06,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd && onEdit != null) {
          onEdit!();
          return false;
        } else if (direction == DismissDirection.endToStart &&
            onDelete != null) {
          return await _showDeleteConfirmation(
            context,
            subcategory.name,
            isDark,
            screenWidth,
          );
        }
        return false;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart && onDelete != null) {
          onDelete!();
        }
      },
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductPage(subCategory: subcategory),
            ),
          );
        },
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        child: Container(
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
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.01,
            ),
            leading: Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.green[900]!.withOpacity(0.3)
                    : Colors.blue[100],
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
              ),
              child: Icon(
                categoryIcon,
                color: isDark ? Colors.green[300] : Colors.blue[700],
                size: iconSize,
              ),
            ),
            title: Text(
              subcategory.name,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            subtitle: Text(
              '$productCount Products',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    String subcategoryName,
    bool isDark,
    double screenWidth,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          title: Text(
            'Delete Subcategory',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              color: isDark ? Colors.white : Colors.grey[900],
            ),
          ),
          content: Text(
            'Are you sure you want to delete "$subcategoryName"?',
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
}
