import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/models/category.dart';
import 'package:de_helper/models/subcategory.dart';
import 'package:de_helper/models/color_preset.dart';
import 'package:de_helper/models/measurement.dart';
import 'package:de_helper/test_data/test_products.dart';
import 'package:de_helper/test_data/test_colors.dart';
import 'package:de_helper/test_data/test_measurements.dart';
import 'package:de_helper/test_data/test_subcategories.dart';

class ProductFormBottomSheet extends StatefulWidget {
  final Category? category;
  final SubCategory? subCategory;
  final Product? product;

  const ProductFormBottomSheet({
    super.key,
    this.category,
    this.subCategory,
    this.product,
  }) : assert(
         category != null || subCategory != null,
         'Either category or subCategory must be provided',
       );

  @override
  State<ProductFormBottomSheet> createState() => _ProductFormBottomSheetState();
}

class _ProductFormBottomSheetState extends State<ProductFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _manualCostController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _secondaryBarcodeController = TextEditingController();
  final _quantityController = TextEditingController();

  String? _selectedColorId;
  String? _selectedMeasurementId;
  String? _selectedSubCategoryId;
  double _profitMargin = 0.0;
  bool _useProfitMargin = false;

  List<ColorPreset> _getUniqueColors() {
    return testColors
        .fold<Map<String, ColorPreset>>(
          {},
          (map, color) {
            if (!map.containsKey(color.id)) {
              map[color.id] = color;
            }
            return map;
          },
        )
        .values
        .toList();
  }

  List<MeasurementPreset> _getUniqueMeasurements() {
    return testMeasurements
        .fold<Map<String, MeasurementPreset>>(
          {},
          (map, measurement) {
            if (!map.containsKey(measurement.id)) {
              map[measurement.id] = measurement;
            }
            return map;
          },
        )
        .values
        .toList();
  }

  String? _getValidColorId(String? colorId) {
    final uniqueColors = _getUniqueColors();
    if (colorId == null || uniqueColors.isEmpty) return null;
    final exists = uniqueColors.any((c) => c.id == colorId);
    return exists
        ? colorId
        : (uniqueColors.isNotEmpty ? uniqueColors.first.id : null);
  }

  String? _getValidMeasurementId(String? measurementId) {
    final uniqueMeasurements = _getUniqueMeasurements();
    if (measurementId == null || uniqueMeasurements.isEmpty) return null;
    final exists = uniqueMeasurements.any((m) => m.id == measurementId);
    return exists
        ? measurementId
        : (uniqueMeasurements.isNotEmpty ? uniqueMeasurements.first.id : null);
  }

  List<SubCategory> _getUniqueSubCategories() {
    final available = _getAvailableSubCategories();
    return available
        .fold<Map<String, SubCategory>>(
          {},
          (map, subCategory) {
            if (!map.containsKey(subCategory.id)) {
              map[subCategory.id] = subCategory;
            }
            return map;
          },
        )
        .values
        .toList();
  }

  String? _getValidSubCategoryId(String? subCategoryId) {
    if (subCategoryId == null) return null;
    final uniqueSubCategories = _getUniqueSubCategories();
    if (uniqueSubCategories.isEmpty) return null;
    final exists = uniqueSubCategories.any((s) => s.id == subCategoryId);
    return exists ? subCategoryId : null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _barcodeController.text = widget.product!.barcode;
      _secondaryBarcodeController.text = widget.product!.secondaryBarcode ?? '';
      _quantityController.text = widget.product!.quantity.toString();
      _selectedColorId = _getValidColorId(widget.product!.colorPresetId);
      _selectedMeasurementId = _getValidMeasurementId(
        widget.product!.measurementPresetId,
      );
      _selectedSubCategoryId = _getValidSubCategoryId(
        widget.product!.subCategoryId,
      );
      _profitMargin = widget.product!.profitMargin * 100.0;
      _useProfitMargin = widget.product!.manualCost == null;
      if (widget.product!.manualCost != null) {
        _manualCostController.text = widget.product!.manualCost!.toString();
      }
    } else {
      _selectedColorId = testColors.isNotEmpty ? testColors.first.id : null;
      _selectedMeasurementId = testMeasurements.isNotEmpty
          ? testMeasurements.first.id
          : null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _manualCostController.dispose();
    _barcodeController.dispose();
    _secondaryBarcodeController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  String _getCategoryId() {
    if (widget.subCategory != null) {
      return widget.subCategory!.categoryId;
    }
    return widget.category!.id;
  }

  List<SubCategory> _getAvailableSubCategories() {
    final categoryId = _getCategoryId();
    return testSubCategories.where((s) => s.categoryId == categoryId).toList();
  }

  void _resetProfitMargin() {
    setState(() {
      _profitMargin = 0.0;
      _useProfitMargin = false;
    });
  }

  Future<void> _scanBarcode(TextEditingController controller) async {
    try {
      final result = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (context) => const _BarcodeScannerPage(),
        ),
      );

      if (result != null && mounted) {
        setState(() {
          controller.text = result;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error scanning barcode: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenHeight * 0.02;

    return SafeArea(
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: screenHeight,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(screenWidth * 0.06),
            topRight: Radius.circular(screenWidth * 0.06),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product == null ? 'Add Product' : 'Edit Product',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                  ),
                ],
              ),
              SizedBox(height: verticalPadding),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Price must be greater than 0';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: Switch(
                              value: _useProfitMargin,
                              onChanged: (value) {
                                setState(() {
                                  _useProfitMargin = value;
                                  if (value) {
                                    _manualCostController.clear();
                                  } else {
                                    _profitMargin = 0.0;
                                  }
                                });
                              },
                            ),
                          ),
                          Text(
                            'Use Profit Margin',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: isDark ? Colors.white : Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      if (!_useProfitMargin)
                        TextFormField(
                          controller: _manualCostController,
                          decoration: InputDecoration(
                            labelText: 'Manual Cost',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.02,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (!_useProfitMargin) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a cost or use profit margin';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              if (double.parse(value) < 0) {
                                return 'Cost cannot be negative';
                              }
                            }
                            return null;
                          },
                        ),
                      if (_useProfitMargin) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: _profitMargin,
                                min: 0.0,
                                max: 100.0,
                                divisions: 1000,
                                label: '${_profitMargin.toStringAsFixed(1)}%',
                                onChanged: (value) {
                                  setState(() {
                                    _profitMargin = value;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.refresh,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              onPressed: _resetProfitMargin,
                            ),
                            SizedBox(
                              width: screenWidth * 0.15,
                              child: Text(
                                '${_profitMargin.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.grey[900],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _barcodeController,
                        decoration: InputDecoration(
                          labelText: 'Barcode',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.qr_code_scanner,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            onPressed: () => _scanBarcode(_barcodeController),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a barcode';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _secondaryBarcodeController,
                        decoration: InputDecoration(
                          labelText: 'Secondary Barcode (Optional)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.qr_code_scanner,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            onPressed: () =>
                                _scanBarcode(_secondaryBarcodeController),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      TextFormField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a quantity';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (int.parse(value) < 0) {
                            return 'Quantity cannot be negative';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      DropdownButtonFormField<String>(
                        value: _getValidColorId(_selectedColorId),
                        decoration: InputDecoration(
                          labelText: 'Color',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                          ),
                        ),
                        items: _getUniqueColors().map((color) {
                          return DropdownMenuItem<String>(
                            value: color.id,
                            child: Text(color.displayLabel),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedColorId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a color';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      DropdownButtonFormField<String>(
                        value: _getValidMeasurementId(_selectedMeasurementId),
                        decoration: InputDecoration(
                          labelText: 'Measurement Unit',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                          ),
                        ),
                        items: _getUniqueMeasurements().map((measurement) {
                          return DropdownMenuItem<String>(
                            value: measurement.id,
                            child: Text(measurement.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMeasurementId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a measurement unit';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      if (_getUniqueSubCategories().isNotEmpty)
                        DropdownButtonFormField<String>(
                          value: _getValidSubCategoryId(_selectedSubCategoryId),
                          decoration: InputDecoration(
                            labelText: 'Subcategory (Optional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.02,
                              ),
                            ),
                          ),
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Text('None'),
                            ),
                            ..._getUniqueSubCategories().map((subCategory) {
                              return DropdownMenuItem<String>(
                                value: subCategory.id,
                                child: Text(subCategory.name),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedSubCategoryId = value;
                            });
                          },
                        ),
                      SizedBox(height: verticalPadding),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: verticalPadding,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                    SizedBox(width: screenWidth * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final product = Product.create(
                            id: widget.product?.id,
                            name: _nameController.text.trim(),
                            categoryId: _getCategoryId(),
                            subCategoryId: _selectedSubCategoryId,
                            quantity: int.parse(_quantityController.text),
                            price: double.parse(_priceController.text),
                            manualCost: _useProfitMargin
                                ? null
                                : (_manualCostController.text.isEmpty
                                      ? null
                                      : double.parse(
                                          _manualCostController.text,
                                        )),
                            profitMargin: _useProfitMargin
                                ? _profitMargin / 100.0
                                : 0.0,
                            barcode: _barcodeController.text.trim(),
                            secondaryBarcode:
                                _secondaryBarcodeController.text.trim().isEmpty
                                ? null
                                : _secondaryBarcodeController.text.trim(),
                            colorPresetId: _selectedColorId!,
                            measurementPresetId: _selectedMeasurementId!,
                          );

                          if (widget.product == null) {
                            testProducts.add(product);
                          } else {
                            final index = testProducts.indexWhere(
                              (p) => p.id == widget.product!.id,
                            );
                            if (index != -1) {
                              testProducts[index] = product;
                            }
                          }

                          Navigator.of(context).pop(product);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? Colors.green[700]
                            : Colors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.06,
                          vertical: screenHeight * 0.015,
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarcodeScannerPage extends StatefulWidget {
  const _BarcodeScannerPage();

  @override
  State<_BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<_BarcodeScannerPage> {
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
            Navigator.of(context).pop(barcodes.first.rawValue);
          }
        },
      ),
    );
  }
}
