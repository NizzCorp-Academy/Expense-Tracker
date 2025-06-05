import 'dart:async';

import 'package:expense_trackerl_ite/features/home_page/data/repository.dart';
import 'package:expense_trackerl_ite/features/home_page/data/transactionmodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;
  StreamSubscription<List<TransactionModel>>? _subscription;

  TransactionBloc(this.repository) : super(TransactionInitial()) {
    on<AddTransaction>((event, emit) async {
      try {
        await repository.addTransaction(event.transaction);
        emit(TransactionAdded());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });




    on<LoadTransactions>((event, emit) async {
      emit(TransactionLoading());

      try {
        final initialData = await repository.getInitialTransactions(event.uid);
        final filteredInitial = _filterTransactions(
          initialData,
          event.filterCategories,
          event.selectedDate,
        );

        emit(TransactionLoaded(filteredInitial));

        await _subscription?.cancel();

        _subscription = repository.watchTransactions(event.uid).listen((txs) {
          final filtered = _filterTransactions(
            txs,
            event.filterCategories,
            event.selectedDate,
          );
          add(TransactionsUpdated(filtered));
        });
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<TransactionsUpdated>((event, emit) {
      emit(TransactionLoaded(event.transactions));
    });
  }

  List<TransactionModel> _filterTransactions(
    List<TransactionModel> transactions,
    List<String>? filterCategories,
    DateTime? selectedDate,
  ) {
    if ((filterCategories == null || filterCategories.isEmpty) && selectedDate == null) {
      return transactions;
    }

    return transactions.where((tx) {
      final matchesCategory = filterCategories == null || filterCategories.isEmpty || filterCategories.contains('All') ||
          (tx.isIncome && filterCategories.contains('Income')) ||
          (!tx.isIncome && filterCategories.contains('Expense'));

      final matchesDate = selectedDate == null ||
          (tx.date.year == selectedDate.year &&
           tx.date.month == selectedDate.month &&
           tx.date.day == selectedDate.day);

      return matchesCategory && matchesDate;
    }).toList();
  }
}
