import 'package:flutter/material.dart';

const _actionColor = Color(0xFF6A3CB5);
const _lightAddExpenseBackgroundColor = Color(0xFFF7ECFB);

class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.selectedDate,
    required this.hasTriedToSubmit,
    required this.onSelected,
  });

  final DateTime? selectedDate;
  final bool hasTriedToSubmit;
  final ValueChanged<DateTime> onSelected;

  Future<void> _selectDate(
    BuildContext context,
    FormFieldState<DateTime> field,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? today,
      firstDate: DateTime(1),
      lastDate: today,
      builder: (context, child) {
        final theme = Theme.of(context);
        final pickerSurfaceColor = theme.brightness == Brightness.dark
            ? theme.colorScheme.surface
            : _lightAddExpenseBackgroundColor;
        final pickerColorScheme = theme.colorScheme.copyWith(
          primary: _actionColor,
          onPrimary: Colors.white,
          surface: pickerSurfaceColor,
        );

        return Theme(
          data:
              ThemeData.from(
                colorScheme: pickerColorScheme,
                useMaterial3: false,
              ).copyWith(
                dialogTheme: theme.dialogTheme.copyWith(
                  backgroundColor: pickerSurfaceColor,
                ),
              ),
          child: child!,
        );
      },
    );

    if (!context.mounted || date == null) {
      return;
    }

    onSelected(date);
    field.didChange(date);
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return FormField<DateTime>(
      autovalidateMode: hasTriedToSubmit
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      validator: (value) {
        if (value == null) {
          return 'Date is required';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _selectDate(context, field),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        selectedDate == null
                            ? 'No date selected'
                            : _formatDate(selectedDate!),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.calendar_month,
                      color: textColor,
                      size: 24,
                    ),
                  ],
                ),
              ),
            ),
            if (field.errorText != null)
              Text(
                field.errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
          ],
        );
      },
    );
  }
}
