import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/category.dart';
import 'package:de_helper/pages/Product/product_page.dart';

class CategoryCard extends StatefulWidget {
  final Category category;
  final int productCount;
  final bool isDark;
  final double screenWidth;
  final double screenHeight;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryCard({
    super.key,
    required this.category,
    required this.productCount,
    required this.isDark,
    required this.screenWidth,
    required this.screenHeight,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    final iconSize = widget.screenWidth * 0.12;
    final iconContainerSize = widget.screenWidth * 0.13;

    return Dismissible(
      key: ValueKey(widget.category.id),
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
              builder: (context) => ProductPage(category: widget.category),
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
                widget.category.icon,
                color: widget.isDark ? Colors.green[300] : Colors.blue[700],
                size: iconSize,
              ),
            ),
            title: Text(
              widget.category.name,
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
          ),
        ),
      ),
    );
  }
}


// ref.listen(categoryProvider, (previous, next) {
    //   if (copied != null &&
    //       next.isLoading == false &&
    //       previous?.isLoading == true) {
    //     // Only show snackbar after a successful deletion
    //     final categoryToShow = copied!;
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Category "${categoryToShow.name}" deleted'),
    //         action: SnackBarAction(
    //           label: 'Undo',
    //           onPressed: () {
    //             ref
    //                 .read(categoryProvider.notifier)
    //                 .addInPlace(categoryToShow, deleteIndex!);
    //             copied = null;
    //           },
    //         ),
    //         duration: const Duration(seconds: 3),
    //       ),
    //     );
    //   }
    // });