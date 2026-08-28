import 'package:flutter/material.dart';

import 'package:expense_tracker/features/expenses/models/expense.dart';
import 'package:expense_tracker/features/expenses/widgets/expense_item.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return ExpenseItem(
          expense: expenses[index],
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 15);
      },
    );
  }
}
