import 'package:de_helper/test_data/test_colors.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/color_preset.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/widgets/stat_card.dart';
import 'package:de_helper/pages/Color/widgets/color_form_bottom_sheet.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Color/widgets/color_empty_state.dart';

class ColorPage extends StatefulWidget {
  const ColorPage({super.key});

  @override
  State<ColorPage> createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  List<ColorPreset> _displayedColors = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayedColors = testColors;
    _sortColors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _sortColors() {
    final sorted = List<ColorPreset>.from(_displayedColors);
    sorted.sort((a, b) => a.displayLabel.compareTo(b.displayLabel));
    setState(() {
      _displayedColors = sorted;
    });
  }

  void _filterColors(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedColors = testColors;
      } else {
        _displayedColors = testColors
            .where(
              (color) => color.displayLabel.toLowerCase().contains(
                query.toLowerCase(),
              ),
            )
            .toList();
      }
      _sortColors();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterColors('');
  }

  int _getTotalColors() => testColors.length;

  Color _hexToColor(String? hex) {
    if (hex == null) return Colors.grey;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    }
    return Colors.grey;
  }

  void _showAddColorBottomSheet() {
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
        } else if (result['name'] != null) {
          newColor = ColorPreset.create(
            name: result['name'] as String,
          );
        } else {
          return;
        }
        setState(() {
          testColors.add(newColor);
          _displayedColors = testColors;
          _sortColors();
        });
      }
    });
  }

  void _showEditColorBottomSheet(ColorPreset colorPreset) {
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
        final colorId = colorPreset.id;
        final index = testColors.indexWhere((c) => c.id == colorId);
        if (index != -1) {
          setState(() {
            if (result['hexCode'] != null) {
              testColors[index] = ColorPreset(
                id: colorPreset.id,
                hexCode: result['hexCode'] as String,
              );
            } else if (result['name'] != null) {
              testColors[index] = ColorPreset(
                id: colorPreset.id,
                name: result['name'] as String,
              );
            }
            final displayedIndex = _displayedColors.indexWhere(
              (c) => c.id == colorPreset.id,
            );
            if (displayedIndex != -1) {
              _displayedColors[displayedIndex] = testColors[index];
            }
            _sortColors();
          });
        }
      }
    });
  }

  void _deleteColor(ColorPreset colorPreset) {
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
                setState(() {
                  testColors.removeWhere((c) => c.id == colorPreset.id);
                  _displayedColors.removeWhere(
                    (c) => c.id == colorPreset.id,
                  );
                });
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

  @override
  Widget build(BuildContext context) {
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

    return PageScaffold(
      title: 'Colors',
      onAction: _showAddColorBottomSheet,
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
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    StatCard(
                      value: _getTotalColors().toString(),
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
                            onChanged: _filterColors,
                            decoration: InputDecoration(
                              hintText: 'Search colors...',
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
                    SizedBox(height: verticalPadding),
                  ],
                ),
              ),
            ),
          ),
          _displayedColors.isEmpty
              ? SliverFillRemaining(
                  child: ColorEmptyState(
                    isDark: isDark,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: screenWidth * 0.03,
                      mainAxisSpacing: screenWidth * 0.03,
                      childAspectRatio: 1.5,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final colorPreset = _displayedColors[index];
                        final color = _hexToColor(colorPreset.hexCode);
                        return Card(
                          key: ValueKey(colorPreset.id),
                          color: isDark ? Colors.grey[800] : Colors.white,
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
                                  borderRadius: BorderRadius.circular(
                                    screenWidth * 0.03,
                                  ),
                                  color: color,
                                ),
                                margin: EdgeInsets.all(screenWidth * 0.02),
                              ),
                              Padding(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.02,
                                          vertical: screenWidth * 0.01,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.black.withOpacity(0.5)
                                              : Colors.white.withOpacity(0.9),
                                          borderRadius: BorderRadius.circular(
                                            screenWidth * 0.02,
                                          ),
                                        ),
                                        child: Text(
                                          colorPreset.displayLabel,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.032,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.grey[900],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _showEditColorBottomSheet(
                                              colorPreset,
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                              screenWidth * 0.015,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.black.withOpacity(
                                                      0.5,
                                                    )
                                                  : Colors.white.withOpacity(
                                                      0.9,
                                                    ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              size: screenWidth * 0.05,
                                              color: isDark
                                                  ? Colors.green[300]
                                                  : Colors.blue,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.015),
                                        GestureDetector(
                                          onTap: () {
                                            final colorId = colorPreset.id;
                                            final currentColor = testColors
                                                .firstWhere(
                                                  (c) => c.id == colorId,
                                                  orElse: () => colorPreset,
                                                );
                                            _deleteColor(currentColor);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(
                                              screenWidth * 0.015,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isDark
                                                  ? Colors.black.withOpacity(
                                                      0.5,
                                                    )
                                                  : Colors.white.withOpacity(
                                                      0.9,
                                                    ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.delete,
                                              size: screenWidth * 0.05,
                                              color: Colors.red,
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
                        );
                      },
                      childCount: _displayedColors.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
