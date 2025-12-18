import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:de_helper/providers/theme_provider.dart';

class PageScaffold extends ConsumerWidget {
  final Widget body;
  final String? title;
  final VoidCallback? onAction;
  final IconData? actionIcon;
  final Color? actionColor;

  const PageScaffold({
    super.key,
    required this.body,
    this.title,
    this.onAction,
    this.actionIcon,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isDark = ref.watch(themeStateProvider);

    return Scaffold(
      body: body,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category,
              color: isDark ? Colors.white : Colors.black,
            ),
            SizedBox(width: screenWidth * 0.02),
            Text(
              title ?? '',
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(themeStateProvider.notifier).toggle();
            },
          ),
        ],
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
