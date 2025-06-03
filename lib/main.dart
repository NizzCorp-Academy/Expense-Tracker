import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerl_ite/features/auth/data/firebase_message.dart';
import 'package:expense_trackerl_ite/features/auth/data/firebase_options.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/pages/welcome.dart';
import 'package:expense_trackerl_ite/features/home_page/data/repository.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/bloc/transaction_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Firbase_Message().initNotifications();

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const Welcome(title: ""),
      ),
    );
  }
}