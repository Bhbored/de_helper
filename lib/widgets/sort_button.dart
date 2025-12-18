import 'package:flutter/material.dart';

class SortButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;
  final double screenWidth;
  final double screenHeight;

  const SortButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.isDark,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.01,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? Colors.green[700] : Colors.blue)
              : Colors.transparent,
          border: Border.all(
            color: isActive
                ? (isDark ? Colors.green[300]! : Colors.blue)
                : (isDark ? Colors.green[700]! : Colors.blue[300]!),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive
                ? Colors.white
                : (isDark ? Colors.green[300] : Colors.blue),
          ),
        ),
      ),
    );
  }
}
