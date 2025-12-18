import 'package:flutter/material.dart';

class SubcategoryPage extends StatefulWidget {
  const SubcategoryPage({super.key});

  @override
  State<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
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
            'Subcategories',
            style: TextStyle(fontSize: screenWidth * 0.05),
          ),
        ),
        SliverFillRemaining(
          child: Center(
            child: Text(
              'Subcategories Page',
              style: TextStyle(fontSize: screenWidth * 0.04),
            ),
          ),
        ),
      ],
    );
  }
}

