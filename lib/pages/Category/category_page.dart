import 'dart:async';
import 'package:de_helper/providers/category_provider.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:de_helper/providers/subcategory_provider.dart';
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
  final ScrollController _scrollController = ScrollController();
  Category? copied;
  int? deleteIndex;
  String sortType = 'Products';
  bool _isSelectionMode = false;
  final Set<String> _selectedCategoryIds = {};
  bool _showScrollButton = false;
  bool _isAtBottom = false;
  Timer? _scrollHideTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollHideTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    final isAtBottom = position.pixels >= position.maxScrollExtent - 50;
    final isAtTop = position.pixels <= 50;
    
    setState(() {
      _isAtBottom = isAtBottom;
      _showScrollButton = !isAtTop; // Show button when not at top (including when at bottom)
    });

    // Hide button while scrolling, show after scrolling stops
    _scrollHideTimer?.cancel();
    _scrollHideTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        final currentPosition = _scrollController.position;
        final currentIsAtBottom = currentPosition.pixels >= currentPosition.maxScrollExtent - 50;
        final currentIsAtTop = currentPosition.pixels <= 50;
        setState(() {
          _isAtBottom = currentIsAtBottom;
          _showScrollButton = !currentIsAtTop; // Show button when not at top
        });
      }
    });
  }

  void _scrollToPosition() {
    if (_isAtBottom) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
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
                if (mounted) {
                  ref
                      .read(categoryProvider.notifier)
                      .addInPlace(categoryToShow, deleteIndex!);
                }
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
    final subcategories = ref.watch(subcategoryProvider);
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

    int getTotalProducts() => products.value?.length ?? 0;
    int getTotalCategories() => categories.value?.length ?? 0;
    int getTotalSubcategories() => subcategories.value?.length ?? 0;

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
      final productCount = getProductCount(category.id);

      if (productCount > 0) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final screenWidth = MediaQuery.of(context).size.width;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: isDark ? Colors.grey[800] : Colors.white,
              title: Text(
                'Cannot Delete Category',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: isDark ? Colors.white : Colors.grey[900],
                ),
              ),
              content: Text(
                'Category "${category.name}" cannot be deleted because it has $productCount product${productCount == 1 ? '' : 's'} associated with it.\n\nPlease remove or reassign all products before deleting this category.',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return;
      }

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

    void handleDeleteSelected(List<Category> selectedCategories) {
      final categoriesWithProducts = selectedCategories
          .where((cat) => getProductCount(cat.id) > 0)
          .toList();
      final categoriesToDelete = selectedCategories
          .where((cat) => getProductCount(cat.id) == 0)
          .toList();

      if (categoriesWithProducts.isNotEmpty) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final screenWidth = MediaQuery.of(context).size.width;
        final categoryNames = categoriesWithProducts
            .map(
              (cat) =>
                  '${cat.name} (${getProductCount(cat.id)} product${getProductCount(cat.id) == 1 ? '' : 's'})',
            )
            .join('\n');

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: isDark ? Colors.grey[800] : Colors.white,
              title: Text(
                'Cannot Delete Categories',
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: isDark ? Colors.white : Colors.grey[900],
                ),
              ),
              content: SingleChildScrollView(
                child: Text(
                  'The following categories cannot be deleted because they have products associated with them:\n\n$categoryNames\n\nPlease remove or reassign all products before deleting these categories.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            );
          },
        );

        if (categoriesToDelete.isNotEmpty) {
          setState(() {
            for (final cat in categoriesWithProducts) {
              _selectedCategoryIds.remove(cat.id);
            }
          });

          for (final category in categoriesToDelete) {
            ref.read(categoryProvider.notifier).deleteCategory(category.id);
          }

          if (_selectedCategoryIds.isEmpty) {
            setState(() {
              _isSelectionMode = false;
            });
          }
        }
        return;
      }

      ref.read(categoryProvider.notifier).deleteSelection(selectedCategories);

      setState(() {
        _selectedCategoryIds.clear();
        _isSelectionMode = false;
      });
    }

    void toggleSelection(String categoryId) {
      setState(() {
        if (_selectedCategoryIds.contains(categoryId)) {
          _selectedCategoryIds.remove(categoryId);
          if (_selectedCategoryIds.isEmpty) {
            _isSelectionMode = false;
          }
        } else {
          _selectedCategoryIds.add(categoryId);
          if (!_isSelectionMode) {
            _isSelectionMode = true;
          }
        }
      });
    }

    void exitSelectionMode() {
      setState(() {
        _isSelectionMode = false;
        _selectedCategoryIds.clear();
      });
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
      titleIcon: Icons.folder,
      onAction: _isSelectionMode ? null : showAddCategoryBottomSheet,

      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(categoryProvider);
          ref.read(categoryProvider.future);
          exitSelectionMode();
        },
        child: categories.when(
          data: (x) {
            return Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
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
                if (_isSelectionMode && _selectedCategoryIds.isNotEmpty)
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SelectionHeaderDelegate(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: screenHeight * 0.015,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[900] : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: exitSelectionMode,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                            Text(
                              '${_selectedCategoryIds.length} selected',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : Colors.grey[900],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final selectedCategories = x
                                    .where(
                                      (cat) => _selectedCategoryIds
                                          .contains(cat.id),
                                    )
                                    .toList();
                                handleDeleteSelected(selectedCategories);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.06,
                                  vertical: screenHeight * 0.015,
                                ),
                              ),
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      height: screenHeight * 0.08,
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
                              final isSelected = _selectedCategoryIds.contains(
                                category.id,
                              );

                              return GestureDetector(
                                onLongPress: () {
                                  if (!_isSelectionMode) {
                                    setState(() {
                                      _isSelectionMode = true;
                                      _selectedCategoryIds.add(category.id);
                                    });
                                  }
                                },
                                onTap: _isSelectionMode
                                    ? () {
                                        toggleSelection(category.id);
                                      }
                                    : null,
                                behavior: _isSelectionMode
                                    ? HitTestBehavior.opaque
                                    : HitTestBehavior.translucent,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: screenHeight * 0.015,
                                  ),
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: isSelected ? 0.5 : 1.0,
                                        child: CategoryCard(
                                          category: category,
                                          productCount: productCount,
                                          isDark: isDark,
                                          screenWidth: screenWidth,
                                          screenHeight: screenHeight,
                                          onEdit: _isSelectionMode
                                              ? null
                                              : () =>
                                                    showEditCategoryBottomSheet(
                                                      category,
                                                    ),
                                          onDelete: _isSelectionMode
                                              ? null
                                              : () => deleteCategory(category),
                                        ),
                                      ),
                                      if (_isSelectionMode)
                                        Positioned(
                                          top: screenWidth * 0.02,
                                          right: screenWidth * 0.02,
                                          child: Container(
                                            width: screenWidth * 0.08,
                                            height: screenWidth * 0.08,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.blue
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.grey,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    screenWidth * 0.02,
                                                  ),
                                            ),
                                            child: isSelected
                                                ? Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: screenWidth * 0.05,
                                                  )
                                                : null,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: x.length,
                          ),
                        ),
                      ),
                  ],
                ),
                if (_showScrollButton && !_isSelectionMode)
                  Positioned(
                    left: screenWidth * 0.05,
                    bottom: screenHeight * 0.02,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: _scrollToPosition,
                      backgroundColor: isDark ? Colors.green[700] : Colors.blue,
                      child: Icon(
                        _isAtBottom ? Icons.arrow_upward : Icons.arrow_downward,
                        color: Colors.white,
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

class _SelectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SelectionHeaderDelegate({
    required this.child,
    required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_SelectionHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
