import 'package:de_helper/providers/category_provider.dart';
import 'package:de_helper/providers/helpers_providers.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:de_helper/providers/subcategory_provider.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/subcategory.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/widgets/stat_card.dart';
import 'package:de_helper/widgets/sort_button.dart';
import 'package:de_helper/pages/Subcategory/widgets/subcategory_card.dart';
import 'package:de_helper/pages/Subcategory/widgets/subcategory_form_bottom_sheet.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Subcategory/widgets/subcategory_empty_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubcategoryPage extends ConsumerStatefulWidget {
  const SubcategoryPage({super.key});

  @override
  ConsumerState<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends ConsumerState<SubcategoryPage> {
  String _sortType = 'Products';
  SubCategory? copied;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayedSubcategories = ref.watch(subcategoryProvider);
    final categories = ref.watch(categoryProvider);
    final products = ref.watch(prodcutProvider);

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

    void sortSubcategories() {
      final sorted = displayedSubcategories.value;
      switch (_sortType) {
        case 'Products':
          sorted!.sort((a, b) {
            final aCount = products.value!
                .where((p) => p.subCategoryId == a.id)
                .length;
            final bCount = products.value!
                .where((p) => p.subCategoryId == b.id)
                .length;
            return bCount.compareTo(aCount);
          });
          break;
        case 'Alphabetical':
          sorted!.sort((a, b) => a.name.compareTo(b.name));
          break;
      }

      ref.read(subcategoryProvider.notifier).sortCategories(sorted!);
    }

    void filterSubcategories(String query) {
      if (query.isEmpty) {
        ref.watch(subcategoryProvider.notifier).refreshCategories();
      } else {
        ref.watch(subcategoryProvider.notifier).filterByName(query);
      }
    }

    void clearSearch() {
      _searchController.clear();
      filterSubcategories('');
    }

    int getProductCount(String subcategoryId) {
      var products = ref.watch(productsBySubProvider(subcategoryId));
      return products.value?.length ?? 0;
    }

    int getTotalProducts() => products.value!.length;

    int getTotalCategories() => categories.value!.length;

    int getTotalSubcategories() => displayedSubcategories.value!.length;

    void showAddSubcategoryBottomSheet() {
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
          ref.read(subcategoryProvider.notifier).addCategory(newSubcategory);
        }
      });
    }

    void showEditSubcategoryBottomSheet(SubCategory subcategory) {
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) =>
            SubcategoryFormBottomSheet(subcategory: subcategory),
      ).then((result) {
        if (result != null &&
            result['name'] != null &&
            result['categoryId'] != null) {
          var newsub = subcategory.copyWith(
            name: result['name'] as String,
            categoryId: result['categoryId'] as String,
          );
          ref.read(subcategoryProvider.notifier).updateCategory(newsub);
        }
      });
    }

    void deleteSubcategory(SubCategory subcategory) {
      final id = subcategory.id;
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
              '⚠️ Are you sure you want to delete "${subcategory.name}"?',
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
                  copied = subcategory;
                  ref.read(subcategoryProvider.notifier).deleteCategory(id);
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

    return PageScaffold(
      title: 'Subcategories',
      onAction: showAddSubcategoryBottomSheet,
      body: displayedSubcategories.when(
        skipLoadingOnRefresh: false,
        skipLoadingOnReload: false,

        data: (data) {
          bool otherProvidersLoading =
              categories.isLoading || products.isLoading;
          if (otherProvidersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(subcategoryProvider);
              ref.read(subcategoryProvider.future);
            },
            child: CustomScrollView(
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
                                  onChanged: filterSubcategories,
                                  decoration: InputDecoration(
                                    hintText: 'Search Subcategories...',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SortButton(
                                label: 'None',
                                isActive: _sortType == 'Products',
                                onTap: () {
                                  setState(() => _sortType = 'Products');
                                  sortSubcategories();
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
                                  setState(
                                    () => _sortType = 'Alphabetical',
                                  );
                                  sortSubcategories();
                                },
                                isDark: isDark,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                              ),
                              SizedBox(width: screenWidth * 0.02),
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
                displayedSubcategories.value!.isEmpty
                    ? SliverFillRemaining(
                        child: SubcategoryEmptyState(
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
                              final subcategory =
                                  displayedSubcategories.value![index];
                              final productCount = getProductCount(
                                subcategory.id,
                              );

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
                                  onEdit: () => showEditSubcategoryBottomSheet(
                                    subcategory,
                                  ),
                                  onDelete: () =>
                                      deleteSubcategory(subcategory),
                                ),
                              );
                            },
                            childCount: displayedSubcategories.value!.length,
                          ),
                        ),
                      ),
              ],
            ),
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
    );
  }
}
