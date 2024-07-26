import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../getx/user_data_controller.dart';
import '../../../item/todays_work_item.dart';

class TabTodaysWork extends StatefulWidget {
  TabTodaysWork({super.key});

  @override
  State<TabTodaysWork> createState() => _TabTodaysWorkState();
}

class _TabTodaysWorkState extends State<TabTodaysWork> {
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
      await _userDataController.fetchTodayOnTaskData(userCurrentEmail);
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
                final onTask = _userDataController.onTaskList;
                if (onTask.isEmpty) {
                  return const Center(
                    child: Text('Maybe no work', style: TextStyle(color: Colors.white)),
                  );
                } else {
                  return ListView.builder(
                    itemCount: onTask.length,
                    itemBuilder: (context, index) {
                      return TodaysWorkItem(
                        onTaskModel: onTask[index],
                        workerEmail: userCurrentEmail,
                      );
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
