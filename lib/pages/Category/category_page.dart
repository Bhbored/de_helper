import 'package:de_helper/test_data/test_categories.dart';
import 'package:de_helper/test_data/test_products.dart';
import 'package:de_helper/test_data/test_subcategories.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/category.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/widgets/stat_card.dart';
import 'package:de_helper/widgets/sort_button.dart';
import 'package:de_helper/widgets/category_card.dart';
import 'package:de_helper/widgets/category_form_bottom_sheet.dart';
import 'package:de_helper/widgets/page_scaffold.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String _sortType = 'Products';
  List<Category> _displayedCategories = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayedCategories = testCategories;
    _sortCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  void _clearSearch() {
    _searchController.clear();
    _filterCategories('');
  }

  int _getProductCount(String categoryId) {
    return testProducts.where((p) => p.categoryId == categoryId).length;
  }

  int _getTotalProducts() => testProducts.length;
  int _getTotalCategories() => testCategories.length;
  int _getTotalSubcategories() => testSubCategories.length;

  void _showAddCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CategoryFormBottomSheet(),
    ).then((result) {
      if (result != null && result['name'] != null && result['icon'] != null) {
        final newCategory = Category.create(
          name: result['name'] as String,
          icon: result['icon'] as IconData,
        );
        setState(() {
          testCategories.add(newCategory);
          _displayedCategories = testCategories;
          _sortCategories();
        });
      }
    });
  }

  void _showEditCategoryBottomSheet(Category category) {
    final categoryToEdit = testCategories.firstWhere(
      (c) => c.id == category.id,
      orElse: () => category,
    );

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategoryFormBottomSheet(category: categoryToEdit),
    ).then((result) {
      if (result != null && result['name'] != null && result['icon'] != null) {
        final index = testCategories.indexWhere((c) => c.id == category.id);
        if (index != -1) {
          setState(() {
            testCategories[index] = Category(
              id: category.id,
              name: result['name'] as String,
              icon: result['icon'] as IconData,
            );
            final displayedIndex = _displayedCategories.indexWhere(
              (c) => c.id == category.id,
            );
            if (displayedIndex != -1) {
              _displayedCategories[displayedIndex] = testCategories[index];
            }
            _sortCategories();
          });
        }
      }
    });
  }

  void _deleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final screenWidth = MediaQuery.of(context).size.width;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          title: Text(
            'Delete Category',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              color: isDark ? Colors.white : Colors.grey[900],
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${category.name}"?',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  testCategories.removeWhere((c) => c.id == category.id);
                  _displayedCategories.removeWhere((c) => c.id == category.id);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

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

    return PageScaffold(
      title: 'Categories',
      onAction: _showAddCategoryBottomSheet,
      body: CustomScrollView(
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
                        StatCard(
                          value: _getTotalProducts().toString(),
                          label: 'Total Products',
                          isDark: isDark,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        StatCard(
                          value: _getTotalCategories().toString(),
                          label: 'Total Categories',
                          isDark: isDark,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                        StatCard(
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
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, child) {
                          return TextField(
                            controller: _searchController,
                            onChanged: _filterCategories,
                            decoration: InputDecoration(
                              hintText: 'Search Categories...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
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
                                      onPressed: _clearSearch,
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
                    SizedBox(height: screenHeight * 0.02),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SortButton(
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
                          SortButton(
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
                          SortButton(
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
          _displayedCategories.isEmpty
              ? SliverFillRemaining(
                  child: _EmptyStateView(
                    isDark: isDark,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = _displayedCategories[index];
                        final productCount = _getProductCount(category.id);

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: screenHeight * 0.015,
                          ),
                          child: CategoryCard(
                            category: category,
                            productCount: productCount,
                            isDark: isDark,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            onEdit: () =>
                                _showEditCategoryBottomSheet(category),
                            onDelete: () => _deleteCategory(category),
                          ),
                        );
                      },
                      childCount: _displayedCategories.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _EmptyStateView extends StatelessWidget {
  final bool isDark;
  final double screenWidth;
  final double screenHeight;

  const _EmptyStateView({
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
              'No Categories Found',
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
