import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController textEditingController;
  const CustomTextField({super.key, required this.hintText, required this.textEditingController, required this.icon});

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
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              suffixIcon: Icon(icon),
              suffixIconColor: Colors.grey
            ),
          ),
        ),
      ),
    );
  }
}
