// transaction_list.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerl_ite/features/home_page/data/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("Please log in"));
    }

    return BlocProvider(
      create: (_) {
        final repo = TransactionRepository(firestore: FirebaseFirestore.instance);
        final bloc = TransactionBloc(repo);
        bloc.add(LoadTransactions(
          uid: user.uid,
          filterCategories: ['All'], 
          selectedDate: null, 
        ));
        return bloc;
      },
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text("No transactions found"));
            }
            return ListView.separated(
  itemCount: state.transactions.length,
  separatorBuilder: (context, index) => const SizedBox(height: 10),
  itemBuilder: (context, index) {
    final tx = state.transactions[index];
    return Container(
      decoration: BoxDecoration(
        color:  tx.isIncome ? Colors.green : Colors.indigoAccent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.only(left: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 10),
        child: ListTile(

          title: Text(tx.title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black87),
          ),
          subtitle: Text(tx.notes),
          trailing: Text(
            "₹${tx.amount.toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  },
);

          } else if (state is TransactionError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
