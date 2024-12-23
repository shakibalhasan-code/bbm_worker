import 'package:bbm_worker/core/models/reiview_model.dart';
import 'package:bbm_worker/getx/profile_controller.dart';
import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:bbm_worker/views/item/reviews_item.dart';
import 'package:bbm_worker/views/screens/login_screen.dart';
import 'package:bbm_worker/views/widgets/custom_button.dart';
import 'package:bbm_worker/views/widgets/custom_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = ProfileController();
  late String userCurrentEmail = '';
  double averageRating = 0.0;
  int totalReviews = 0;
  List<ReviewModel> reviewModel = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkerData();
  }

  void _fetchWorkerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userCurrentEmail = prefs.getString('email') ?? '';

    if (userCurrentEmail.isNotEmpty) {
      await _profileController.fetchUserData(userCurrentEmail);
      await fetchReviews();
      await fetchAllReviews();
      setState(() {}); // Update the UI after data fetch
    } else {
      print('Error: userCurrentEmail is empty, cannot fetch reviews');
    }
  }

  Future<void> fetchAllReviews() async {
    if (userCurrentEmail.isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(userCurrentEmail)
          .collection('doneComplaints')
          .get();

      setState(() {
        reviewModel = querySnapshot.docs
            .map((doc) =>
                ReviewModel.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList();
        print(reviewModel);
      });
    }
  }

  Future<void> fetchReviews() async {
    print('Fetching reviews for email: $userCurrentEmail');

    if (userCurrentEmail.isEmpty) {
      print('Error: userCurrentEmail is empty, cannot fetch reviews');
      return;
    }

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('workers')
        .doc(userCurrentEmail)
        .collection('reviews')
        .get();

    totalReviews = querySnapshot.docs.length;

    double sum = 0.0;
    for (var doc in querySnapshot.docs) {
      double rating = (doc.data()['rating'] ?? 0).toDouble();
      sum += rating;
    }

    if (totalReviews > 0) {
      averageRating = sum / totalReviews;
    } else {
      averageRating = 0.0;
    }
  }

  Future<void> resetPassword() async {
    if (userCurrentEmail.isNotEmpty) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: userCurrentEmail);
        Get.snackbar(
            'Success',
            snackPosition: SnackPosition.BOTTOM,
            'We have sent you a reset email to your $userCurrentEmail');
        print('Password reset email sent successfully!');
      } catch (e) {
        print('Error sending password reset email: $e');
        Get.snackbar(
            'Error',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            'We are unable to process your request $userCurrentEmail');
      }
    } else {
      Get.snackbar(
          'Error: ',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          'User email is empty, please try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.appThemeColor.withOpacity(0.4),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: AppColors.appThemeColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (_profileController.user.value.imageUrl == null) {
                          return const Center(
                            child: Icon(Icons
                                .error), // Show error icon if imageUrl is null
                          );
                        } else {
                          return SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl:
                                    _profileController.user.value.imageUrl,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                  child: Icon(Icons.error),
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                      const SizedBox(height: 5),
                      Obx(() {
                        return Text(
                          _profileController.user.value.fullName,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        );
                      }),
                      Obx(() {
                        return Text(
                          _profileController.user.value.role,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        );
                      }),
                      Obx(() {
                        return Text(
                          _profileController.user.value.email,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        );
                      }),
                      const SizedBox(height: 5),
                      // Review section
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.yellow, size: 20),
                            const SizedBox(width: 5),
                            Text(
                              averageRating.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '($totalReviews)',
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // You can add a section here to display individual reviews if needed
              // Flexible(
              //   child: ListView.builder(
              //     itemCount: reviewModel.length,
              //     itemBuilder: (context, index) {
              //       return ReviewItem(doneTaskModel: reviewModel[index]);
              //     },
              //   ),
              // ),

              Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                                onPressed: () async {
                                  await resetPassword();
                                },
                                child: const Text('Change Password'))),
                      ),
                      InkWell(
                          onTap: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.remove('phoneNumber');

                            // Navigate to the login screen and remove all previous screens from the stack
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const CustomThemeButton(buttonText: 'Logout')),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
