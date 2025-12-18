import 'package:de_helper/test_data/test_measurements.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/measurement.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/widgets/stat_card.dart';
import 'package:de_helper/pages/Measurement/widgets/measurement_form_bottom_sheet.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/pages/Measurement/widgets/measurement_empty_state.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({super.key});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  List<MeasurementPreset> _displayedMeasurements = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _displayedMeasurements = testMeasurements;
    _sortMeasurements();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _sortMeasurements() {
    final sorted = List<MeasurementPreset>.from(_displayedMeasurements);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    setState(() {
      _displayedMeasurements = sorted;
    });
  }

  void _filterMeasurements(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedMeasurements = testMeasurements;
      } else {
        _displayedMeasurements = testMeasurements
            .where(
              (measurement) =>
                  measurement.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
      _sortMeasurements();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _filterMeasurements('');
  }

  int _getTotalMeasurements() => testMeasurements.length;

  void _showAddMeasurementBottomSheet() {
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
        setState(() {
          testMeasurements.add(newMeasurement);
          _displayedMeasurements = testMeasurements;
          _sortMeasurements();
        });
      }
    });
  }

  void _showEditMeasurementBottomSheet(MeasurementPreset measurement) {
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
        final measurementId = measurement.id;
        final index = testMeasurements.indexWhere(
          (m) => m.id == measurementId,
        );
        if (index != -1) {
          setState(() {
            testMeasurements[index] = MeasurementPreset(
              id: measurement.id,
              name: result['name'] as String,
            );
            final displayedIndex = _displayedMeasurements.indexWhere(
              (m) => m.id == measurement.id,
            );
            if (displayedIndex != -1) {
              _displayedMeasurements[displayedIndex] = testMeasurements[index];
            }
            _sortMeasurements();
          });
        }
      }
    });
  }

  void _deleteMeasurement(MeasurementPreset measurement) {
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
                setState(() {
                  testMeasurements.removeWhere((m) => m.id == measurement.id);
                  _displayedMeasurements.removeWhere(
                    (m) => m.id == measurement.id,
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
      title: 'Measurements',
      onAction: _showAddMeasurementBottomSheet,
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
                      value: _getTotalMeasurements().toString(),
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
                            onChanged: _filterMeasurements,
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
          _displayedMeasurements.isEmpty
              ? SliverFillRemaining(
                  child: MeasurementEmptyState(
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
                        final measurement = _displayedMeasurements[index];
                        return Card(
                          key: ValueKey(measurement.id),
                          color: isDark ? Colors.grey[800] : Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.03,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(screenWidth * 0.02),
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
                              Positioned(
                                top: screenWidth * 0.01,
                                right: screenWidth * 0.01,
                                child: GestureDetector(
                                  onTap: () {
                                    _showEditMeasurementBottomSheet(
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
                                    final measurementId = measurement.id;
                                    final currentMeasurement = testMeasurements
                                        .firstWhere(
                                          (m) => m.id == measurementId,
                                          orElse: () => measurement,
                                        );
                                    _deleteMeasurement(currentMeasurement);
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
                          ),
                        );
                      },
                      childCount: _displayedMeasurements.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
