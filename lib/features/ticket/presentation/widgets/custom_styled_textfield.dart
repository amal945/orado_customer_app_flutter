// custom_styled_textfield.dart

import 'package:flutter/material.dart';
import 'package:orado_customer/utilities/colors.dart';
import 'package:orado_customer/utilities/styles.dart';

class CustomStyledTextField extends StatefulWidget {
  const CustomStyledTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;

  @override
  State<CustomStyledTextField> createState() => _CustomStyledTextFieldState();
}

class _CustomStyledTextFieldState extends State<CustomStyledTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    // trigger rebuild for suffix icon / counter
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle:
            AppStyles.getBoldTextStyle(fontSize: 14, color: Colors.black38),
            filled: true,
            fillColor: Colors.white,
            counterText: '', // hide default counter
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: AppColors.baseColor.withOpacity(0.7), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: AppColors.baseColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? IconButton(
              splashRadius: 20,
              icon: const Icon(Icons.close),
              onPressed: () {
                widget.controller.clear();
                widget.onChanged?.call('');
                setState(() {});
              },
            )
                : null,
          ),
        ),
        if (widget.maxLength != null)
          Positioned(
            right: 12,
            bottom: 4,
            child: Text(
              '${widget.controller.text.length}/${widget.maxLength}',
              style: AppStyles.getBoldTextStyle(
                  fontSize: 10, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
