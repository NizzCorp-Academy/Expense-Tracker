import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String category;
  final double amount;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
  });

  factory TransactionModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      category: data['category'],
      amount: data['amount'].toDouble(),
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
