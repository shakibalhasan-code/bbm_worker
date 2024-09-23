import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconButton suffixIcon;
  final TextEditingController textEditingController;
  final bool? obscureText;

  const CustomTextField({
    Key? key,
    required this.textEditingController,
    required this.hintText,
    required this.suffixIcon,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.appThemeColor.withOpacity(0.4)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 3),
          child: TextField(
            obscureText: obscureText!,
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              suffixIcon: suffixIcon,
              suffixIconColor: Colors.grey
            ),
          ),
        ),
      ),
    );
  }
}
