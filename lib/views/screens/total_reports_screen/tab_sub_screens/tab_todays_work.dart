import 'package:bbm_worker/views/item/todays_work_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../getx/user_data_controller.dart';

class TabTodaysWork extends StatelessWidget {
   TabTodaysWork({super.key});
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
                final onTask = _userDataController.onTaskList;
                if (onTask.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: onTask.length,
                    itemBuilder: (context, index) {
                      return TodaysWorkItem(
                        ontask: onTask[index],
                        index: index,
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
