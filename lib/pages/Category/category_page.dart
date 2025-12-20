import 'package:de_helper/providers/category_provider.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:de_helper/test_data/test_subcategories.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/category.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/widgets/stat_card.dart';
import 'package:de_helper/widgets/sort_button.dart';
import 'package:de_helper/pages/Category/widgets/category_card.dart';
import 'package:de_helper/pages/Category/widgets/category_form_bottom_sheet.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Category/widgets/category_empty_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryPage extends ConsumerStatefulWidget {
  const CategoryPage({super.key});

  @override
  ConsumerState<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends ConsumerState<CategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  Category? copied;
  int? deleteIndex;
  String sortType = 'Products';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(categoryProvider, (previous, next) {
      if (copied != null && next.value!.length < previous!.value!.length) {
        final categoryToShow = copied!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Category "${categoryToShow.name}" deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                ref
                    .read(categoryProvider.notifier)
                    .addInPlace(categoryToShow, deleteIndex!);
                copied = null;
              },
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
    final categories = ref.watch(categoryProvider);
    final products = ref.watch(prodcutProvider);
    void sortCategories() {
      final sorted = categories.value!;
      switch (sortType) {
        case 'Products':
          sorted.sort((a, b) {
            final aCount = products.value!
                .where((p) => p.categoryId == a.id)
                .length;
            final bCount = products.value!
                .where((p) => p.categoryId == b.id)
                .length;
            return bCount.compareTo(aCount);
          });
          break;
        case 'Alphabetical':
          sorted.sort((a, b) => a.name.compareTo(b.name));
          break;
      }
      ref.read(categoryProvider.notifier).sortCategories(sorted);
    }

    void filterCategories(String query) {
      if (query.isEmpty) {
        ref.read(categoryProvider.notifier).refreshCategories();
      } else {
        ref.read(categoryProvider.notifier).filterByName(query);
      }
    }

    void clearSearch() {
      _searchController.clear();
      filterCategories('');
    }

    int getProductCount(String categoryId) {
      return products.value!.where((p) => p.categoryId == categoryId).length;
    }

    int getTotalProducts() => products.value!.length;
    int getTotalCategories() => categories.value!.length;
    int getTotalSubcategories() => testSubCategories.length;

    void showAddCategoryBottomSheet() {
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const CategoryFormBottomSheet(),
      ).then((result) {
        if (result != null &&
            result['name'] != null &&
            result['icon'] != null) {
          final newCategory = Category.create(
            name: result['name'] as String,
            icon: result['icon'] as IconData,
          );
          ref.read(categoryProvider.notifier).addCategory(newCategory);
          setState(() {
            sortCategories();
          });
        }
      });
    }

    void showEditCategoryBottomSheet(Category category) {
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CategoryFormBottomSheet(category: category),
      ).then((result) {
        if (result != null &&
            result['name'] != null &&
            result['icon'] != null) {
          final updatedCategory = category.copyWith(
            name: result['name'] as String,
            icon: result['icon'] as IconData,
          );
          ref.read(categoryProvider.notifier).updateCategory(updatedCategory);
          setState(() {
            sortCategories();
          });
        }
      });
    }

    void deleteCategory(Category category) {
      final id = category.id;
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
                  copied = category;
                  deleteIndex = ref
                      .read(categoryProvider.notifier)
                      .getIndex(copied!);
                  ref.read(categoryProvider.notifier).deleteCategory(id);
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
      onAction: showAddCategoryBottomSheet,

      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(categoryProvider);
          ref.read(categoryProvider.future);
        },
        child: categories.when(
          data: (x) {
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
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              StatCard(
                                value: getTotalProducts().toString(),
                                label: 'Total Products',
                                isDark: isDark,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                              ),
                              StatCard(
                                value: getTotalCategories().toString(),
                                label: 'Total Categories',
                                isDark: isDark,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                              ),
                              StatCard(
                                value: getTotalSubcategories().toString(),
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
                              valueListenable: _searchController,
                              builder: (context, value, child) {
                                return TextField(
                                  controller: _searchController,
                                  onChanged: filterCategories,
                                  decoration: InputDecoration(
                                    hintText: 'Search Categories...',
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
                                            onPressed: clearSearch,
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
                          SizedBox(width: screenWidth * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            spacing: 10,
                            children: [
                              SortButton(
                                label: 'None',
                                isActive: sortType == 'Products',
                                onTap: () {
                                  setState(() => sortType = 'Products');
                                  sortCategories();
                                },
                                isDark: isDark,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                              ),
                              SortButton(
                                label: 'Sort: Alphabetical',
                                isActive: sortType == 'Alphabetical',
                                onTap: () {
                                  setState(() => sortType = 'Alphabetical');
                                  sortCategories();
                                },
                                isDark: isDark,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                              ),
                            ],
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          SizedBox(
                            height: viewInsets.bottom > 0
                                ? viewInsets.bottom
                                : 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                x.isEmpty
                    ? SliverFillRemaining(
                        child: CategoryEmptyState(
                          isDark: isDark,
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        ),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final category = x[index];
                              final productCount = getProductCount(category.id);

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
                                      showEditCategoryBottomSheet(category),
                                  onDelete: () => deleteCategory(category),
                                ),
                              );
                            },
                            childCount: x.length,
                          ),
                        ),
                      ),
              ],
            );
          },
          error: (e, s) => Center(
            child: Text(
              e.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          loading: () {
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
