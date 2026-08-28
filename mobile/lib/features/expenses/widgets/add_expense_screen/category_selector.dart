import 'package:flutter/material.dart';

const _lightAddExpenseBackgroundColor = Color(0xFFF7ECFB);

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  static const _categories = ['food', 'travel', 'leisure', 'work'];

  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 120,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        offset: const Offset(0, 40),
        color: isDark
            ? Theme.of(context).colorScheme.surface
            : _lightAddExpenseBackgroundColor,
        onSelected: onSelected,
        itemBuilder: (context) {
          return _categories.map((category) {
            return PopupMenuItem<String>(
              value: category,
              child: Text(
                category.toUpperCase(),
                style: TextStyle(color: textColor),
              ),
            );
          }).toList();
        },
        child: Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: textColor.withValues(alpha: 0.18),
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                selectedCategory.toUpperCase(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.arrow_drop_down,
                color: textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
