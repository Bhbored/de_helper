import 'dart:io';
import 'package:excel/excel.dart';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/models/category.dart';
import 'package:de_helper/models/subcategory.dart';
import 'package:de_helper/models/color_preset.dart';
import 'package:de_helper/models/measurement.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExcelExport {
  static Future<String?> exportProducts({
    required List<Product> products,
    required Category category,
    required List<Category> allCategories,
    required List<SubCategory> allSubCategories,
    required List<ColorPreset> allColors,
    required List<MeasurementPreset> allMeasurements,
  }) async {
    try {
      final excel = Excel.createExcel();
      excel.delete('Sheet1');
      final sheet = excel['Products'];

      String? getSubCategoryName(String? subCategoryId) {
        if (subCategoryId == null) return null;
        try {
          return allSubCategories.firstWhere((s) => s.id == subCategoryId).name;
        } catch (e) {
          return null;
        }
      }

      String getColorName(String colorPresetId) {
        try {
          return allColors
              .firstWhere((c) => c.id == colorPresetId)
              .displayLabel;
        } catch (e) {
          return 'Unknown';
        }
      }

      String getMeasurementName(String measurementPresetId) {
        try {
          return allMeasurements
              .firstWhere((m) => m.id == measurementPresetId)
              .name;
        } catch (e) {
          return 'Unknown';
        }
      }

      final headers = [
        'NAME',
        'PRICE',
        'COST',
        'PROFIT MARGIN',
        'QUANTITY',
        'SUBCATEGORY',
        'COLOR',
        'MEASUREMENT',
        'BARCODE',
        'SECONDARY BARCODE',
      ];

      for (int i = 0; i < headers.length; i++) {
        final cell = sheet.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.value = headers[i];
        cell.cellStyle = CellStyle(
          bold: true,
          fontSize: 12,
        );
      }

      for (int rowIndex = 0; rowIndex < products.length; rowIndex++) {
        final product = products[rowIndex];
        final row = rowIndex + 1;

        final cost = product.manualCost ?? product.cost;

        final profitMargin = product.profitMargin > 0
            ? '${(product.profitMargin * 100).toStringAsFixed(2)}%'
            : '';

        final subCategoryName = getSubCategoryName(product.subCategoryId) ?? '';

        final secondaryBarcode = product.secondaryBarcode ?? '';

        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row))
                .value =
            product.name;
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row))
                .value =
            product.price;
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row))
                .value =
            cost;
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: row))
                .value =
            profitMargin;
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: row))
                .value =
            product.quantity;
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: row))
                .value =
            subCategoryName;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: row))
            .value = getColorName(
          product.colorPresetId,
        );
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: row))
            .value = getMeasurementName(
          product.measurementPresetId,
        );
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: row))
                .value =
            product.barcode;
        sheet
                .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: row))
                .value =
            secondaryBarcode;
      }

      final fileBytes = excel.save();
      if (fileBytes == null) {
        return null;
      }

      Directory? documentsDir;
      try {
        if (Platform.isAndroid) {
          final externalDirs = await getExternalStorageDirectories();
          if (externalDirs != null && externalDirs.isNotEmpty) {
            final externalPath = externalDirs.first.path;

            final rootPath = externalPath.split('/Android')[0];
            documentsDir = Directory('$rootPath/Documents');
          } else {
            documentsDir = await getApplicationDocumentsDirectory();
          }
        } else {
          documentsDir = await getApplicationDocumentsDirectory();
        }

        if (!await documentsDir.exists()) {
          await documentsDir.create(recursive: true);
        }

        final fileName =
            '${category.name.replaceAll(RegExp(r'[^\w\s-]'), '_')}.xlsx';
        final filePath = '${documentsDir.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(fileBytes);
        return filePath;
      } catch (e) {
        try {
          final directory = await getApplicationDocumentsDirectory();
          final fileName =
              '${category.name.replaceAll(RegExp(r'[^\w\s-]'), '_')}.xlsx';
          final filePath = '${directory.path}/$fileName';
          final file = File(filePath);
          await file.writeAsBytes(fileBytes);
          return filePath;
        } catch (e2) {
          return null;
        }
      }
    } catch (e) {
      return null;
    }
  }

  static Future<void> shareFile(String filePath) async {
    try {
      final file = XFile(filePath);
      await Share.shareXFiles([file], text: 'Product Export');
    } catch (e) {
      rethrow;
    }
  }
}
