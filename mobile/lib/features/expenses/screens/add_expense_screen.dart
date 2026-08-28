import 'package:flutter/material.dart';

import 'package:expense_tracker/features/expenses/widgets/add_expense_screen/add_expense_form.dart';

const _lightAddExpenseBackgroundColor = Color(0xFFF7ECFB);

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : _lightAddExpenseBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            22,
            16,
            0,
          ),
          child: AddExpenseForm(
            onSubmit: (expense) {
              Navigator.of(context).pop(expense);
            },
            onCancel: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}
