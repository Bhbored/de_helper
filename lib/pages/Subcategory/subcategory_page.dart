import 'package:de_helper/test_data/test_categories.dart';
import 'package:de_helper/test_data/test_products.dart';
import 'package:de_helper/test_data/test_subcategories.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/subcategory.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/widgets/stat_card.dart';
import 'package:de_helper/widgets/sort_button.dart';
import 'package:de_helper/pages/Subcategory/widgets/subcategory_card.dart';
import 'package:de_helper/pages/Subcategory/widgets/subcategory_form_bottom_sheet.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Subcategory/widgets/subcategory_empty_state.dart';

class SubcategoryPage extends StatefulWidget {
  const SubcategoryPage({super.key});

  @override
  State<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  String _sortType = 'Products';
  List<SubCategory> _displayedSubcategories = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayedSubcategories = testSubCategories;
    _sortSubcategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _sortSubcategories() {
    final sorted = List<SubCategory>.from(_displayedSubcategories);

    switch (_sortType) {
      case 'Products':
        sorted.sort((a, b) {
          final aCount = testProducts
              .where((p) => p.subCategoryId == a.id)
              .length;
          final bCount = testProducts
              .where((p) => p.subCategoryId == b.id)
              .length;
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
      _displayedSubcategories = sorted;
    });
  }

  void _filterSubcategories(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedSubcategories = testSubCategories;
      } else {
        _displayedSubcategories = testSubCategories
            .where(
              (sub) => sub.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
      _sortSubcategories();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterSubcategories('');
  }

  int _getProductCount(String subcategoryId) {
    return testProducts.where((p) => p.subCategoryId == subcategoryId).length;
  }

  int _getTotalProducts() => testProducts.length;
  int _getTotalCategories() => testCategories.length;
  int _getTotalSubcategories() => testSubCategories.length;

  void _showAddSubcategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SubcategoryFormBottomSheet(),
    ).then((result) {
      if (result != null &&
          result['name'] != null &&
          result['categoryId'] != null) {
        final newSubcategory = SubCategory.create(
          name: result['name'] as String,
          categoryId: result['categoryId'] as String,
        );
        setState(() {
          testSubCategories.add(newSubcategory);
          _displayedSubcategories = testSubCategories;
          _sortSubcategories();
        });
      }
    });
  }

  void _showEditSubcategoryBottomSheet(SubCategory subcategory) {
    final subcategoryToEdit = testSubCategories.firstWhere(
      (s) => s.id == subcategory.id,
      orElse: () => subcategory,
    );

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          SubcategoryFormBottomSheet(subcategory: subcategoryToEdit),
    ).then((result) {
      if (result != null &&
          result['name'] != null &&
          result['categoryId'] != null) {
        final index = testSubCategories.indexWhere(
          (s) => s.id == subcategory.id,
        );
        if (index != -1) {
          setState(() {
            testSubCategories[index] = SubCategory(
              id: subcategory.id,
              name: result['name'] as String,
              categoryId: result['categoryId'] as String,
            );
            final displayedIndex = _displayedSubcategories.indexWhere(
              (s) => s.id == subcategory.id,
            );
            if (displayedIndex != -1) {
              _displayedSubcategories[displayedIndex] =
                  testSubCategories[index];
            }
            _sortSubcategories();
          });
        }
      }
    });
  }

  void _deleteSubcategory(SubCategory subcategory) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final screenWidth = MediaQuery.of(context).size.width;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          title: Text(
            'Delete Subcategory',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              color: isDark ? Colors.white : Colors.grey[900],
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${subcategory.name}"?',
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
                  testSubCategories.removeWhere((s) => s.id == subcategory.id);
                  _displayedSubcategories.removeWhere(
                    (s) => s.id == subcategory.id,
                  );
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
      title: 'Subcategories',
      onAction: _showAddSubcategoryBottomSheet,
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
                            onChanged: _filterSubcategories,
                            decoration: InputDecoration(
                              hintText: 'Search Subcategories...',
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
                              _sortSubcategories();
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
                              _sortSubcategories();
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
                              _sortSubcategories();
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
          _displayedSubcategories.isEmpty
              ? SliverFillRemaining(
                  child: SubcategoryEmptyState(
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
                        final subcategory = _displayedSubcategories[index];
                        final productCount = _getProductCount(subcategory.id);

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: screenHeight * 0.015,
                          ),
                          child: SubcategoryCard(
                            subcategory: subcategory,
                            productCount: productCount,
                            isDark: isDark,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            onEdit: () =>
                                _showEditSubcategoryBottomSheet(subcategory),
                            onDelete: () => _deleteSubcategory(subcategory),
                          ),
                        );
                      },
                      childCount: _displayedSubcategories.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
