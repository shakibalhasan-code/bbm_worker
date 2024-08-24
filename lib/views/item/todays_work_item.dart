import 'package:bbm_worker/core/models/worker.dart';
import 'package:bbm_worker/getx/profile_controller.dart';
import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/ontask_model.dart';
import '../../getx/user_data_controller.dart';

class TodaysWorkItem extends StatefulWidget {
  final OnTaskModel onTaskModel;
  final String workerEmail;

  const TodaysWorkItem({
    super.key,
    required this.onTaskModel,
    required this.workerEmail,
  });

  @override
  _TodaysWorkItemState createState() => _TodaysWorkItemState();
}

class _TodaysWorkItemState extends State<TodaysWorkItem> {
  String _selectedDate = 'Not set';
  String _selectedTime = 'Not set';
  String _todayTime = 'Not set';
  final ProfileController _profileController = ProfileController();
  late String currentEmail;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController customerReviewController =
      TextEditingController();
  final UserDataController _userDataController = Get.find<UserDataController>();
  bool isLoading = false;
  bool doneIsLoading = false;

  // Future<void> _selectDate(BuildContext context) async {
  //   final now = DateTime.now();
  //   final docId = DateFormat('yyyy-MM-dd').format(now);
  //   _selectedDate = docId;
  // }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentEmail = prefs.getString('email') ?? '';
    if (currentEmail.isNotEmpty) {
      _profileController.fetchUserData(currentEmail);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked.format(context);
      });
    }
  }

  void _showPopupMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0),
      items: const [
        PopupMenuItem(
          value: 'done',
          child: Text('Mark as done'),
        ),
        PopupMenuItem(
          value: 'changeDate',
          child: Text('Change Schedule'),
        ),
        PopupMenuItem(
          value: 'call',
          child: Text('Call to customer'),
        ),
      ],
    ).then((value) {
      if (value == 'done') {
        _selectDate(context).then((_) {
          _showDoneNoteDialog(context);
        });
      } else if (value == 'call') {
        // Implement call functionality here
        // Implement call functionality here
        FlutterPhoneDirectCaller.callNumber(widget.onTaskModel.phoneNumber);
      } else if (value == 'changeDate') {
        _selectDate(context).then((_) {
          _selectTime(context).then((_) {
            if (_selectedDate.isNotEmpty && _selectedTime.isNotEmpty) {
              _showEditNoteDialog(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please Select a date '),
                ),
              );
            }
          });
        });
      }
    });
  }

  Future<String?> _showEditNoteDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Note'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            hintText: 'Enter note...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              final note = noteController.text.trim();
              if (note.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a note'),
                  ),
                );
                return; // Don't pop if empty
              } else {
                final newScheduleData = {
                  'selectedDate': _selectedDate,
                  'selectedTime': _selectedTime,
                  'changedNote': noteController.text,
                };
                await _userDataController.findAndUpdateMessage(
                    widget.onTaskModel.phoneNumber,
                    widget.onTaskModel.message,
                    newScheduleData);
                await _saveDataToWorker();
                isLoading = false;
                Navigator.pop(context);
              }
            },
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<String?> _showDoneNoteDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finished Note'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            hintText: 'note...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              doneIsLoading = true;
              final note = noteController.text.trim();
              if (note.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a note'),
                  ),
                );
                return; // Don't pop if empty
              } else {
                setState(() async {
                  await _storeDataToFirestore();
                  await _deleteDataFromWorker();
                });
                Navigator.pop(context);
                doneIsLoading = false;
              }
            },
            child: doneIsLoading
                ? const CircularProgressIndicator()
                : const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDataFromWorker() async {
    try {
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.workerEmail)
          .collection('upComing')
          .doc(widget.onTaskModel.documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task successfully deleted'),
        ),
      );
      setState(() {
        _userDataController.fetchUpcomingOnTaskData(widget.workerEmail);
      });
    } catch (e) {
      print('${widget.onTaskModel.documentId} Error deleting task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete task: $e'),
        ),
      );
    }
  }

  Future<void> _saveDataToWorker() async {
    final data = {
      'address': widget.onTaskModel.address,
      'fullName': widget.onTaskModel.fullName,
      'message': widget.onTaskModel.message,
      'phoneNumber': widget.onTaskModel.phoneNumber,
      'productCode': widget.onTaskModel.productCode,
      'productImage': widget.onTaskModel.productImage,
      'productName': widget.onTaskModel.productName,
      'update': widget.onTaskModel.update,
      'issueCategory': widget.onTaskModel.type,
      'selectedDate': _selectedDate,
      'selectedTime': _selectedTime,
      'ticketId': widget.onTaskModel.ticketId
    };

    try {
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.workerEmail)
          .collection('upComing')
          .add(data);

      // await FirebaseFirestore.instance
      //     .collection('customers')
      //     .doc(widget.onTaskModel.phoneNumber)
      //     .collection('complaints')
      //     .doc(widget.onTaskModel.documentId)
      //     .update(
      //     {'selectedDate': _selectedDate, 'selectedTime': _selectedTime});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully Saved'),
        ),
      );
      setState(() {
        _userDataController.fetchUpcomingOnTaskData(widget.workerEmail);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _storeDataToFirestore() async {
    final reportsData = {
      'workerName': _profileController.user.value.fullName,
      'workerEmail': _profileController.user.value.email,
      'workerPhone': _profileController.user.value.phone,
      'workerImage': _profileController.user.value.imageUrl,
      'customerName': widget.onTaskModel.fullName,
      'customerPhone': widget.onTaskModel.phoneNumber,
      'productImage': widget.onTaskModel.productImage,
      'productCode': widget.onTaskModel.productCode,
      'address': widget.onTaskModel.address,
      'ticketId': widget.onTaskModel.ticketId
    };

    final today = DateTime.now();
    final formattedDate =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final selectedDateDoc =
        FirebaseFirestore.instance.collection('reports').doc(formattedDate);

    // Add reports data
    await selectedDateDoc.collection(widget.workerEmail).add(reportsData);

    // Update subcollection tracking document
    await selectedDateDoc.set({
      'subcollections': FieldValue.arrayUnion([widget.workerEmail])
    }, SetOptions(merge: true));

    final data = {
      'address': widget.onTaskModel.address,
      'fullName': widget.onTaskModel.fullName,
      'message': widget.onTaskModel.message,
      'phoneNumber': widget.onTaskModel.phoneNumber,
      'productCode': widget.onTaskModel.productCode,
      'productImage': widget.onTaskModel.productImage,
      'productName': widget.onTaskModel.productName,
      'update': widget.onTaskModel.update,
      'type': widget.onTaskModel.type,
      'selectedDate': _selectedDate,
      'ticketId': widget.onTaskModel.ticketId
    };

    final cdata = {
      'address': widget.onTaskModel.address,
      'fullName': widget.onTaskModel.fullName,
      'message': widget.onTaskModel.message,
      'phoneNumber': widget.onTaskModel.phoneNumber,
      'productCode': widget.onTaskModel.productCode,
      'productImage': widget.onTaskModel.productImage,
      'productName': widget.onTaskModel.productName,
      'update': 'true',
      'type': widget.onTaskModel.type,
      'endedDate': _selectedDate,
      'workerName': _profileController.user.value.fullName,
      'workerPhone': _profileController.user.value.phone,
      'workerImage': _profileController.user.value.imageUrl,
      'workerRole': _profileController.user.value.role,
      'workerEmail': _profileController.user.value.email,
      'ticketId': widget.onTaskModel.ticketId
    };

    // final now = DateTime.now();
    // final docId = DateFormat('yyyy-MM-dd').format(now);

    try {
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.workerEmail)
          .collection('doneComplaints')
          .add(data);

      await FirebaseFirestore.instance.collection('complaintsDone').add(cdata);

      await FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.onTaskModel.phoneNumber)
          .collection('workingComplaints')
          .doc(widget.onTaskModel.selectedDate)
          .delete();

      await FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.onTaskModel.phoneNumber)
          .collection('doneComplaints')
          .add(cdata);

      await FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.onTaskModel.phoneNumber)
          .collection('complaints')
          .doc(widget.onTaskModel.documentId)
          .update({'done': true});

      await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.workerEmail)
          .collection('upComing')
          .doc(widget.onTaskModel.documentId)
          .delete();

      await deleteDocumentsByMessage(widget.onTaskModel.message);

      // await FirebaseFirestore.instance
      //     .collection('workers')
      //     .doc(widget.workerEmail)
      //     .collection('complaints')
      //     .doc(widget.onTaskModel.documentId)
      //     .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteDocumentsByMessage(String message) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('complaints')
          .where('message', isEqualTo: message)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      print('Documents deleted successfully!');
    } catch (e) {
      print('Error deleting documents: $e');
    }
  }

  Future<void> markComplaintAsFinished(OnTaskModel onTaskModel) async {
    try {
      // Query the Firestore collection 'complaints' to find the document with the matching 'message' field
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('complaints')
          .where('message', isEqualTo: onTaskModel.message)
          .get();

      // Loop through the results and update the 'finished' field to true
      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'finished': true});
      }

      // Optional: Display a success message
      print('Complaint marked as finished.');
    } catch (e) {
      // Handle any errors
      print('Error marking complaint as finished: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.appThemeColor.withOpacity(0.3),
        ),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.appThemeColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
              ),
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.onTaskModel.ticketId,
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Text(
                      widget.onTaskModel.productName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      onPressed: _showPopupMenu,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.onTaskModel.fullName,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.onTaskModel.phoneNumber,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.onTaskModel.address,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.onTaskModel.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Date: ${widget.onTaskModel.selectedDate}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Time: ${widget.onTaskModel.selectedTime}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.onTaskModel.type,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
