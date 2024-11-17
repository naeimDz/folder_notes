import 'package:flutter/material.dart';

/// A modern, reusable text field widget with built-in label, hint, and suffix support.
Widget buildModernTextField(
  BuildContext context, {
  required String label,
  required String hint,
  String? initialValue,
  Widget? suffix,
  int maxLines = 1,
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
  void Function(String?)? onFieldSubmitted,
  void Function()? onEditingComplete,
  FocusNode? focusNode,
  bool isPassword = false,
}) {
  print("object///////////////////*****************");
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete ??
            () => FocusScope.of(context)
                .nextFocus(), // Dismiss the keyboard after the user is done

        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    ],
  );
}
