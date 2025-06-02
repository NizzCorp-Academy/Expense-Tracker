import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerl_ite/features/transaction_list/data/transactionmodel.dart';

class TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<TransactionModel>> getTransactionsStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TransactionModel.fromDocument(doc);
      }).toList();
    });
  }
}
