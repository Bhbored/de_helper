import 'package:flutter/material.dart';

class ProductEmptyState extends StatelessWidget {
  final bool isDark;
  final double screenWidth;
  final double screenHeight;

  const ProductEmptyState({
    super.key,
    required this.isDark,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
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
}
