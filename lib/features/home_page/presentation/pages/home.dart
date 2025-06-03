import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/pages/welcome.dart';
import 'package:expense_trackerl_ite/features/home_page/data/transactionmodel.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/bloc/transaction_bloc.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/bloc/transaction_event.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/widgets/create_transactions.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/widgets/transactionwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _pickDate(dynamic today) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(today.year, today.month, today.day),
    );
    if (picked != null) {
      // Handle the picked date
      print('Date selected: $picked');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 24, color: Colors.black),
            children: [
              TextSpan(
                text: 'Expense Tracker ',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 11, 17),
                ),
              ),
              TextSpan(
                text: 'Lite',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 19, 125, 178),
                ),
              ),
            ],
          ),
        ),

        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  logoutDialog(context);
                },
                child: Image.asset(
                  'assets/exp_logo.png',
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 250),
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(12),
                        icon: Row(
                          children: [
                            const Text(
                              'Filter',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        items:
                            <String>['Category', 'Date'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (value) async {
                          if (value == 'Category') {
                            await _showCategoryDialog(context, []);
                          } else {
                            _pickDate(DateTime.now());
                          }
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                SizedBox(
                  height: 550,
                  child: TransactionList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 130,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 23, 201, 3),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Totalcard(
                          data: 'Total Income',
                          amount: 100,
                          type: TotalType.income,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(Icons.add, color: Colors.blue),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => TransactionForm(
                                      onSubmit: (data) {
                                        final tx = TransactionModel(
                                          title: data['title'],
                                          amount: data['amount'],
                                          notes: data['notes'],
                                          isIncome: data['isIncome'],
                                          date: data['date'],
                                          uid: data['uid'],
                                        );

                                        context.read<TransactionBloc>().add(
                                          AddTransaction(tx),
                                        );
                                        Navigator.of(context).pop();
                                        print( 'Transaction added: $data');
                                      },
                                    ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 130,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 63, 81, 181),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Totalcard(
                          data: 'Total Expense',
                          amount: 80,
                          type: TotalType.expense,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Total Income/Expense Card
enum TotalType { income, expense }

class Totalcard extends StatelessWidget {
  final String data;
  final double amount;
  final TotalType type;

  const Totalcard({
    super.key,
    required this.data,
    required this.amount,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final EdgeInsets margin =
        type == TotalType.income
            ? const EdgeInsets.only(left: 8)
            : const EdgeInsets.only(right: 8);
    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      margin: margin,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          Text(
            amount.toStringAsFixed(1),
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Logout pop-up dialog
void logoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Welcome(title: "")),
              );
            },
            child: Text('Logout'),
          ),
        ],
      );
    },
  );
}

// Category selection dialog
Future<void> _showCategoryDialog(
  BuildContext context,
  List<String> expense,
) async {
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
                itemCount: 3,
                itemBuilder: (context, index) {
                  final category = ['All','Income','Expense'][index];
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
                onPressed: () => Navigator.of(context).pop(), 
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
