import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/tab_sub_screens/tab_done_work.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/tab_sub_screens/tab_upcoming_work.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/tab_sub_screens/tab_todays_work.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/tab_sub_screens/tab_waiting_work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../getx/user_data_controller.dart';

class TotalReport extends StatefulWidget {
  final int indexPage;
final bool showTool;
  const TotalReport({super.key, required this.indexPage, required this.showTool});

  @override
  State<TotalReport> createState() => _TotalReportState();
}

class _TotalReportState extends State<TotalReport>
    with SingleTickerProviderStateMixin {
  final UserDataController _userDataController = Get.put(UserDataController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.indexPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appThemeColor.withOpacity(0.2),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.showTool ? Row(children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back,color: Colors.white,),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text('Complaints',style: TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.bold),)
            ]): const SizedBox(),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.appThemeColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.appThemeColor,
              tabs: const [
                Tab(text: 'Today\'s Work'),
                Tab(text: 'Waiting'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Done'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TabTodaysWork(),
                  TabWaitingWork(),
                  TabUpcomingWork(),
                  TabDoneWork(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
