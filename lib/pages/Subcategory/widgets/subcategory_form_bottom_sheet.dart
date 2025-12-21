import 'package:de_helper/providers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:de_helper/models/subcategory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubcategoryFormBottomSheet extends ConsumerStatefulWidget {
  final SubCategory? subcategory;

  const SubcategoryFormBottomSheet({super.key, this.subcategory});

  @override
  ConsumerState<SubcategoryFormBottomSheet> createState() =>
      _SubcategoryFormBottomSheetState();
}

class _SubcategoryFormBottomSheetState
    extends ConsumerState<SubcategoryFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedCategoryId;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    if (widget.subcategory != null) {
      _nameController.text = widget.subcategory!.name;
      _selectedCategoryId = widget.subcategory!.categoryId;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final viewInsets = mediaQuery.viewInsets;
    _isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = ref.watch(categoryProvider);

    String? getValidCategoryId() {
      String? candidateId;

      if (_selectedCategoryId != null) {
        candidateId = _selectedCategoryId;
      } else if (widget.subcategory != null) {
        candidateId = widget.subcategory!.categoryId;
      }

      if (candidateId == null) {
        return null;
      }

      final matchingCategories = categories.value!
          .where(
            (cat) => cat.id == candidateId,
          )
          .toList();

      if (matchingCategories.length == 1) {
        return candidateId;
      }

      if (_selectedCategoryId == candidateId && matchingCategories.isEmpty) {
        setState(() {
          _selectedCategoryId = null;
        });
      }

      return null;
    }

    void save() {
      if (_formKey.currentState!.validate()) {
        Navigator.of(context).pop({
          'name': _nameController.text.trim(),
          'categoryId': _selectedCategoryId,
        });
      }
    }

    void cancel() {
      Navigator.of(context).pop();
    }

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
                widget.subcategory == null
                    ? 'Add New Subcategory'
                    : 'Edit Subcategory',
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: _isDark ? Colors.white : Colors.grey[900],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Subcategory Name',
                  hintText: 'Enter subcategory name',
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
                    return 'Please enter a subcategory name';
                  }
                  if (value.trim().length < 2) {
                    return 'Subcategory name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              DropdownButtonFormField<String>(
                initialValue: getValidCategoryId(),
                decoration: InputDecoration(
                  labelText: 'Category',
                  hintText: 'Select a category',
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
                items: categories.value!.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.id,
                    child: Row(
                      children: [
                        Icon(
                          category.icon,
                          color: _isDark ? Colors.green[300] : Colors.blue,
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: _isDark ? Colors.white : Colors.grey[900],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: cancel,
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
                      onPressed: save,
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
