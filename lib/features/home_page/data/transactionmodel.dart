import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String title;
  final double amount;
  final String notes;
  final bool isIncome;
  final DateTime date;
  final String uid;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.notes,
    required this.isIncome,
    required this.date,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'notes': notes,
      'isIncome': isIncome,
      'date': date,
      'uid': uid,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      notes: map['notes'],
      isIncome: map['isIncome'],
      date: (map['date'] as Timestamp).toDate(),
      uid: map['uid'],
    );
  }
}
