import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class PrimaryTextFormField extends StatelessWidget {
  PrimaryTextFormField(
      {super.key,
      required this.hintText,
      this.keyboardType,
      required this.controller,
      required this.width,
      required this.height,
      this.hintTextColor,
      this.onChanged,
      this.onTapOutside,
      this.prefixIcon,
      this.prefixIconColor,
      this.inputFormatters,
      this.maxLines,
      this.borderRadius,
      this.isDarkMode,
      required this.validator});
  final BorderRadiusGeometry? borderRadius;

  final String hintText;

  final List<TextInputFormatter>? inputFormatters;
  Widget? prefixIcon;
  Function(PointerDownEvent)? onTapOutside;
  final Function(String)? onChanged;
  final double width, height;
  TextEditingController controller;
  final Color? hintTextColor, prefixIconColor;
  final TextInputType? keyboardType;
  final int? maxLines;
  // ignore: prefer_typing_uninitialized_variables
  final isDarkMode;
  final String validator;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        //set error border
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 5),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            // Border when selected
            borderSide:
                BorderSide(color: Color.fromARGB(255, 219, 219, 219), width: 2),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          hintText: hintText,
          prefixIcon: prefixIcon,
          prefixIconColor: prefixIconColor,
          // Adjust fill color as needed
        ),
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        onTapOutside: onTapOutside,
        validator: (value) => value!.isEmpty ? validator : null,
      ),
    );
  }
}
