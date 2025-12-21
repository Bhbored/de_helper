import 'package:flutter/material.dart';
import 'package:de_helper/models/subcategory.dart';
import 'package:de_helper/providers/category_provider.dart';
import 'package:de_helper/pages/Product/product_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubcategoryCard extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<SubcategoryCard> createState() => _SubcategoryCardState();
}

class _SubcategoryCardState extends ConsumerState<SubcategoryCard> {
  IconData get _categoryIcon {
    final categories = ref.watch(categoryProvider);
    if (categories.value == null || categories.value!.isEmpty) {
      return Icons.category; // Default icon if categories are not loaded
    }
    final category = categories.value!.firstWhere(
      (c) => c.id == widget.subcategory.categoryId,
      orElse: () => categories.value!.first,
    );
    return category.icon;
  }

  String? get _categoryName {
    final categories = ref.watch(categoryProvider);
    if (categories.value == null || categories.value!.isEmpty) {
      return null;
    }
    final category = categories.value!.firstWhere(
      (c) => c.id == widget.subcategory.categoryId,
      orElse: () => categories.value!.first,
    );
    return category.name;
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.screenWidth * 0.12;
    final iconContainerSize = widget.screenWidth * 0.13;
    final categoryIcon = _categoryIcon;

    return Dismissible(
      key: ValueKey(widget.subcategory.id),
      direction: DismissDirection.horizontal,
      background: Container(
        decoration: BoxDecoration(
          color: widget.isDark ? Colors.green[700] : Colors.blue,
          borderRadius: BorderRadius.circular(widget.screenWidth * 0.03),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: widget.screenWidth * 0.05),
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: widget.screenWidth * 0.06,
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(widget.screenWidth * 0.03),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: widget.screenWidth * 0.05),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: widget.screenWidth * 0.06,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          if (widget.onEdit != null) {
            widget.onEdit!();
          }
          return false;
        } else if (direction == DismissDirection.endToStart) {
          if (widget.onDelete != null) {
            widget.onDelete!();
          }
          return false;
        }
        return false;
      },
      onDismissed: (_) {},
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductPage(
                subCategory: widget.subcategory,
                category: null,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(widget.screenWidth * 0.03),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isDark ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(widget.screenWidth * 0.03),
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
              horizontal: widget.screenWidth * 0.04,
              vertical: widget.screenHeight * 0.01,
            ),
            leading: Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                color: widget.isDark
                    ? Colors.green[900]!.withOpacity(0.3)
                    : Colors.blue[100],
                borderRadius: BorderRadius.circular(widget.screenWidth * 0.025),
              ),
              child: Icon(
                categoryIcon,
                color: widget.isDark ? Colors.green[300] : Colors.blue[700],
                size: iconSize,
              ),
            ),
            title: Text(
              widget.subcategory.name,
              style: TextStyle(
                fontSize: widget.screenWidth * 0.04,
                fontWeight: FontWeight.w600,
                color: widget.isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            subtitle: Text(
              '${widget.productCount} Products',
              style: TextStyle(
                fontSize: widget.screenWidth * 0.035,
                color: widget.isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            trailing: _categoryName != null
                ? ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: widget.screenWidth * 0.3,
                    ),
                    child: Text(
                      _categoryName!.toUpperCase(),
                      style: TextStyle(
                        fontSize: widget.screenWidth * 0.038,
                        fontWeight: FontWeight.bold,
                        color: widget.isDark
                            ? Colors.green[300]
                            : Colors.blue[700],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
