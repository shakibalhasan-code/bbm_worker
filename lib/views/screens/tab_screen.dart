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
  int currentIndex = 0;

  final List<Widget> screens = [];

  @override
  void initState() {
    super.initState();
    screens.addAll([
      HomeScreen(
        card1Pressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TotalReport(indexPage: 0,showTool: true,),
            ),
          );
        },
        card2Pressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TotalReport(indexPage: 2,showTool: true),
            ),
          );
        },
        card3Pressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TotalReport(indexPage: 1,showTool: true),
            ),
          );
        },
        card4Pressed: () {
          changeIndex(1);
        },
      ),
      const TotalReport(indexPage: 0,showTool: false),
      const AttendenceScreen(),
      const ProfileScreen(),
    ]);
  }

  void changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BBM Engineers'),
        backgroundColor: AppColors.appThemeColor,
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
      ),
      backgroundColor: AppColors.appThemeColor.withOpacity(0.3),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.appThemeColor,
        unselectedItemColor: AppColors.appThemeColor.withOpacity(0.2),
        currentIndex: currentIndex,
        onTap: (index) {
          changeIndex(index);
        },
        items: const [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Complaints', icon: Icon(Icons.info)),
          BottomNavigationBarItem(label: 'Attendance', icon: Icon(Icons.done_all_rounded)),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
