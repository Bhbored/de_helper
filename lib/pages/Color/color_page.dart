import 'dart:async';
import 'package:de_helper/providers/color_provider.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/color_preset.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/widgets/stat_card.dart';
import 'package:de_helper/pages/Color/widgets/color_form_bottom_sheet.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Color/widgets/color_empty_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorPage extends ConsumerStatefulWidget {
  const ColorPage({super.key});

  @override
  ConsumerState<ColorPage> createState() => _ColorPageState();
}

class _ColorPageState extends ConsumerState<ColorPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  ColorPreset? copied;
  bool _isSelectionMode = false;
  final Set<String> _selectedColorIds = {};
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
      _showScrollButton = !isAtTop;
    });

    _scrollHideTimer?.cancel();
    _scrollHideTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        final currentPosition = _scrollController.position;
        final currentIsAtBottom =
            currentPosition.pixels >= currentPosition.maxScrollExtent - 50;
        final currentIsAtTop = currentPosition.pixels <= 50;
        setState(() {
          _isAtBottom = currentIsAtBottom;
          _showScrollButton = !currentIsAtTop;
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
    final displayedColors = ref.watch(colorProvider);
    final notifier = ref.read(colorProvider.notifier);
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark
        ? ThemeSelector.darkGradient
        : ThemeSelector.lightGradient;

    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;
    final expandedHeight = screenHeight * 0.22;

    void sortColors() {
      final currentList = ref.read(colorProvider).value;
      if (currentList != null) {
        final sorted = [...currentList];
        sorted.sort((a, b) => a.displayLabel.compareTo(b.displayLabel));
        ref.read(colorProvider.notifier).sortCategories(sorted);
      }
    }

    void filterColors(String query) {
      if (query.isEmpty) {
        ref.read(colorProvider.notifier).refreshProduct();
      } else {
        ref.read(colorProvider.notifier).filterByName(query);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        sortColors();
      });
    }

    void clearSearch() {
      _searchController.clear();
      filterColors('');
    }

    int getTotalColors() => displayedColors.value!.length;

    Color hexToColor(String? hex) {
      if (hex == null) return Colors.grey;
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      }
      return Colors.grey;
    }

    void showAddColorBottomSheet() {
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const ColorFormBottomSheet(),
      ).then((result) {
        if (result != null) {
          ColorPreset newColor;
          if (result['hexCode'] != null) {
            newColor = ColorPreset.create(
              hexCode: result['hexCode'] as String,
            );
            notifier.addProduct(newColor);
          } else if (result['name'] != null) {
            newColor = ColorPreset.create(
              name: result['name'] as String,
            );
            notifier.addProduct(newColor);
          } else {
            return;
          }
        }
      });
    }

    void showEditColorBottomSheet(ColorPreset colorPreset) {
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ColorFormBottomSheet(
          key: ValueKey(colorPreset.id),
          colorPreset: colorPreset,
        ),
      ).then((result) {
        if (result != null) {
          if (result['hexCode'] != null) {
            colorPreset = colorPreset.copyWith(
              hexCode: result['hexCode'] as String,
            );
            notifier.updateProduct(colorPreset);
          } else if (result['name'] != null) {
            colorPreset = colorPreset.copyWith(
              name: result['name'] as String,
            );
            notifier.updateProduct(colorPreset);
          }
        }
      });
    }

    void deleteColor(ColorPreset colorPreset) {
      final id = colorPreset.id;
      showDialog(
        context: context,
        builder: (context) {
          final mediaQuery = MediaQuery.of(context);
          final screenWidth = mediaQuery.size.width;
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey[800] : Colors.white,
            title: Text(
              'Delete Color',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            content: Text(
              'Are you sure you want to delete "${colorPreset.displayLabel}"?',
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
                    fontSize: screenWidth * 0.04,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  copied = colorPreset;
                  notifier.deleteProduct(id);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    void _handleDeleteSelected(List<ColorPreset> selectedColors) {
      // This method will be called with the selected colors
      // User will implement the actual deletion logic
      // For now, just clear selection
      setState(() {
        _selectedColorIds.clear();
        _isSelectionMode = false;
      });
    }

    void _toggleSelection(String colorId) {
      setState(() {
        if (_selectedColorIds.contains(colorId)) {
          _selectedColorIds.remove(colorId);
          if (_selectedColorIds.isEmpty) {
            _isSelectionMode = false;
          }
        } else {
          _selectedColorIds.add(colorId);
          if (!_isSelectionMode) {
            _isSelectionMode = true;
          }
        }
      });
    }

    void _exitSelectionMode() {
      setState(() {
        _isSelectionMode = false;
        _selectedColorIds.clear();
      });
    }

    return PageScaffold(
      title: 'Colors',
      titleIcon: Icons.palette,
      onAction: _isSelectionMode ? null : showAddColorBottomSheet,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(colorProvider);
          ref.read(colorProvider.future);
        },
        child: displayedColors.when(
          data: (data) => Stack(
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
                          screenHeight * 0.06,
                          horizontalPadding,
                          verticalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'CURRENT COLORS',
                              style: TextStyle(
                                fontSize: screenWidth * 0.032,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            StatCard(
                              value: getTotalColors().toString(),
                              label: 'Total Colors',
                              isDark: isDark,
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
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
                                    onChanged: filterColors,
                                    decoration: InputDecoration(
                                      hintText: 'Search colors...',
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
                            SizedBox(height: verticalPadding),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_isSelectionMode && _selectedColorIds.isNotEmpty)
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
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: _exitSelectionMode,
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
                                '${_selectedColorIds.length} selected',
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
                                  final selectedColors = displayedColors.value!
                                      .where(
                                        (color) => _selectedColorIds.contains(
                                          color.id,
                                        ),
                                      )
                                      .toList();
                                  _handleDeleteSelected(selectedColors);
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
                  displayedColors.value!.isEmpty
                      ? SliverFillRemaining(
                          child: ColorEmptyState(
                            isDark: isDark,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        )
                      : SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: screenWidth * 0.03,
                                  mainAxisSpacing: screenWidth * 0.03,
                                  childAspectRatio: 1.5,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final colorPreset =
                                    displayedColors.value![index];
                                final color = hexToColor(colorPreset.hexCode);
                                final isSelected = _selectedColorIds.contains(
                                  colorPreset.id,
                                );
                                return GestureDetector(
                                  onLongPress: () {
                                    if (!_isSelectionMode) {
                                      setState(() {
                                        _isSelectionMode = true;
                                        _selectedColorIds.add(colorPreset.id);
                                      });
                                    }
                                  },
                                  onTap: _isSelectionMode
                                      ? () {
                                          _toggleSelection(colorPreset.id);
                                        }
                                      : null,
                                  behavior: _isSelectionMode
                                      ? HitTestBehavior.opaque
                                      : HitTestBehavior.translucent,
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: isSelected ? 0.5 : 1.0,
                                        child: Card(
                                          key: ValueKey(colorPreset.id),
                                          color: isDark
                                              ? Colors.grey[800]
                                              : Colors.white,
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              screenWidth * 0.03,
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        screenWidth * 0.03,
                                                      ),
                                                  color: color,
                                                ),
                                                margin: EdgeInsets.all(
                                                  screenWidth * 0.02,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(
                                                  screenWidth * 0.02,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal:
                                                                  screenWidth *
                                                                  0.02,
                                                              vertical:
                                                                  screenWidth *
                                                                  0.01,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: isDark
                                                              ? Colors.black
                                                                    .withOpacity(
                                                                      0.5,
                                                                    )
                                                              : Colors.white
                                                                    .withOpacity(
                                                                      0.9,
                                                                    ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                screenWidth *
                                                                    0.02,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          colorPreset
                                                              .displayLabel,
                                                          style: TextStyle(
                                                            fontSize:
                                                                screenWidth *
                                                                0.032,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: isDark
                                                                ? Colors.white
                                                                : Colors
                                                                      .grey[900],
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    if (!_isSelectionMode)
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              showEditColorBottomSheet(
                                                                colorPreset,
                                                              );
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    screenWidth *
                                                                        0.015,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: isDark
                                                                    ? Colors
                                                                          .black
                                                                          .withOpacity(
                                                                            0.5,
                                                                          )
                                                                    : Colors
                                                                          .white
                                                                          .withOpacity(
                                                                            0.9,
                                                                          ),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Icon(
                                                                Icons.edit,
                                                                size:
                                                                    screenWidth *
                                                                    0.05,
                                                                color: isDark
                                                                    ? Colors
                                                                          .green[300]
                                                                    : Colors
                                                                          .blue,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                screenWidth *
                                                                0.015,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              final colorId =
                                                                  colorPreset
                                                                      .id;
                                                              final currentColor = displayedColors
                                                                  .value!
                                                                  .firstWhere(
                                                                    (c) =>
                                                                        c.id ==
                                                                        colorId,
                                                                    orElse: () =>
                                                                        colorPreset,
                                                                  );
                                                              deleteColor(
                                                                currentColor,
                                                              );
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                    screenWidth *
                                                                        0.015,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: isDark
                                                                    ? Colors
                                                                          .black
                                                                          .withOpacity(
                                                                            0.5,
                                                                          )
                                                                    : Colors
                                                                          .white
                                                                          .withOpacity(
                                                                            0.9,
                                                                          ),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: Icon(
                                                                Icons.delete,
                                                                size:
                                                                    screenWidth *
                                                                    0.05,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
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
                                );
                              },
                              childCount: displayedColors.value!.length,
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
          ),
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
