import 'package:flutter/material.dart';

import 'package:expense_tracker/features/expenses/models/expense.dart';
import 'package:expense_tracker/features/expenses/widgets/add_expense_screen/amount_field.dart';
import 'package:expense_tracker/features/expenses/widgets/add_expense_screen/category_selector.dart';
import 'package:expense_tracker/features/expenses/widgets/add_expense_screen/date_field.dart';
import 'package:expense_tracker/features/expenses/widgets/add_expense_screen/form_actions.dart';
import 'package:expense_tracker/features/expenses/widgets/add_expense_screen/title_field.dart';

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  final Future<void> Function(Expense) onSubmit;
  final VoidCallback onCancel;

  @override
  State<AddExpenseForm> createState() => _AddExpenseFormState();
}

class _AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();

  bool _hasTriedToSubmit = false;
  bool _isSubmitting = false;
  DateTime? _selectedDate;
  String _selectedCategory = 'leisure';

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    final title = value?.trim() ?? '';

    if (title.isEmpty) {
      return 'Title is required';
    }

    if (title.length > 50) {
      return 'Title must be 50 characters or fewer';
    }

    return null;
  }

  String? _validateAmount(String? value) {
    final amountText = value?.trim() ?? '';

    if (amountText.isEmpty) {
      return 'Amount is required';
    }

    final amount = double.tryParse(amountText);
    if (amount == null || !amount.isFinite) {
      return 'Enter a valid amount';
    }

    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }

    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _hasTriedToSubmit = true;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final expense = Expense(
      title: _titleController.text.trim(),
      amount: double.parse(_amountController.text),
      date: _selectedDate!,
      category: _selectedCategory,
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(expense);
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleField(
            controller: _titleController,
            amountFocusNode: _amountFocusNode,
            hasTriedToSubmit: _hasTriedToSubmit,
            validator: _validateTitle,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 5,
                child: AmountField(
                  controller: _amountController,
                  focusNode: _amountFocusNode,
                  hasTriedToSubmit: _hasTriedToSubmit,
                  validator: _validateAmount,
                ),
              ),
              const SizedBox(width: 36),
              Expanded(
                flex: 4,
                child: DateField(
                  selectedDate: _selectedDate,
                  hasTriedToSubmit: _hasTriedToSubmit,
                  onSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CategorySelector(
                selectedCategory: _selectedCategory,
                onSelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),
              const Spacer(),
              FormActions(
                onCancel: widget.onCancel,
                onSave: _isSubmitting ? null : _submit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
