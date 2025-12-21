import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:de_helper/pages/Category/category_page.dart';
import 'package:de_helper/pages/Subcategory/subcategory_page.dart';
import 'package:de_helper/pages/Measurement/measurement_page.dart';
import 'package:de_helper/pages/Color/color_page.dart';
import 'package:de_helper/widgets/main_drawer.dart';

class NavContainer extends ConsumerStatefulWidget {
  const NavContainer({super.key});

  @override
  ConsumerState<NavContainer> createState() => _NavContainerState();
}

class _NavContainerState extends ConsumerState<NavContainer> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CategoryPage(),
    const SubcategoryPage(),
    const MeasurementPage(),
    const ColorPage(),
  ];

  void setScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: MainDrawer(
        selectScreen: setScreen,
      ),
      body: SafeArea(
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: isDark ? Colors.green[300] : Colors.blue,
          unselectedItemColor: isDark ? Colors.grey[600] : Colors.grey[600],
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedFontSize: screenWidth * 0.03,
          unselectedFontSize: screenWidth * 0.03,
          iconSize: screenWidth * 0.06,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.folder),
              label: 'Categories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.description),
              label: 'Subcategories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.layers),
              label: 'Measurements',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.palette),
              label: 'Colors',
            ),
          ],
        ),
      ),
    );
  }
}
