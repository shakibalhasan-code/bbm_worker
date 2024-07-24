import 'dart:ffi';
import 'package:bbm_worker/core/models/done_task_model.dart';
import 'package:bbm_worker/core/models/upcomming_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../core/models/ontask_model.dart';
import '../core/models/waiting_model.dart';

class UserDataController extends GetxController {
  var onTaskList = <OnTaskModel>[].obs;
  var waitingList = <WaitingModel>[].obs;
  var upcomingList = <UpcommingModel>[].obs;

  var todayWorkCount = 0.obs;
  var upcomingWorkCount = 0.obs;
  var waitingWorkCount = 0.obs;
  var reviewCount = 0.obs;

  Future<void> fetchTodayOnTaskData(String userEmail) async {
    final now = DateTime.now();
    final docId = DateFormat('dd-MM-yyyy').format(now);

    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(userEmail)
          .collection('upComing')
          .doc(docId)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        final task = OnTaskModel.fromFirestore(data, documentSnapshot.id);
        onTaskList.value = [task];
        todayWorkCount.value = 1; // Since it's fetching today's work by specific date
      } else {
        print('Document not found for $userEmail on $docId');
        onTaskList.value = [];
        todayWorkCount.value = 0;
      }
    } catch (e) {
      print('Error fetching onTask data: $e');
      rethrow;
    }
  }

  Future<void> fetchUpcomingOnTaskData(String userEmail) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(userEmail)
          .collection('upComing')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No upcoming tasks found for $userEmail');
        upcomingList.value = [];
        upcomingWorkCount.value = 0;
        return;
      }

      final upcomingTasks = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return UpcommingModel.fromFirestore(data, doc.id);
      }).toList();

      upcomingList.value = upcomingTasks;
      upcomingWorkCount.value = querySnapshot.docs.length;
    } catch (e) {
      print('Error fetching upcoming tasks: $e');
      rethrow;
    }
  }

  Future<void> fetchWaitingOnTaskData(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(userEmail)
          .collection('complaints')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<WaitingModel> tasks = querySnapshot.docs.map((doc) {
          var documentId = doc.id;
          var data = doc.data() as Map<String, dynamic>;
          return WaitingModel.fromFirestore(data, documentId);
        }).toList();
        waitingList.value = tasks;
        waitingWorkCount.value = querySnapshot.docs.length;
      } else {
        print('No documents found for $userEmail');
        waitingList.value = [];
        waitingWorkCount.value = 0;
      }
    } catch (e) {
      print('Error fetching onTask data: $e');
      rethrow;
    }
  }

  Future<void> removeWaitingTask(String userEmail, String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(userEmail)
          .collection('complaints')
          .doc(documentId)
          .delete();
      await fetchWaitingOnTaskData(userEmail);
    } catch (e) {
      print('Error removing task: $e');
      rethrow;
    }
  }

  Future<void> fetchReviewData(String userEmail) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(userEmail)
          .collection('review')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        reviewCount.value = querySnapshot.docs.length;
      } else {
        print('No reviews found for $userEmail');
        reviewCount.value = 0;
      }
    } catch (e) {
      print('Error fetching review data: $e');
      rethrow;
    }
  }
}
