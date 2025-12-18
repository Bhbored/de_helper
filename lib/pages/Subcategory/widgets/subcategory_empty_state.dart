import 'package:flutter/material.dart';

class SubcategoryEmptyState extends StatelessWidget {
  final bool isDark;
  final double screenWidth;
  final double screenHeight;

  const SubcategoryEmptyState({
    super.key,
    required this.isDark,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_off,
              size: screenWidth * 0.3,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'No Subcategories Found',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Try adjusting your search terms',
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
