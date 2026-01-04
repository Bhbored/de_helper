import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:de_helper/providers/theme_provider.dart';
import 'package:de_helper/utility/theme_selector.dart';

class PageScaffold extends ConsumerWidget {
  final Widget body;
  final String? title;
  final VoidCallback? onAction;
  final IconData? actionIcon;
  final Color? actionColor;
  final bool showDrawer;
  final IconData? titleIcon;
  final List<Widget>? actions;

  const PageScaffold({
    super.key,
    required this.body,
    this.title,
    this.onAction,
    this.actionIcon,
    this.actionColor,
    this.showDrawer = true,
    this.titleIcon,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final viewInsets = mediaQuery.viewInsets;
    final isDark = ref.watch(themeStateProvider);

    final parentScaffold = Scaffold.maybeOf(context);
    final hasParentDrawer = parentScaffold?.hasDrawer ?? false;
    final parentScaffoldState = hasParentDrawer ? parentScaffold : null;

    final isInNavContainer = hasParentDrawer;
    final viewInsetsBottom = viewInsets.bottom;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: kToolbarHeight + mediaQuery.padding.top,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceDark
                      : AppColors.surfaceLight,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      if (showDrawer && parentScaffoldState != null)
                        IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          onPressed: () {
                            parentScaffoldState.openDrawer();
                          },
                        )
                      else if (!showDrawer && Navigator.canPop(context))
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      SizedBox(width: screenHeight * 0.1),
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              titleIcon ?? Icons.category,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              title ?? '',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (actions != null) ...actions!,
                      SizedBox(
                        width: showDrawer && parentScaffoldState != null
                            ? 0
                            : screenWidth * 0.10,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: isDark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: isInNavContainer ? 0 : viewInsetsBottom,
                    ),
                    child: body,
                  ),
                ),
              ),
            ],
          ),
          if (onAction != null)
            Positioned(
              right: screenWidth * 0.05,
              bottom: screenHeight * 0.02,
              child: FloatingActionButton(
                onPressed: onAction,
                backgroundColor:
                    actionColor ??
                    (isDark ? AppColors.primaryDark : AppColors.primaryLight),
                child: Icon(
                  actionIcon ?? Icons.add,
                  color: Colors.white,
                  size: screenWidth * 0.06,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
