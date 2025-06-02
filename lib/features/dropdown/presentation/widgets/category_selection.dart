import 'package:flutter/material.dart';
// This widget is used to select categories for a transaction from a list of available categories.
Future<void> _showCategoryDialog(BuildContext context, List<String> expense) async {
  List<String> selectedCategories = [];

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Select Categories'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: expense.length,
                itemBuilder: (context, index) {
                  final category = expense[index];
                  final isSelected = selectedCategories.contains(category);
                  return CheckboxListTile(
                    title: Text(category),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedCategories.add(category);
                        } else {
                          selectedCategories.remove(category);
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
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(selectedCategories);
                },
                child: Text('Select'),
              ),
            ],
          );
        },
      );
    },
  ).then((selected) {
    if (selected != null && selected is List<String>) {
      // Handle the selected categories
      print('Selected categories: $selected');
    }
  });
}