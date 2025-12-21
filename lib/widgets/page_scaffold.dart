import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:de_helper/providers/theme_provider.dart';

class PageScaffold extends ConsumerWidget {
  final Widget body;
  final String? title;
  final VoidCallback? onAction;
  final IconData? actionIcon;
  final Color? actionColor;
  final bool showDrawer;
  final IconData? titleIcon;

  const PageScaffold({
    super.key,
    required this.body,
    this.title,
    this.onAction,
    this.actionIcon,
    this.actionColor,
    this.showDrawer = true,
    this.titleIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isDark = ref.watch(themeStateProvider);

    // Try to find parent Scaffold with drawer BEFORE creating our own Scaffold
    final parentScaffold = Scaffold.maybeOf(context);
    final hasParentDrawer = parentScaffold?.hasDrawer ?? false;
    // Store the parent scaffold state to use later
    final parentScaffoldState = hasParentDrawer ? parentScaffold : null;

    return Scaffold(
      body: body,
      appBar: AppBar(
        centerTitle: true,
        leading: (showDrawer && parentScaffoldState != null)
            ? IconButton(
                icon: Icon(
                  Icons.menu,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  // Use the stored parent scaffold state to open the drawer
                  parentScaffoldState.openDrawer();
                },
              )
            : null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              titleIcon ?? Icons.category,
              color: isDark ? Colors.white : Colors.black,
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              title ?? '',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            SizedBox(width: screenWidth * 0.10),
          ],
        ),
      ),
      floatingActionButton: onAction != null
          ? FloatingActionButton(
              onPressed: onAction,
              backgroundColor:
                  actionColor ?? (isDark ? Colors.green[700]! : Colors.blue),
              child: Icon(
                actionIcon ?? Icons.add,
                color: Colors.white,
                size: screenWidth * 0.06,
              ),
            )
          : null,
    );
  }
}
