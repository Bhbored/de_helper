import 'package:de_helper/pages/nav_container.dart';
import 'package:de_helper/pages/splash_screen.dart';
import 'package:de_helper/providers/theme_provider.dart';
import 'package:de_helper/utility/theme_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeStateProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeSelector.lightTheme,
      darkTheme: ThemeSelector.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(
        child: const NavContainer(),
      ),
    );
  }
}
