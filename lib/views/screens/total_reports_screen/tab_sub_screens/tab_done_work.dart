import 'package:bbm_worker/views/item/done_task_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../getx/user_data_controller.dart';
import '../../../item/todays_work_item.dart';

class TabDoneWork extends StatelessWidget {
   TabDoneWork({super.key});

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
                final onDone = _userDataController.onDoneList;
                if (onDone.isEmpty) {
                  return const Center(child: Text('No Waiting Complaints found',style: TextStyle(color: Colors.white),));
                } else {
                  return ListView.builder(
                    itemCount: onDone.length,
                    itemBuilder: (context, index) {
                      return DoneWorkItem(doneTaskModel: onDone[index]); // Pass WaitingModel
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
