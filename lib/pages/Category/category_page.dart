import 'package:de_helper/test_data/test_categories.dart';
import 'package:de_helper/test_data/test_products.dart';
import 'package:de_helper/test_data/test_subcategories.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/category.dart';

import 'package:de_helper/utility/theme_selector.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String _sortType = 'Products';
  List<Category> _displayedCategories = [];

  @override
  void initState() {
    super.initState();
    _displayedCategories = testCategories;
    _sortCategories();
  }

  void _sortCategories() {
    final sorted = List<Category>.from(_displayedCategories);

    switch (_sortType) {
      case 'Products':
        sorted.sort((a, b) {
          final aCount = testProducts.where((p) => p.categoryId == a.id).length;
          final bCount = testProducts.where((p) => p.categoryId == b.id).length;
          return bCount.compareTo(aCount);
        });
        break;
      case 'Alphabetical':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Date Added':
        break;
    }

    setState(() {
      _displayedCategories = sorted;
    });
  }

  void _filterCategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedCategories = testCategories;
      } else {
        _displayedCategories = testCategories
            .where(
              (cat) => cat.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
      _sortCategories();
    });
  }

  int _getProductCount(String categoryId) {
    return testProducts.where((p) => p.categoryId == categoryId).length;
  }

  int _getTotalProducts() => testProducts.length;
  int _getTotalCategories() => testCategories.length;
  int _getTotalSubcategories() => testSubCategories.length;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final viewInsets = mediaQuery.viewInsets;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark
        ? ThemeSelector.darkGradient
        : ThemeSelector.lightGradient;

    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final expandedHeight = screenHeight * 0.25;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: expandedHeight,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(gradient: gradient),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                screenHeight * 0.08,
                horizontalPadding,
                verticalPadding * 1.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OVERALL STATISTICS',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatCard(
                        value: _getTotalProducts().toString(),
                        label: 'Total Products',
                        isDark: isDark,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                      _StatCard(
                        value: _getTotalCategories().toString(),
                        label: 'Total Categories',
                        isDark: isDark,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                      _StatCard(
                        value: _getTotalSubcategories().toString(),
                        label: 'Total Subcategories',
                        isDark: isDark,
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
        SliverToBoxAdapter(
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(screenWidth * 0.06),
              topRight: Radius.circular(screenWidth * 0.06),
            ),
            child: Container(
              color: isDark ? Colors.grey[900] : Colors.white,
              padding: EdgeInsets.all(horizontalPadding),
              child: Column(
                children: [
                  Container(
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
                    child: TextField(
                      onChanged: _filterCategories,
                      decoration: InputDecoration(
                        hintText: 'Search Categories...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: screenHeight * 0.02,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _SortButton(
                          label: 'Sort: Products',
                          isActive: _sortType == 'Products',
                          onTap: () {
                            setState(() => _sortType = 'Products');
                            _sortCategories();
                          },
                          isDark: isDark,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        _SortButton(
                          label: 'Sort: Alphabetical',
                          isActive: _sortType == 'Alphabetical',
                          onTap: () {
                            setState(() => _sortType = 'Alphabetical');
                            _sortCategories();
                          },
                          isDark: isDark,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        _SortButton(
                          label: 'Date Added',
                          isActive: _sortType == 'Date Added',
                          onTap: () {
                            setState(() => _sortType = 'Date Added');
                            _sortCategories();
                          },
                          isDark: isDark,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: viewInsets.bottom > 0 ? viewInsets.bottom : 0,
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = _displayedCategories[index];
                final productCount = _getProductCount(category.id);

                return Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                  child: _CategoryCard(
                    category: category,
                    productCount: productCount,
                    isDark: isDark,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                );
              },
              childCount: _displayedCategories.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;
  final double screenWidth;
  final double screenHeight;

  const _StatCard({
    required this.value,
    required this.label,
    required this.isDark,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.green[300] : Colors.blue[700],
          ),
        ),
        SizedBox(height: screenHeight * 0.005),
        Text(
          label,
          style: TextStyle(
            fontSize: screenWidth * 0.03,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _SortButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final bool isDark;
  final double screenWidth;
  final double screenHeight;

  const _SortButton({
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
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
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

class _CategoryCard extends StatelessWidget {
  final Category category;
  final int productCount;
  final bool isDark;
  final double screenWidth;
  final double screenHeight;

  const _CategoryCard({
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
