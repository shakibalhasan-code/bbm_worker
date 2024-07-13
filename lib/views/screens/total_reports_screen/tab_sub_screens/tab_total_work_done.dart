import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../getx/user_data_controller.dart';
import '../../../item/todays_work_item.dart';
import '../../../item/total_done_item.dart';

class TabTotalDoneWork extends StatelessWidget {
   TabTotalDoneWork({super.key});

  final UserDataController _userDataController = Get.put(UserDataController());


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                final onTotalDone = _userDataController.totalDoneList;
                if (onTotalDone.isEmpty) {
                  return const Center(child: Text('No Waiting Complaints found',style: TextStyle(color: Colors.white),));
                } else {
                  return ListView.builder(
                    itemCount: onTotalDone.length,
                    itemBuilder: (context, index) {
                      return TotalDoneWorkItem(totalDoneTaskModel: onTotalDone[index],); // Pass WaitingModel
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
