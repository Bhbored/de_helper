import 'dart:async';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/providers/helpers_providers.dart';
import 'package:de_helper/providers/measurement_provider.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/measurement.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/widgets/stat_card.dart';
import 'package:de_helper/pages/Measurement/widgets/measurement_form_bottom_sheet.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Measurement/widgets/measurement_empty_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeasurementPage extends ConsumerStatefulWidget {
  const MeasurementPage({super.key});

  @override
  ConsumerState<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends ConsumerState<MeasurementPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  MeasurementPreset? copied;
  bool _isSelectionMode = false;
  final Set<String> _selectedMeasurementIds = {};
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
    final displayedMeasurements = ref.watch(measurementProvider);
    final notifier = ref.read(measurementProvider.notifier);

    ref.listen(measurementProvider, (previous, next) {
      if (copied != null && next.value!.length < previous!.value!.length) {
        final categoryToShow = copied!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Measurement "${categoryToShow.name}" deleted'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                if (mounted) {
                  ref
                      .read(measurementProvider.notifier)
                      .addMeasurement(copied!);
                }
                copied = null;
              },
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
    void filterMeasurements(String query) {
      if (query.isEmpty) {
        notifier.refreshMeasurement();
      } else {
        notifier.filterByName(query);
      }
    }

    void clearSearch() {
      _searchController.clear();
      filterMeasurements('');
    }

    int getTotalMeasurements() => displayedMeasurements.value?.length ?? 0;

    void showAddMeasurementBottomSheet() {
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const MeasurementFormBottomSheet(),
      ).then((result) {
        if (result != null && result['name'] != null) {
          final newMeasurement = MeasurementPreset.create(
            name: result['name'] as String,
          );
          notifier.addMeasurement(newMeasurement);
        }
      });
    }

    void showEditMeasurementBottomSheet(MeasurementPreset measurement) {
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => MeasurementFormBottomSheet(
          key: ValueKey(measurement.id),
          measurement: measurement,
        ),
      ).then((result) {
        if (result != null && result['name'] != null) {
          final updatedMeas = measurement.copyWith(
            name: result['name'] as String,
          );
          notifier.updateMeasurement(updatedMeas);
        }
      });
    }

    Future<void> handleDelete(MeasurementPreset selectedMeasurement) async {
      final subProducts = await ref.read(
        productsByMeasurementProvider(selectedMeasurement.id).future,
      );

      for (final product in subProducts) {
        final updatedProduct = product.copyWith(measurementPresetId: '');
        await ref.read(prodcutProvider.notifier).updateProduct(updatedProduct);
      }
    }

    void deleteMeasurement(MeasurementPreset measurement) {
      final id = measurement.id;
      showDialog(
        context: context,
        builder: (context) {
          final mediaQuery = MediaQuery.of(context);
          final screenWidth = mediaQuery.size.width;
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? Colors.grey[800] : Colors.white,
            title: Text(
              'Delete Measurement',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: isDark ? Colors.white : Colors.grey[900],
              ),
            ),
            content: Text(
              'Are you sure you want to delete "${measurement.name}"?',
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
                  copied = measurement;
                  handleDelete(measurement);
                  notifier.deleteMeasurement(id);
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

    void handleDeleteSelected(
      List<MeasurementPreset> selectedMeasurements,
    ) async {
      final productsToUpdate = <Product>[];
      for (final x in selectedMeasurements) {
        final subProducts = await ref.read(
          productsByMeasurementProvider(x.id).future,
        );
        productsToUpdate.addAll(
          subProducts.map((p) => p.copyWith(measurementPresetId: '')),
        );
      }

      for (final product in productsToUpdate) {
        await ref.read(prodcutProvider.notifier).updateProduct(product);
      }

      await ref
          .read(measurementProvider.notifier)
          .deleteSelection(selectedMeasurements);
      setState(() {
        _selectedMeasurementIds.clear();
        _isSelectionMode = false;
      });
    }

    void toggleSelection(String measurementId) {
      setState(() {
        if (_selectedMeasurementIds.contains(measurementId)) {
          _selectedMeasurementIds.remove(measurementId);
          if (_selectedMeasurementIds.isEmpty) {
            _isSelectionMode = false;
          }
        } else {
          _selectedMeasurementIds.add(measurementId);
          if (!_isSelectionMode) {
            _isSelectionMode = true;
          }
        }
      });
    }

    void exitSelectionMode() {
      setState(() {
        _isSelectionMode = false;
        _selectedMeasurementIds.clear();
      });
    }

    return PageScaffold(
      title: 'Measurements',
      titleIcon: Icons.layers,
      onAction: _isSelectionMode ? null : showAddMeasurementBottomSheet,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(measurementProvider);
          ref.read(measurementProvider.future);
          exitSelectionMode();
        },
        child: displayedMeasurements.when(
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
                              'CURRENT MEASUREMENTS',
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
                              value: getTotalMeasurements().toString(),
                              label: 'Total Measurements',
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
                                    onChanged: filterMeasurements,
                                    decoration: InputDecoration(
                                      hintText: 'Search measurements...',
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
                  if (_isSelectionMode && _selectedMeasurementIds.isNotEmpty)
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
                                '${_selectedMeasurementIds.length} selected',
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
                                  final selectedMeasurements =
                                      displayedMeasurements.value!
                                          .where(
                                            (measurement) =>
                                                _selectedMeasurementIds
                                                    .contains(measurement.id),
                                          )
                                          .toList();
                                  handleDeleteSelected(selectedMeasurements);
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
                  displayedMeasurements.value!.isEmpty
                      ? SliverFillRemaining(
                          child: MeasurementEmptyState(
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
                                final measurement =
                                    displayedMeasurements.value![index];
                                final isSelected = _selectedMeasurementIds
                                    .contains(
                                      measurement.id,
                                    );
                                final isNullPreset = measurement.name == 'NULL';
                                return GestureDetector(
                                  onLongPress: () {
                                    if (!_isSelectionMode && !isNullPreset) {
                                      setState(() {
                                        _isSelectionMode = true;
                                        _selectedMeasurementIds.add(
                                          measurement.id,
                                        );
                                      });
                                    }
                                  },
                                  onTap: _isSelectionMode && !isNullPreset
                                      ? () {
                                          toggleSelection(measurement.id);
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
                                          key: ValueKey(measurement.id),
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
                                              Padding(
                                                padding: EdgeInsets.all(
                                                  screenWidth * 0.02,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    measurement.name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          screenWidth * 0.035,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.grey[900],
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              if (!_isSelectionMode &&
                                                  !isNullPreset) ...[
                                                Positioned(
                                                  top: screenWidth * 0.01,
                                                  right: screenWidth * 0.01,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showEditMeasurementBottomSheet(
                                                        measurement,
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        screenWidth * 0.015,
                                                      ),
                                                      child: Icon(
                                                        Icons.edit,
                                                        size:
                                                            screenWidth * 0.06,
                                                        color: isDark
                                                            ? Colors.green[300]
                                                            : Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: screenWidth * 0.01,
                                                  right: screenWidth * 0.01,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      final measurementId =
                                                          measurement.id;
                                                      final currentMeasurement =
                                                          displayedMeasurements
                                                              .value!
                                                              .firstWhere(
                                                                (m) =>
                                                                    m.id ==
                                                                    measurementId,
                                                                orElse: () =>
                                                                    measurement,
                                                              );
                                                      deleteMeasurement(
                                                        currentMeasurement,
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                        screenWidth * 0.015,
                                                      ),
                                                      child: Icon(
                                                        Icons.delete,
                                                        size:
                                                            screenWidth * 0.06,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (_isSelectionMode && !isNullPreset)
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
                              childCount:
                                  displayedMeasurements.value?.length ?? 0,
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
                    heroTag: 'measurement_scroll_button',
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
