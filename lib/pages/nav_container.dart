import 'dart:ui';
import 'package:de_helper/data/repos/color_preset_repository_impl.dart';
import 'package:de_helper/data/repos/measurement_preset_repository_impl.dart';
import 'package:de_helper/models/color_preset.dart';
import 'package:de_helper/models/measurement.dart';
import 'package:de_helper/pages/Category/category_page.dart';
import 'package:de_helper/pages/Color/color_page.dart';
import 'package:de_helper/pages/Measurement/measurement_page.dart';
import 'package:de_helper/pages/Subcategory/subcategory_page.dart';
import 'package:de_helper/pages/Product/all_products_page.dart';
import 'package:de_helper/providers/color_provider.dart';
import 'package:de_helper/providers/measurement_provider.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:de_helper/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    const AllProductsPage(),
  ];

  void setScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNullPresets();
    });
  }

  void _initializeNullPresets() async {
    try {
      final colorRepo = ref.read(colorRepoProvider);
      final measurementRepo = ref.read(measurmentRepoProvider);

      final nullColor = await colorRepo.getByName('NULL');
      if (nullColor == null) {
        await ref
            .read(colorProvider.notifier)
            .addProduct(ColorPreset(id: '1', name: 'NULL', hexCode: '808080'));
      }

      final nullMeasurement = await measurementRepo.getByName('NULL');
      if (nullMeasurement == null) {
        await ref
            .read(measurementProvider.notifier)
            .addMeasurement(MeasurementPreset(id: '1', name: 'NULL'));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = mediaQuery.padding.bottom;
    final viewInsets = mediaQuery.viewInsets.bottom;

    return Scaffold(
      extendBody: false,
      drawer: MainDrawer(selectScreen: setScreen),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppGradients.darkBackground
              : AppGradients.lightBackground,
        ),
        child: SafeArea(
          bottom: false,
          child: AnimatedSwitcher(
            duration: AppAnimations.medium,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(_currentIndex),
              child: _pages[_currentIndex],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: viewInsets > 0
              ? viewInsets
              : bottomPadding > 0
              ? bottomPadding
              : 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isDark ? AppGradients.glassDark : AppGradients.glass,
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.white24,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                indicatorColor: isDark
                    ? AppColors.primaryDark
                    : AppColors.primaryLight,
                labelTextStyle: WidgetStateProperty.all(
                  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                iconTheme: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const IconThemeData(color: Colors.white);
                  }
                  return IconThemeData(
                    color: isDark ? Colors.white54 : Colors.black54,
                  );
                }),
              ),
              child: NavigationBar(
                height: 70,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.folder_outlined),
                    selectedIcon: Icon(Icons.folder),
                    label: 'Category',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.description_outlined),
                    selectedIcon: Icon(Icons.description),
                    label: 'Sub',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.layers_outlined),
                    selectedIcon: Icon(Icons.layers),
                    label: 'Measure',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.palette_outlined),
                    selectedIcon: Icon(Icons.palette),
                    label: 'Color',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.shopping_bag_outlined),
                    selectedIcon: Icon(Icons.shopping_bag),
                    label: 'Product',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
