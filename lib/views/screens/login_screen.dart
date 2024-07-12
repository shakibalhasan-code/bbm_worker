import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:bbm_worker/views/screens/tab_screen.dart';
import 'package:bbm_worker/views/widgets/custom_button.dart';
import 'package:bbm_worker/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appThemeColor.withOpacity(0.3),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const Text(
                    'Please login with your existing email and password',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                      hintText: 'enter your email',
                      textEditingController: _emailController,
                      icon: Icons.mail),
                  const SizedBox(height: 5),
                  CustomTextField(
                      hintText: 'enter your password',
                      textEditingController: _passController,
                      icon: Icons.key),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: (){
                      Get.offAll(const TabScreen());
                    },
                      child: const CustomThemeButton(buttonText: 'Login Now'))
                ],
              ),
            ),
            const Positioned(
                right: 0,
                left: 0,
                bottom: 20,
                child: Text(
                  'Emergency Call- 0123456789',textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ))
          ],
        ),
      ),
    );
  }
}
