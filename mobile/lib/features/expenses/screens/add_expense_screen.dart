import 'package:flutter/material.dart';

import 'package:expense_tracker/features/expenses/state/expenses_controller.dart';
import 'package:expense_tracker/features/expenses/widgets/add_expense_screen/add_expense_form.dart';

const _lightAddExpenseBackgroundColor = Color(0xFFF7ECFB);

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({
    super.key,
    required this.expensesController,
  });

  final ExpensesController expensesController;

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
            onSubmit: (expense) async {
              try {
                await expensesController.createExpense(
                  title: expense.title,
                  amount: expense.amount,
                  expenseDate: expense.date,
                  categoryCode: expense.category,
                );

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } catch (_) {
                if (!context.mounted) {
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Unable to create expense. Please try again.',
                    ),
                  ),
                );
              }
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
