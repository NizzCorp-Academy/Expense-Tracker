import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/pages/welcome.dart';
import 'package:expense_trackerl_ite/features/currency/presentation/bloc/currency_bloc.dart';
import 'package:expense_trackerl_ite/features/currency/presentation/bloc/currency_event.dart';
import 'package:expense_trackerl_ite/features/currency/presentation/bloc/currency_state.dart';
import 'package:expense_trackerl_ite/features/home_page/data/transactionmodel.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/bloc/transaction_bloc.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/bloc/transaction_event.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/bloc/transaction_state.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/widgets/create_transactions.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/widgets/total_card.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/widgets/transactionwidget.dart';
import 'package:expense_trackerl_ite/features/local_noti/local_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 @override
  void initState() {
    super.initState();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    final today = DateTime.now();

    if (userId != null) {
      context.read<CurrencyBloc>().add(LoadCurrencyEvent());
      context.read<TransactionBloc>().add(
        CalculateIncomeAndExpense(uid: userId, date: today),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
          },
          icon: Icon(Icons.notifications),
        ),
        title: RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 20, color: Colors.black),
            children: [
              TextSpan(
                text: 'Expense Tracker ',
                style: GoogleFonts.poppins(
                  fontSize: 18,
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

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<CurrencyBloc, CurrencyState>(
              builder: (context, state) {
                if (state is CurrencyLoaded) {
                  return Center(
                    child: Text(
                      "Today's Currency Rate: \$ ${state.model.conversionRates!.iNR!.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 0, 11, 17),
                      ),
                    ),
                  );
                } else if (state is CurrencyLoading) {
                  return Center(child: const Text("Loading..."));
                } else {
                  return Center(child: const Text("Currency not loaded"));
                }
              },
            ),
            SizedBox(height: 630, child: TransactionList()),
           
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
                    child: BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, state) {
                        if (state is IncomeAndExpenseCalculated) {
                          return Totalcard(
                            data: 'Total Income',
                            amount: state.totalIncome,
                            type: TotalType.income,
                          );
                        }
                        return Totalcard(
                          data: 'Total Income',
                          amount: 0,
                          type: TotalType.income,
                        );
                      },
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
                                    print('Transaction added: $data');
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
                    child: BlocBuilder<TransactionBloc, TransactionState>(
                       builder: (context, state) {
            if (state is IncomeAndExpenseCalculated) {
              return Totalcard(
                data: 'Total Expense',
                amount: state.totalExpense,
                type: TotalType.expense,
              );
            }
                        return Totalcard(
                          data: 'Total Expense',
                          amount: 0,
                          type: TotalType.expense,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            FloatingActionButton(onPressed: () {
              
            },child: Icon(Icons.chat),)
          ],
        ),
        
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

void showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'Your channel description',
        importance: Importance.max,
        priority: Priority.high,
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    'Expense Reminder',
    'Expense Limit Reached',
    platformChannelSpecifics,
  );
}
