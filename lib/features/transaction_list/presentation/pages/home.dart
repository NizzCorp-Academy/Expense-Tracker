import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/pages/welcome.dart';
import 'package:expense_trackerl_ite/features/transaction_list/presentation/pages/create_transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                      icon: Row(
                        children: [
                          const Text(
                            'Filter',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          // const Icon(Icons.menu, color: Colors.grey),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      items:
                          <String>['Income', 'Expense'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              SizedBox(height: 550, child: ListCard()),

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
                              builder: (context) => TransactionForm(
                                onSubmit: (data) {
                                  // Handle the submitted data
                                  print(data);
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

// Income or Expense List Card

final List<String> expense = ['Food', 'Grocery', 'Travel'];
final List<String> income = ['Salary', 'Freelance', 'Investments'];
final List<String> amount = ['100', '900', '5000'];

class ListCard extends StatelessWidget {
  const ListCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          color: Colors.indigo,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.only(left: 10),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(income[index]), Text(amount[index])],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: income.length,
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
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Welcome(title: ""),
              ));
            },
            child: Text('Logout'),
          ),
        ],
      );
    },
    );
  }