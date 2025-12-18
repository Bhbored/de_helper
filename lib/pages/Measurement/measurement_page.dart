import 'package:flutter/material.dart';

class MeasurementPage extends StatefulWidget {
  const MeasurementPage({super.key});

  @override
  State<MeasurementPage> createState() => _MeasurementPageState();
}

class _MeasurementPageState extends State<MeasurementPage> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: screenHeight * 0.15,
          floating: false,
          pinned: true,
          title: Text(
            'Measurements',
            style: TextStyle(fontSize: screenWidth * 0.05),
          ),
        ),
        SliverFillRemaining(
          child: Center(
            child: Text(
              'Measurements Page',
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
          ),
        ),
      ],
    );
  }
}

