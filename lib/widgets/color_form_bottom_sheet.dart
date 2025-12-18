import 'package:flutter/material.dart';
import 'package:de_helper/models/color_preset.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorFormBottomSheet extends StatefulWidget {
  final ColorPreset? colorPreset;

  const ColorFormBottomSheet({super.key, this.colorPreset});

  @override
  State<ColorFormBottomSheet> createState() => _ColorFormBottomSheetState();
}

class _ColorFormBottomSheetState extends State<ColorFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _useHexColor = false;
  Color _selectedColor = Colors.black;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    if (widget.colorPreset != null) {
      if (widget.colorPreset!.hexCode != null) {
        _useHexColor = true;
        _selectedColor = _hexToColor(widget.colorPreset!.hexCode!);
      } else {
        _nameController.text = widget.colorPreset!.name ?? '';
      }
    }
  }

  @override
  void didUpdateWidget(ColorFormBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.colorPreset != null &&
        widget.colorPreset?.id != oldWidget.colorPreset?.id) {
      if (widget.colorPreset!.hexCode != null) {
        _useHexColor = true;
        _selectedColor = _hexToColor(widget.colorPreset!.hexCode!);
        _nameController.text = '';
      } else {
        _useHexColor = false;
        _nameController.text = widget.colorPreset!.name ?? '';
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    }
    return Colors.black;
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (_useHexColor) {
        Navigator.of(context).pop({
          'hexCode': _colorToHex(_selectedColor),
        });
      } else {
        if (_nameController.text.trim().isNotEmpty) {
          Navigator.of(context).pop({
            'name': _nameController.text.trim(),
          });
        }
      }
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final viewInsets = mediaQuery.viewInsets;
    _isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: _isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(screenWidth * 0.06),
          topRight: Radius.circular(screenWidth * 0.06),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          top: screenHeight * 0.02,
          bottom: viewInsets.bottom + screenHeight * 0.02,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: screenWidth * 0.1,
                height: 4,
                margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                decoration: BoxDecoration(
                  color: _isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                widget.colorPreset == null
                    ? 'Add New Color'
                    : 'Edit Color',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: _isDark ? Colors.white : Colors.grey[900],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: _isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: _useHexColor,
                    onChanged: (value) {
                      setState(() {
                        _useHexColor = value;
                        if (value) {
                          _nameController.clear();
                        } else {
                          _selectedColor = Colors.black;
                        }
                      });
                    },
                  ),
                  Text(
                    'Hex Color',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: _isDark ? Colors.white : Colors.grey[900],
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              if (!_useHexColor)
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Color Name',
                    hintText: 'Enter color name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    ),
                    filled: true,
                    fillColor: _isDark ? Colors.grey[800] : Colors.grey[100],
                  ),
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: _isDark ? Colors.white : Colors.grey[900],
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a color name';
                    }
                    if (value.trim().length < 2) {
                      return 'Color name must be at least 2 characters';
                    }
                    return null;
                  },
                )
              else
                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.3,
                      decoration: BoxDecoration(
                        color: _isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      child: BlockPicker(
                        pickerColor: _selectedColor,
                        onColorChanged: (color) {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.03),
                      decoration: BoxDecoration(
                        color: _isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                            decoration: BoxDecoration(
                              color: _selectedColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _isDark ? Colors.grey[600]! : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Text(
                            _colorToHex(_selectedColor),
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: _isDark ? Colors.white : Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancel,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        side: BorderSide(
                          color: _isDark
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: _isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        backgroundColor: _isDark
                            ? Colors.green[700]!
                            : Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

