import 'package:bbm_worker/views/item/done-task_item.dart';
import 'package:bbm_worker/views/item/upcoming_task_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/models/done_task_model.dart';
import '../../../../getx/user_data_controller.dart';
import '../../../item/todays_work_item.dart';

class TabDoneWork extends StatefulWidget {
  TabDoneWork({super.key});

  @override
  State<TabDoneWork> createState() => _TabUpcomingWorkState();
}

class _TabUpcomingWorkState extends State<TabDoneWork> {
  final UserDataController _userDataController = Get.put(UserDataController());
  late String userCurrentEmail = '';
  List<DoneTaskModel> doneTaskModel = [];

  @override
  void initState() {
    super.initState();
    fetchUserAuth();
  }

  void fetchUserAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userCurrentEmail = prefs.getString('email') ?? '';
    if (userCurrentEmail.isNotEmpty) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(userCurrentEmail)
          .collection('reviews')
          .get();

      setState(() {
        doneTaskModel = querySnapshot.docs
            .map((doc) =>
                DoneTaskModel.fromFirestore(doc.data() as Map<String, dynamic>))
            .toList();
      });
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
                child: ListView.builder(
                    itemCount: doneTaskModel.length,
                    itemBuilder: (conext, index) {
                      return DoneTaskItem(doneTaskModel: doneTaskModel[index]);
                    })),
          ],
        ),
      ),
    );
  }
}
