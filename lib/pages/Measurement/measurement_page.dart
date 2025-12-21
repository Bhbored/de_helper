import 'package:de_helper/providers/measurement_provider.dart';
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
  MeasurementPreset? copied;
  bool _isSelectionMode = false;
  final Set<String> _selectedMeasurementIds = {};
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

    void _handleDeleteSelected(List<MeasurementPreset> selectedMeasurements) {
      // This method will be called with the selected measurements
      // User will implement the actual deletion logic
      // For now, just clear selection
      setState(() {
        _selectedMeasurementIds.clear();
        _isSelectionMode = false;
      });
    }

    void _toggleSelection(String measurementId) {
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

    void _exitSelectionMode() {
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
        },
        child: displayedMeasurements.when(
          data: (data) => CustomScrollView(
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
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
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
                        if (_isSelectionMode &&
                            _selectedMeasurementIds.isNotEmpty) ...[
                          SizedBox(height: verticalPadding),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding * 0.5,
                              vertical: screenHeight * 0.015,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.02,
                              ),
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
                                    _handleDeleteSelected(selectedMeasurements);
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
                        ],
                        SizedBox(height: verticalPadding),
                      ],
                    ),
                  ),
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: screenWidth * 0.03,
                          mainAxisSpacing: screenWidth * 0.03,
                          childAspectRatio: 1.5,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final measurement =
                                displayedMeasurements.value![index];
                            final isSelected = _selectedMeasurementIds.contains(
                              measurement.id,
                            );
                            return GestureDetector(
                              onLongPress: () {
                                if (!_isSelectionMode) {
                                  setState(() {
                                    _isSelectionMode = true;
                                    _selectedMeasurementIds.add(measurement.id);
                                  });
                                }
                              },
                              onTap: _isSelectionMode
                                  ? () {
                                      _toggleSelection(measurement.id);
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
                                                  fontSize: screenWidth * 0.035,
                                                  fontWeight: FontWeight.w500,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.grey[900],
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          if (!_isSelectionMode) ...[
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
                                                    size: screenWidth * 0.06,
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
                                                    size: screenWidth * 0.06,
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
                                          borderRadius: BorderRadius.circular(
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
                          childCount: displayedMeasurements.value?.length ?? 0,
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
