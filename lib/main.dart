import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerl_ite/features/auth/data/firebase_message.dart';
import 'package:expense_trackerl_ite/features/auth/data/firebase_options.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_trackerl_ite/features/currency/presentation/bloc/currency_bloc.dart';
import 'package:expense_trackerl_ite/features/home_page/data/repository.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/bloc/transaction_bloc.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessage().setupFCM();
  tz.initializeTimeZones();
const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: androidSettings);
  await flutterLocalNotificationsPlugin.initialize(settings);

  // Register background task

  final transactionRepository = TransactionRepository(
    firestore: FirebaseFirestore.instance,
  );
  

  // Initialize the repository and other dependencies here if needed
  // For example, you might want to set up a user authentication service

  // Run the app

  runApp(MyApp(transactionRepository: transactionRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.transactionRepository});

  final TransactionRepository transactionRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(
          create: (context) => TransactionBloc(transactionRepository),
        ),
        BlocProvider(create: (context) => CurrencyBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}