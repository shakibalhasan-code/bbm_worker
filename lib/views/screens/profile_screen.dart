import 'package:bbm_worker/getx/profile_controller.dart';
import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchWorkerData();
  }

  void _fetchWorkerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userCurrentEmail = prefs.getString('email') ?? '';
    if(userCurrentEmail.isNotEmpty){
      _profileController.fetchUserData(userCurrentEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Assuming dark theme
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.appThemeColor.withOpacity(0.4),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 20),
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
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            'https://st.depositphotos.com/34181562/60060/i/450/depositphotos_600606366-stock-photo-professional-engineer-black-women-working.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Inmur Rashid',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        'Junior Engineer',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      Text(
                        'inmur@gmail.com',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Divider(color: Colors.white, thickness: 1, endIndent: 1),
                      ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true, // Add shrinkWrap to make the ListView take only the required space
                        physics: NeverScrollableScrollPhysics(), // Disable the ListView's own scrolling
                        itemBuilder: (context, index) {
                          return ReviewsItem();
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
