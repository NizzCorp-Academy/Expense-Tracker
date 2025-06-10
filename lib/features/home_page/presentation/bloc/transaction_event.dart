import 'package:expense_trackerl_ite/features/home_page/data/transactionmodel.dart';

abstract class TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final TransactionModel transaction;
  AddTransaction(this.transaction);
}

class LoadTransactions extends TransactionEvent {
  final String uid;
  final List<String>? filterCategories; 
  final DateTime? selectedDate;

  LoadTransactions({
    required this.uid,
    this.filterCategories,
    this.selectedDate,
  });
}

class TransactionsUpdated extends TransactionEvent {
  final List<TransactionModel> transactions;
  TransactionsUpdated(this.transactions);
}

class DeleteTransaction extends TransactionEvent {
  final String transactionId;
  DeleteTransaction(this.transactionId);
}

class CalculateIncomeAndExpense extends TransactionEvent {
  final String uid;
  final DateTime date;

  CalculateIncomeAndExpense({required this.uid, required this.date});
}
