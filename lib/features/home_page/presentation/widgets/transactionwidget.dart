import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerl_ite/features/home_page/data/repository.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/bloc/transaction_bloc.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/bloc/transaction_event.dart';
import 'package:expense_trackerl_ite/features/home_page/presentation/bloc/transaction_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late TransactionBloc _bloc;
  List<String> _selectedCategories = ['All'];

  final List<String> _allCategories = ['All', 'Income', 'Expense'];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    final repo = TransactionRepository(firestore: FirebaseFirestore.instance);
    _bloc = TransactionBloc(repo);
    if (user != null) {
      _bloc.add(
        LoadTransactions(
          uid: user.uid,
          filterCategories: _selectedCategories,
          selectedDate: null,
        ),
      );
    }
  }

 void _onChipTapped(String category) {
  setState(() {
    _selectedCategories = [category]; 
  });

  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    _bloc.add(
      LoadTransactions(
        uid: user.uid,
        filterCategories: _selectedCategories,
        selectedDate: null,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Column(
        children: [
          // Category FilterChips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children:
                  _allCategories.map((cat) {
                    final isSelected = _selectedCategories.contains(cat);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (_) => _onChipTapped(cat),
                        selectedColor: Colors.blueAccent,
                        checkmarkColor: Colors.white,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),

          Expanded(
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
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final tx = state.transactions[index];
                      return Container(
                        decoration: BoxDecoration(
                          color:
                              tx.isIncome ? Colors.green : Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(left: 10),
                          child: ListTile(
                            title: Text(
                              tx.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(tx.notes),
                            trailing: Text(
                              "₹${tx.amount.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
          ),
        ],
      ),
    );
  }
}
