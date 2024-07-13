import 'package:bbm_worker/core/models/done_task_model.dart';
import 'package:bbm_worker/core/models/total_done.dart';
import 'package:bbm_worker/core/models/waiting_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/models/ontask_model.dart';

class UserDataController extends GetxController {
  var onTaskList = <OnTaskModel>[].obs;
  var onWaitingList = <WaitingModel>[].obs;
  var onDoneList = <DoneTaskModel>[].obs;
  var totalDoneList = <TotalDone>[].obs;



  Future<void> fetchOnTaskData(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(userEmail)
          .collection('onTask')
          .get();

      List<OnTaskModel> tasks = querySnapshot.docs
          .map((doc) => OnTaskModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();

      onTaskList.value = tasks;
    } catch (e) {
      print('Error fetching onTask data: $e');
    }
  }
  Future<void> fetchWaitingTaskData(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(userEmail)
          .collection('waitingTask')
          .get();

      List<WaitingModel> tasks = querySnapshot.docs
          .map((doc) => WaitingModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();

      onWaitingList.value = tasks;
    } catch (e) {
      print('Error fetching onTask data: $e');
    }
  }
  Future<void> fetchDoneTaskData(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(userEmail)
          .collection('doneTask')
          .get();

      List<DoneTaskModel> tasks = querySnapshot.docs
          .map((doc) => DoneTaskModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();

      onDoneList.value = tasks;
    } catch (e) {
      print('Error fetching onTask data: $e');
    }
  }
  Future<void> fetchTotalDoneTaskData(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(userEmail)
          .collection('totalDoneTask')
          .get();

      List<TotalDone> tasks = querySnapshot.docs
          .map((doc) => TotalDone.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();

      totalDoneList.value = tasks;
    } catch (e) {
      print('Error fetching onTask data: $e');
    }
  }

}
