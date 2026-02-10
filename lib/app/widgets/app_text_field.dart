import 'package:flutter/material.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: appColor.primaryColor,
        selectionColor: appColor.primaryColor.withOpacity(0.3),
        selectionHandleColor: appColor.primaryColor,
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: appColor.primaryColor,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,

        // ✅ Keep text input working but disable copy/paste menu
        enableInteractiveSelection: true,
        contextMenuBuilder: (context, editableTextState) {
          return const SizedBox.shrink(); // only hides context menu
        },

        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: Colors.grey)
              : null,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(
              color: appColor.primaryColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
      ),
    );
  }
}
