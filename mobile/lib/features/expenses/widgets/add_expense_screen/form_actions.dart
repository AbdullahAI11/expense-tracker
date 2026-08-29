import 'package:flutter/material.dart';

const _saveButtonColor = Color(0xFFDDC8FA);
const _actionColor = Color(0xFF6A3CB5);

class FormActions extends StatelessWidget {
  const FormActions({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  final VoidCallback onCancel;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            foregroundColor: _actionColor,
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 6),
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: _saveButtonColor,
            foregroundColor: _actionColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
          ),
          child: const Text(
            'Save Expense',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
