import 'package:flutter/material.dart';

class ColorPage extends StatefulWidget {
  const ColorPage({super.key});

  @override
  State<ColorPage> createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
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
            'Colors',
            style: TextStyle(fontSize: screenWidth * 0.05),
          ),
        ),
        SliverFillRemaining(
          child: Center(
            child: Text(
              'Colors Page',
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
          ),
        ),
      ],
    );
  }
}

