import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:bbm_worker/views/widgets/custom_button.dart';
import 'package:bbm_worker/views/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../getx/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final LoginController _loginController = Get.put(LoginController());

  bool _isObscured = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _resetEmailController = TextEditingController();
        return AlertDialog(
          title: const Text('Reset your password'),
          content: TextField(
            controller: _resetEmailController,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Implement password reset functionality here
                Get.back();
                Example: _loginController.resetPassword(_resetEmailController.text.trim());
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
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
              child: Obx(() => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/icon.png',fit: BoxFit.cover,))),
                  const SizedBox(height: 20,),
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
                      suffixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.email))),
                  const SizedBox(height: 5),
                  CustomTextField(
                    hintText: 'enter your password',
                    textEditingController: _passController,
                    obscureText: _isObscured,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      _loginController.login(
                        _emailController.text.trim(),
                        _passController.text.trim(),
                      );
                    },
                    child: const CustomThemeButton(buttonText: 'Login Now'),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _showResetPasswordDialog,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  if (_loginController.isLoading.value)
                    const SizedBox(height: 20),
                  if (_loginController.isLoading.value)
                    const CircularProgressIndicator(),
                ],
              )),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 20,
              child: InkWell(
                onTap: () {
                  Clipboard.setData(const ClipboardData(text: 'Emergency Call- +880 1323-898823'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:  Text('Text copied to clipboard!'),
                    ),
                  );
                },
                child: const Text(
                  'Emergency Call- +880 1323-898823',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
