import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:flutter/material.dart';

class CustomThemeButton extends StatelessWidget {
  final String buttonText;
  const CustomThemeButton({super.key, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.appThemeColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(buttonText,textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
        ),
      ),
    );
  }
}
