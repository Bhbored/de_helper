import 'package:de_helper/providers/color_provider.dart';
import 'package:de_helper/providers/measurement_provider.dart';
import 'package:de_helper/providers/product_provider.dart';
import 'package:de_helper/providers/subcategory_provider.dart';
import 'package:de_helper/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:de_helper/models/product.dart';
import 'package:de_helper/models/category.dart';
import 'package:de_helper/models/subcategory.dart';

class ProductFormBottomSheet extends ConsumerStatefulWidget {
  final Category? category;
  final SubCategory? subCategory;
  final Product? product;

  const ProductFormBottomSheet({
    super.key,
    this.category,
    this.subCategory,
    this.product,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductFormBottomSheetState();
}

class _ProductFormBottomSheetState
    extends ConsumerState<ProductFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _manualCostController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _secondaryBarcodeController = TextEditingController();
  final _quantityController = TextEditingController();

  String? _selectedColorId;
  String? _selectedMeasurementId;
  String? _selectedCategoryId;
  String? _selectedSubCategoryId;
  double _profitMargin = 0.0;
  bool _useProfitMargin = false;

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      _selectedCategoryId = widget.product!.categoryId;
    } else if (widget.subCategory != null) {
      _selectedCategoryId = widget.subCategory!.categoryId;
    } else if (widget.category != null) {
      _selectedCategoryId = widget.category!.id;
    }

    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _barcodeController.text = widget.product!.barcode;
      _secondaryBarcodeController.text = widget.product!.secondaryBarcode ?? '';
      _quantityController.text = widget.product!.quantity.toString();
      _profitMargin = widget.product!.profitMargin * 100.0;
      _useProfitMargin = widget.product!.manualCost == null;
      if (widget.product!.manualCost != null) {
        _manualCostController.text = widget.product!.manualCost!.toString();
      }
      _selectedColorId = widget.product!.colorPresetId;
      _selectedMeasurementId = widget.product!.measurementPresetId;
      _selectedSubCategoryId = widget.product!.subCategoryId;
    } else {
      _selectedSubCategoryId = null;
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
    if (_selectedCategoryId != null) {
      return _selectedCategoryId!;
    }
    if (widget.subCategory != null) {
      return widget.subCategory!.categoryId;
    }
    if (widget.category != null) {
      return widget.category!.id;
    }

    return '';
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
    final categories = ref.watch(categoryProvider);
    final subcategories = ref.watch(subcategoryProvider);
    final colors = ref.watch(colorProvider);
    final measurements = ref.watch(measurementProvider);

    // Get NULL color and measurement IDs for initial values
    String? nullColorId;
    if (colors.value != null && colors.value!.isNotEmpty) {
      try {
        nullColorId = colors.value!
            .firstWhere((color) => color.name == 'NULL')
            .id;
      } catch (e) {
        nullColorId = colors.value!.first.id;
      }
    }

    String? nullMeasurementId;
    if (measurements.value != null && measurements.value!.isNotEmpty) {
      try {
        nullMeasurementId = measurements.value!
            .firstWhere((measurement) => measurement.name == 'NULL')
            .id;
      } catch (e) {
        nullMeasurementId = measurements.value!.first.id;
      }
    }

    final availableSubcategories =
        subcategories.value
            ?.where((x) => x.categoryId == _getCategoryId())
            .toList() ??
        [];

    final showCategoryDropdown = widget.subCategory == null;

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
                      if (showCategoryDropdown)
                        DropdownButtonFormField<String>(
                          initialValue:
                              categories.value?.any(
                                    (category) =>
                                        category.id == _selectedCategoryId,
                                  ) ==
                                  true
                              ? _selectedCategoryId
                              : null,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.02,
                              ),
                            ),
                          ),
                          items:
                              categories.value?.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category.id,
                                  child: Text(category.name),
                                );
                              }).toList() ??
                              [],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;

                              _selectedSubCategoryId = null;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        ),
                      if (showCategoryDropdown)
                        SizedBox(height: screenHeight * 0.02),
                      DropdownButtonFormField<String>(
                        initialValue: widget.product != null
                            ? (colors.value?.any(
                                        (color) => color.id == _selectedColorId,
                                      ) ==
                                      true
                                  ? _selectedColorId
                                  : null)
                            : nullColorId,
                        decoration: InputDecoration(
                          labelText: 'Color',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                          ),
                        ),
                        items:
                            colors.value?.map((color) {
                              return DropdownMenuItem<String>(
                                value: color.id,
                                child: Text(color.displayLabel),
                              );
                            }).toList() ??
                            [],
                        onChanged: (value) {
                          setState(() {
                            _selectedColorId = value ?? nullColorId;
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
                        initialValue: widget.product != null
                            ? (measurements.value?.any(
                                        (measurement) =>
                                            measurement.id ==
                                            _selectedMeasurementId,
                                      ) ==
                                      true
                                  ? _selectedMeasurementId
                                  : null)
                            : nullMeasurementId,
                        decoration: InputDecoration(
                          labelText: 'Measurement Unit',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                          ),
                        ),
                        items:
                            measurements.value?.map((measurement) {
                              return DropdownMenuItem<String>(
                                value: measurement.id,
                                child: Text(measurement.name),
                              );
                            }).toList() ??
                            [],
                        onChanged: (value) {
                          setState(() {
                            _selectedMeasurementId = value ?? nullMeasurementId;
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
                      if (availableSubcategories.isNotEmpty)
                        DropdownButtonFormField<String>(
                          initialValue:
                              _selectedSubCategoryId == null ||
                                  availableSubcategories.any(
                                    (subCategory) =>
                                        subCategory.id ==
                                        _selectedSubCategoryId,
                                  )
                              ? _selectedSubCategoryId
                              : null,
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
                            ...availableSubcategories.map((subCategory) {
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
                          String? validatedSubCategoryId =
                              _selectedSubCategoryId;
                          if (_selectedSubCategoryId != null) {
                            final subcategories = ref.read(subcategoryProvider);
                            if (subcategories.value != null) {
                              final categoryId = _getCategoryId();
                              final subcategoryBelongsToCategory = subcategories
                                  .value!
                                  .any(
                                    (sub) =>
                                        sub.id == _selectedSubCategoryId &&
                                        sub.categoryId == categoryId,
                                  );

                              if (!subcategoryBelongsToCategory) {
                                validatedSubCategoryId = null;
                              }
                            } else {
                              validatedSubCategoryId = null;
                            }
                          }

                          final product = Product.create(
                            id: widget.product?.id,
                            name: _nameController.text.trim(),
                            categoryId: _getCategoryId(),
                            subCategoryId: validatedSubCategoryId,
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
                            ref
                                .read(prodcutProvider.notifier)
                                .addProduct(product);
                          } else {
                            ref
                                .read(prodcutProvider.notifier)
                                .updateProduct(product);
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
