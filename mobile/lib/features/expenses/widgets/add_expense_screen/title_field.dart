import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:expense_tracker/features/expenses/widgets/add_expense_screen/formatters/initial_capitalization_formatter.dart';

class TitleField extends StatefulWidget {
  const TitleField({
    super.key,
    required this.controller,
    required this.amountFocusNode,
    required this.hasTriedToSubmit,
    required this.validator,
  });

  final TextEditingController controller;
  final FocusNode amountFocusNode;
  final bool hasTriedToSubmit;
  final FormFieldValidator<String> validator;

  @override
  State<TitleField> createState() => _TitleFieldState();
}

class _TitleFieldState extends State<TitleField> {
  final _capitalizationFormatter = InitialCapitalizationFormatter();

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return TextFormField(
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      controller: widget.controller,
      maxLength: 50,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(widget.amountFocusNode);
      },
      inputFormatters: [_capitalizationFormatter],
      autovalidateMode: widget.hasTriedToSubmit
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      validator: widget.validator,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: 'Title',
        hintText: 'e.g. Lunch',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyle(
          color: textColor,
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.65),
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
