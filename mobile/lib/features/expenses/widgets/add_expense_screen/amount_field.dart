import 'package:flutter/material.dart';

import 'package:expense_tracker/features/expenses/widgets/add_expense_screen/formatters/money_input_formatter.dart';

class AmountField extends StatefulWidget {
  const AmountField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hasTriedToSubmit,
    required this.validator,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasTriedToSubmit;
  final FormFieldValidator<String> validator;

  @override
  State<AmountField> createState() => _AmountFieldState();
}

class _AmountFieldState extends State<AmountField> {
  final _moneyInputFormatter = MoneyInputFormatter();

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant AmountField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChange);
      widget.focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) {
        FocusScope.of(context).unfocus();
      },
      inputFormatters: [_moneyInputFormatter],
      autovalidateMode: widget.hasTriedToSubmit
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      validator: widget.validator,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: 'Amount',
        prefixText: widget.focusNode.hasFocus ? r'SAR ' : null,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: textColor,
          fontSize: 25,
          fontWeight: FontWeight.w500,
        ),
        prefixStyle: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: textColor.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}
