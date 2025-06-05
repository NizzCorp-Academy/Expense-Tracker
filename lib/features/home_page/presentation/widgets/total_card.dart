// Total Income/Expense Card
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum TotalType { income, expense }

class Totalcard extends StatelessWidget {
  final String data;
  final double amount;
  final TotalType type;

  const Totalcard({
    super.key,
    required this.data,
    required this.amount,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final EdgeInsets margin =
        type == TotalType.income
            ? const EdgeInsets.only(left: 8)
            : const EdgeInsets.only(right: 8);
    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      margin: margin,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          Text(
            amount.toStringAsFixed(1),
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}