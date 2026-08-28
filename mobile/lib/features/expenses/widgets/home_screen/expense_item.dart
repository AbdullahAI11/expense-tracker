import 'package:flutter/material.dart';

import 'package:expense_tracker/features/expenses/models/expense.dart';

const _lightExpenseColor = Color(0xFFDCC7F5);
const _darkExpenseColor = Color(0xFF24515A);

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isDark
        ? _darkExpenseColor
        : _lightExpenseColor;

    final Color primaryTextColor = isDark ? Colors.white : Colors.black87;

    final Color secondaryTextColor = isDark ? Colors.white70 : Colors.black54;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expense.title,
            style: TextStyle(
              color: primaryTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${expense.amount.toStringAsFixed(2)} SAR',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Icon(
                _categoryIcon(expense.category),
                color: primaryTextColor,
                size: 17,
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(expense.date),
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.lunch_dining;
      case 'leisure':
        return Icons.movie;
      case 'travel':
        return Icons.flight_takeoff;
      case 'work':
        return Icons.work;
      default:
        return Icons.category_outlined;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
