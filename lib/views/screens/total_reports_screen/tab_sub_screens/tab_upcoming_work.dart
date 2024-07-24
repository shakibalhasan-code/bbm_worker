import 'package:bbm_worker/views/item/upcoming_task_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../getx/user_data_controller.dart';
import '../../../item/todays_work_item.dart';

class TabUpcomingWork extends StatefulWidget {
  TabUpcomingWork({super.key});

  @override
  State<TabUpcomingWork> createState() => _TabUpcomingWorkState();
}

class _TabUpcomingWorkState extends State<TabUpcomingWork> {
  final UserDataController _userDataController = Get.put(UserDataController());
  late String userCurrentEmail='';

  @override
  void initState() {
    super.initState();
    fetchUserAuth();
  }

  void fetchUserAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userCurrentEmail = prefs.getString('email') ?? '';
    if (userCurrentEmail.isNotEmpty) {
      await _userDataController.fetchUpcomingOnTaskData(userCurrentEmail);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final onDone = _userDataController.upcomingList;
                if (onDone.isEmpty) {
                  return const Center(child: Text('No Upcoming Complaints found',style: TextStyle(color: Colors.white),));
                } else {
                  return ListView.builder(
                    itemCount: onDone.length,
                    itemBuilder: (context, index) {
                      return UpCommingTask(upcommingModel: onDone[index]); // Pass WaitingModel
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
