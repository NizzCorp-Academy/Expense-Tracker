import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const TransactionForm({super.key, required this.onSubmit});

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  double _amount = 0.0;
  String _notes = '';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isIncome = true;

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final data = {
        'title': _title,
        'amount': _amount,
        'notes': _notes,
        'isIncome': _isIncome,
        'date': DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
      };

      widget.onSubmit(data);
      Navigator.of(context).pop(); // Close dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Transaction'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (val) => _title = val ?? '',
                validator: (val) => val!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onSaved: (val) =>
                    _amount = double.tryParse(val ?? '') ?? 0.0,
                validator: (val) => val!.isEmpty ? 'Enter amount' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                onSaved: (val) => _notes = val ?? '',
              ),
              Row(
                children: [
                  Text('Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
                  TextButton(onPressed: _pickDate, child: Text('Select')),
                ],
              ),
              Row(
                children: [
                  Text('Time: ${_selectedTime.format(context)}'),
                  TextButton(onPressed: _pickTime, child: Text('Select')),
                ],
              ),
              SwitchListTile(
                title: Text(_isIncome ? 'Income' : 'Expense'),
                value: _isIncome,
                onChanged: (val) => setState(() => _isIncome = val),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: Text('Add')),
      ],
    );
  }
}
