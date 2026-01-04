import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/utility/barcode_scanner.dart';

class AllProductsSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onChanged;
  final VoidCallback onClear;
  final Future<void> Function() onScanBarcode;
  final double horizontalPadding;
  final double screenWidth;
  final double screenHeight;
  final bool isDark;

  const AllProductsSearchBar({
    super.key,
    required this.searchController,
    required this.onChanged,
    required this.onClear,
    required this.onScanBarcode,
    required this.horizontalPadding,
    required this.screenWidth,
    required this.screenHeight,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(screenWidth * 0.06),
          topRight: Radius.circular(screenWidth * 0.06),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppGradients.glassDark
                  : AppGradients.glass,
            ),
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(
                      screenWidth * 0.03,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: searchController,
                    builder: (context, value, child) {
                      return TextField(
                        controller: searchController,
                        onChanged: onChanged,
                        decoration: InputDecoration(
                          hintText: 'Search Products...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          suffixIcon: value.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.grey[400],
                                  ),
                                  onPressed: onClear,
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: screenHeight * 0.02,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.025,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.qr_code_scanner,
                            color: isDark
                                ? Colors.green[300]
                                : Colors.blue[700],
                          ),
                          onPressed: onScanBarcode,
                          tooltip: 'Scan Barcode',
                          padding: EdgeInsets.all(screenWidth * 0.03),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom > 0
                      ? MediaQuery.of(context).viewInsets.bottom
                      : 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

