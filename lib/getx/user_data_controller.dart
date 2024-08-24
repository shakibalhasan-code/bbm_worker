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
  var doneList = <DoneTaskModel>[].obs;

  var todayWorkCount = 0.obs;
  var upcomingWorkCount = 0.obs;
  var waitingWorkCount = 0.obs;
  var reviewCount = 0.obs;

  Future<void> fetchTodayOnTaskData(String userEmail) async {
    final now = DateTime.now();
    final todayDate = DateFormat('dd-MM-yyyy').format(now);

    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(userEmail)
          .collection('upComing')
          .where('selectedDate', isEqualTo: todayDate)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('No tasks found for today ($todayDate) for $userEmail');
        onTaskList.value = [];
        todayWorkCount.value = 0;
      } else {
        final todayTasks = querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return OnTaskModel.fromFirestore(data, doc.id);
        }).toList();

        onTaskList.value = todayTasks;
        todayWorkCount.value = querySnapshot.docs.length;
      }
    } catch (e) {
      print('Error fetching today\'s tasks: $e');
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

  // Future<void> fetchDoneOnTaskData(String userEmail) async {
  //   try {
  //     // Fetch documents from 'doneComplaints' subcollection
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('workers')
  //         .doc(userEmail)
  //         .collection('doneComplaints')
  //         .get();
  //
  //     // Check if documents exist and map to DoneTaskModel
  //     if (querySnapshot.docs.isNotEmpty) {
  //       List<DoneTaskModel> tasks = querySnapshot.docs.map((doc) {
  //         var documentId = doc.id;
  //         var data = doc.data() as Map<String, dynamic>;
  //         return DoneTaskModel.fromFirestore(data, documentId);
  //       }).toList();
  //       doneList.value = tasks;
  //     } else {
  //       // No documents found, clear doneList
  //       print('No done documents found for $userEmail');
  //       doneList.value = [];
  //     }
  //   } catch (e) {
  //     print('Error fetching done onTask data: $e');
  //     // Handle error appropriately
  //   } finally {
  //     // Reset loading state if needed
  //   }
  // }

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

  Future<void> findAndUpdateMessage(
      String phoneNumber, String messageData, Map<String, dynamic> data) async {
    try {
      // Step 1: Query the sub-collection to find the document with the matching message
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(phoneNumber)
          .collection('workingComplaints')
          .where('message', isEqualTo: messageData)
          .get();

      // Step 2: Check if the document exists
      if (querySnapshot.docs.isNotEmpty) {
        // Assuming there's only one document that matches the criteria
        DocumentSnapshot doc = querySnapshot.docs.first;

        // Step 3: Get the document ID and update the document with the new string
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(phoneNumber)
            .collection('workingComplaints')
            .doc(doc.id)
            .update(data);

        print('Document updated successfully.');
      } else {
        print('No document found with the specified message.');
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }
}
