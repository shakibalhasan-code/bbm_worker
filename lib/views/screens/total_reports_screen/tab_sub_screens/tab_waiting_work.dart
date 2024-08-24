import 'package:bbm_worker/views/item/on_waiting_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../getx/user_data_controller.dart';

class TabWaitingWork extends StatefulWidget {
  @override
  State<TabWaitingWork> createState() => _TabWaitingWorkState();
}

class _TabWaitingWorkState extends State<TabWaitingWork> {
  final UserDataController _userDataController = Get.put(UserDataController());
  late String userCurrentEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userCurrentEmail = prefs.getString('email') ?? '';
    });
    if (userCurrentEmail.isNotEmpty) {
      _userDataController.fetchWaitingOnTaskData(userCurrentEmail);
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
                final WaitingModel = _userDataController.waitingList;
                if (WaitingModel.isEmpty) {
                  return const Center(
                    child: Text('No Waiting Complaints found', style: TextStyle(color: Colors.white)),
                  );
                } else {
                  return ListView.builder(
                    itemCount: WaitingModel.length,
                    itemBuilder: (context, index) {
                      return WaitingWorkItem(
                        waitingModel: WaitingModel[index],
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
