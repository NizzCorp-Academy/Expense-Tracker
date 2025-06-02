import 'package:expense_trackerl_ite/features/transaction_list/data/repository.dart';
import 'package:expense_trackerl_ite/features/transaction_list/data/transactionmodel.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final String userId;
  final TransactionRepository repository;

  const TransactionList({
    super.key,
    required this.userId,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TransactionModel>>(
      stream: repository.getTransactionsStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final transactions = snapshot.data ?? [];

        if (transactions.isEmpty) {
          return const Center(child: Text('No transactions found.'));
        }

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return ListTile(
              leading: const Icon(Icons.attach_money),
              title: Text(tx.category),
              subtitle: Text('${tx.date.toLocal()}'),
              trailing: Text(
                '\$${tx.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
    );
  }
}
