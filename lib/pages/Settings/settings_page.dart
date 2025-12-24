import 'package:de_helper/data/db/app_database.dart'
    hide ColorPreset, MeasurementPreset;
import 'package:de_helper/data/repos/color_preset_repository_impl.dart';
import 'package:de_helper/data/repos/measurement_preset_repository_impl.dart';
import 'package:de_helper/providers/category_provider.dart';
import 'package:de_helper/providers/color_provider.dart';
import 'package:de_helper/providers/measurement_provider.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:de_helper/providers/subcategory_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:de_helper/providers/theme_provider.dart';
import 'package:de_helper/widgets/page_scaffold.dart';
import 'package:de_helper/models/color_preset.dart';
import 'package:de_helper/models/measurement.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDark = ref.watch(themeStateProvider);
    Future<void> initializeNullPresets() async {
      try {
        final colorRepo = ref.read(colorRepoProvider);
        final measurementRepo = ref.read(measurmentRepoProvider);

        final nullColor = await colorRepo.getByName('NULL');
        if (nullColor == null) {
          await ref
              .read(colorProvider.notifier)
              .addProduct(
                ColorPreset(id: '1', name: 'NULL', hexCode: '808080'),
              );
        }

        final nullMeasurement = await measurementRepo.getByName('NULL');
        if (nullMeasurement == null) {
          await ref
              .read(measurementProvider.notifier)
              .addMeasurement(
                MeasurementPreset(id: '1', name: 'NULL'),
              );
        }
      } catch (e) {
        throw StateError('Error initializing null presets');
      }
    }

    final db = ref.read(getDbProvider);
    void showClearDataConfirmation(BuildContext context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      final screenWidth = MediaQuery.of(context).size.width;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          title: Text(
            'Clear All Data',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              color: isDark ? Colors.white : Colors.grey[900],
            ),
          ),
          content: Text(
            'Are you sure you want to clear all data? This action cannot be undone.',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await db.deleteDatabase();
                await initializeNullPresets();
                ref.invalidate(categoryProvider);
                ref.invalidate(subcategoryProvider);
                ref.invalidate(prodcutProvider);
                ref.invalidate(colorProvider);
                ref.invalidate(measurementProvider);
                await ref.read(colorProvider.future);
                await ref.read(measurementProvider.future);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All data cleared successfully'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Clear',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return PageScaffold(
      title: 'Settings',
      titleIcon: Icons.settings,
      showDrawer: false,
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        children: [
          SizedBox(height: screenHeight * 0.02),

          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: SwitchListTile(
              value: isDark,
              onChanged: (value) {
                ref.read(themeStateProvider.notifier).toggle();
              },
              title: Row(
                children: [
                  Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    color: isDark ? Colors.green[300] : Colors.blue[700],
                    size: screenWidth * 0.06,
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                isDark ? 'Switch to light theme' : 'Switch to dark theme',
                style: TextStyle(
                  fontSize: screenWidth * 0.032,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              activeThumbColor: Colors.green[300],
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey[300],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: ListTile(
              leading: Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: screenWidth * 0.06,
              ),
              title: Text(
                'Clear All Data',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              subtitle: Text(
                'Delete all categories, products, and settings',
                style: TextStyle(
                  fontSize: screenWidth * 0.032,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              onTap: () => showClearDataConfirmation(context),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }
}
