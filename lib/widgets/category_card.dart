import 'package:flutter/material.dart';
import 'package:de_helper/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final int productCount;
  final bool isDark;
  final double screenWidth;
  final double screenHeight;

  const CategoryCard({
    super.key,
    required this.category,
    required this.productCount,
    required this.isDark,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = screenWidth * 0.12;
    final iconContainerSize = screenWidth * 0.13;

    return Container(
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
            category.icon,
            color: isDark ? Colors.green[300] : Colors.blue[700],
            size: iconSize,
          ),
        ),
        title: Text(
          category.name,
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
    );
  }
}

