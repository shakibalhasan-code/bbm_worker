import 'package:bbm_worker/core/models/worker.dart';
import 'package:bbm_worker/getx/profile_controller.dart';
import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/ontask_model.dart';

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
  final ProfileController _profileController = ProfileController();
  late String currentEmail;

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final docId = DateFormat('yyyy-MM-dd').format(now);
    _selectedDate = docId;
  }

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

  // Future<void> _selectTime(BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _selectedTime = picked.format(context);
  //     });
  //   }
  // }

  void _showPopupMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          value: 'done',
          child: Text('Mark as done'),
        ),
        PopupMenuItem(
          value: 'call',
          child: Text('Call to customer'),
        ),
      ],
    ).then((value) {
      if (value == 'done') {
        _selectDate(context).then((_) {
          _storeDataToFirestore();
        });
      } else if (value == 'call') {
        // Implement call functionality here
      }
    });
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
      'address': widget.onTaskModel.address
    };

    final now = DateTime.now().millisecondsSinceEpoch;

    final selectedDateDoc =
        FirebaseFirestore.instance.collection('reports').doc(_selectedDate);

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
    };

    final cdata = {
      'address': widget.onTaskModel.address,
      'fullName': widget.onTaskModel.fullName,
      'message': widget.onTaskModel.message,
      'phoneNumber': widget.onTaskModel.phoneNumber,
      'productCode': widget.onTaskModel.productCode,
      'productImage': widget.onTaskModel.productImage,
      'productName': widget.onTaskModel.productName,
      'update': widget.onTaskModel.update,
      'type': widget.onTaskModel.type,
      'endedDate': _selectedDate,

      'workerName': _profileController.user.value.fullName,
      'workerPhone': _profileController.user.value.phone,
      'workerImage': _profileController.user.value.imageUrl,
      'workerRole': _profileController.user.value.role,
      'workerEmail': _profileController.user.value.email
    };


    // final now = DateTime.now();
    // final docId = DateFormat('yyyy-MM-dd').format(now);

    try {
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.workerEmail)
          .collection('doneComplaints')
          .add(data);

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
                      widget.onTaskModel.productName,
                      style: TextStyle(
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
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.onTaskModel.phoneNumber,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.onTaskModel.address,
                          style: TextStyle(color: Colors.white),
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
                          'Date: ${widget.onTaskModel.selectedTime}',
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
