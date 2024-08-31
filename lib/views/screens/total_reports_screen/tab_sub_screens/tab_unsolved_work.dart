import 'package:bbm_worker/core/models/unsolved_model.dart';
import 'package:bbm_worker/views/item/done-task_item.dart';
import 'package:bbm_worker/views/item/unsolved_item.dart';
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

class TabUnsolvedWork extends StatefulWidget {
  TabUnsolvedWork({super.key});

  @override
  State<TabUnsolvedWork> createState() => _TabUpcomingWorkState();
}

class _TabUpcomingWorkState extends State<TabUnsolvedWork> {
  late String userCurrentEmail = '';
  List<UnsolvedModel> tabUnsolvedWork = [];

  @override
  void initState() {
    super.initState();
    fetchUserAuth();
  }

  void fetchUserAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userCurrentEmail = prefs.getString('email') ?? '';
    if (userCurrentEmail.isNotEmpty) {
      // Get a reference to the collection within the specific worker document
      CollectionReference unsolvedRef = FirebaseFirestore.instance
          .collection('workers')
          .doc(userCurrentEmail)
          .collection('unsolved');

      // Stream or await the results of the query
      await unsolvedRef.get().then((querySnapshot) {
        setState(() {
          tabUnsolvedWork = querySnapshot.docs
              .map((doc) => UnsolvedModel.fromFirestore(doc.data() as Map<String, dynamic>))
              .toList();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: tabUnsolvedWork.length,
                  itemBuilder: (conext, index) {
                    return UnsolvedItem(unsolvedModel: tabUnsolvedWork[index]);
                  })),
        ],
      ),
    );
  }
}