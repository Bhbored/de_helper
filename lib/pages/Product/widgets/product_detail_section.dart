import 'package:flutter/material.dart';

class ProductDetailSection extends StatelessWidget {
  final bool isDark;
  final double screenWidth;
  final double screenHeight;
  final String title;
  final List<Widget> children;

  const ProductDetailSection({
    super.key,
    required this.isDark,
    required this.screenWidth,
    required this.screenHeight,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
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
}
