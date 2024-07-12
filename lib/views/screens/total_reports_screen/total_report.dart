import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/tab_sub_screens/tab_done_work.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/tab_sub_screens/tab_todays_work.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/tab_sub_screens/tab_total_work_done.dart';
import 'package:bbm_worker/views/screens/total_reports_screen/tab_sub_screens/tab_waiting_work.dart';
import 'package:flutter/material.dart';

class TotalReport extends StatelessWidget {
  const TotalReport({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
              Tab(text: 'Done'),
              Tab(text: 'Total Work Done'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                TabTodaysWork(),
                TabWaitingWork(),
                TabDoneWork(),
                TabTotalDoneWork()
              ],
            ),
          ),
        ],
      )
    );
  }
}


