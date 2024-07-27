import 'package:bbm_worker/core/models/reiview_model.dart';
import 'package:bbm_worker/getx/profile_controller.dart';
import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../item/reviews_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = ProfileController();
  late String userCurrentEmail = '';
  List<ReviewModel> reviewList = [];

  @override
  void initState() {
    super.initState();
    _fetchWorkerData();
  }

  void _fetchWorkerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userCurrentEmail = prefs.getString('email') ?? '';
    if (userCurrentEmail.isNotEmpty) {
      _profileController.fetchUserData(userCurrentEmail);
    }
  }

  Future<List<ReviewModel>> fetchReviews() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('workers')
        .doc(userCurrentEmail)
        .collection('reviews')
        .get();

    return querySnapshot.docs
        .map((doc) => ReviewModel.fromFirestore(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Assuming dark theme
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.appThemeColor.withOpacity(0.4),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
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
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(() {
                        if (_profileController.user.value.imageUrl.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: _profileController.user.value.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          );
                        }
                      }),
                      const SizedBox(height: 5),
                      Obx(() {
                        return Text(
                          _profileController.user.value.fullName,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        );
                      }),
                      Obx(() {
                        return Text(
                          _profileController.user.value.role,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        );
                      }),
                      Obx(() {
                        return Text(
                          _profileController.user.value.email,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        );
                      }),
                      const SizedBox(height: 5),
                      Divider(color: Colors.white, thickness: 1, endIndent: 1),
                      FutureBuilder<List<ReviewModel>>(
                        future: fetchReviews(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Something went wrong',style: TextStyle(color: Colors.grey),));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No reviews found',style: TextStyle(color: Colors.grey)));
                          } else {
                            final reviews = snapshot.data!;
                            return ListView.builder(
                              itemCount: reviews.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ReviewsItem(reviewModel: reviews[index]);
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
