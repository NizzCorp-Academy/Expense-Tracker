import 'package:flutter/material.dart';

class CategorySelectionDialog extends StatefulWidget {
  final List<String> expense;

  const CategorySelectionDialog({super.key, required this.expense});

  @override
  State<CategorySelectionDialog> createState() => _CategorySelectionDialogState();
}

class _CategorySelectionDialogState extends State<CategorySelectionDialog> {
  final List<String> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Categories'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.expense.length,
          itemBuilder: (context, index) {
            final category = widget.expense[index];
            final isSelected = _selectedCategories.contains(category);
            return CheckboxListTile(
              title: Text(category),
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedCategories.add(category);
                  } else {
                    _selectedCategories.remove(category);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // Cancel
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedCategories); // Return selection
          },
          child: const Text('Select'),
        ),
      ],
    );
  }
}
