import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerl_ite/features/home_page/data/transactionmodel.dart';

class TransactionRepository {
  final FirebaseFirestore firestore;

  TransactionRepository({required this.firestore});

  Future<void> addTransaction(TransactionModel tx) async {
    await firestore.collection('transactions').add(tx.toMap());
  }

  Stream<List<TransactionModel>> getTransactionsByUser(String uid) {
    return firestore
        .collection('transactions')
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data()))
            .toList());
  }

  Future<List<TransactionModel>> getInitialTransactions(String uid) async {
    final snapshot = await firestore
        .collection('transactions')
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TransactionModel.fromMap(doc.data()))
        .toList();
  }

  // Stream real-time updates for the specific user's transactions
  Stream<List<TransactionModel>> watchTransactions(String uid) {
    return firestore
        .collection('transactions')
        .where('uid', isEqualTo: uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TransactionModel.fromMap(doc.data()))
            .toList());
  }
}