import 'package:bbm_worker/views/screens/login_screen.dart';
import 'package:bbm_worker/views/screens/tab_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Connectivity _connectivity = Connectivity();

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await Future.delayed(const Duration(seconds: 2)); // Wait for 2 seconds
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    if (email != null) {
      // Check if the email exists in Firestore
      DocumentSnapshot workerSnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(email)
          .get();

      if (workerSnapshot.exists) {
        // Email found in Firestore
        Get.offAll(const TabScreen());
      } else {
        // Email not found in Firestore
        Get.offAll(const LoginScreen());
      }
    } else {
      // No email saved in SharedPreferences
      Get.offAll(const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/icon.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20,),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
