import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:bbm_worker/views/screens/attendence_screen.dart';
import 'package:bbm_worker/views/screens/home_screen.dart';
import 'package:bbm_worker/views/screens/profile_screen.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/total_report.dart';
import 'package:flutter/material.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {

   List<Widget> screens = const [
    HomeScreen(),
    TotalReport(),
    AttendenceScreen(),
    ProfileScreen()
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BBM Engineers'),
        backgroundColor: AppColors.appThemeColor,
        titleTextStyle: const TextStyle(fontSize: 20,color: Colors.white),
      ),
      backgroundColor: AppColors.appThemeColor.withOpacity(0.3),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.appThemeColor,
        unselectedItemColor: AppColors.appThemeColor.withOpacity(0.2),
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Reports', icon: Icon(Icons.report)),
          BottomNavigationBarItem(
              label: 'Attendance', icon: Icon(Icons.done_all_rounded)),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
