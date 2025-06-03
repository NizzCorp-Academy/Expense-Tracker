import 'package:expense_trackerl_ite/features/home_page/data/transactionmodel.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionAdded extends TransactionState {}

class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionModel> transactions;
  final List<String>? activeFilters;
  final DateTime? selectedDate;

  TransactionLoaded(
    this.transactions, {
    this.activeFilters,
    this.selectedDate,
  });
}
