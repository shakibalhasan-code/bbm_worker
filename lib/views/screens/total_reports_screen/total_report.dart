import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/tab_sub_screens/tab_upcoming_work.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/tab_sub_screens/tab_todays_work.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/tab_sub_screens/tab_waiting_work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../getx/user_data_controller.dart';

class TotalReport extends StatefulWidget {
  const TotalReport({super.key});

  @override
  State<TotalReport> createState() => _TotalReportState();
}


class _TotalReportState extends State<TotalReport> {

  final UserDataController _userDataController = Get.put(UserDataController());
  late String userCurrentEmail = '';

  @override
  void initState() {
    super.initState();
    // fetchUserAuth();
  }

  // void fetchUserAuth() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userCurrentEmail = prefs.getString('email') ?? '';
  //   if (userCurrentEmail.isNotEmpty) {
  //     await _userDataController.fetchOnTaskData(userCurrentEmail);
  //     await _userDataController.fetchTodayOnTaskData(userCurrentEmail);
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TabBar(
            labelColor: AppColors.appThemeColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.appThemeColor,
            tabs: [
              Tab(text: 'Today\'s Work'),
              Tab(text: 'Waiting'),
              Tab(text: 'Upcoming'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                TabTodaysWork(),
                TabWaitingWork(),
                TabUpcomingWork(),
              ],
            ),
          ),
        ],
      )
    );
  }
}


