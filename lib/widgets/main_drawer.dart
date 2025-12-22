import 'package:flutter/material.dart';
import 'package:de_helper/pages/Settings/settings_page.dart';

class MainDrawer extends StatelessWidget {
  final Function(int) selectScreen;

  const MainDrawer({
    super.key,
    required this.selectScreen,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                gradient: isDark
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey[900]!,
                          Colors.green[900]!.withOpacity(0.3),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.lightBlue[100]!,
                          Colors.white,
                        ],
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.settings,
                        size: screenWidth * 0.08,
                        color: isDark ? Colors.green[300] : Colors.blue[700],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    'Manage your preferences',
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.settings,
                        color: isDark ? Colors.green[300] : Colors.blue[700],
                        size: screenWidth * 0.06,
                      ),
                      title: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.grey[900],
                        ),
                      ),
                      subtitle: Text(
                        'Manage app preferences',
                        style: TextStyle(
                          fontSize: screenWidth * 0.032,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
