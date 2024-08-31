import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/upcomming_model.dart';
import '../../getx/profile_controller.dart';
import '../../getx/user_data_controller.dart';
import '../../stylish/app_colors.dart';

class UpCommingTask extends StatefulWidget {
  final UpcommingModel upcommingModel;
  const UpCommingTask({super.key, required this.upcommingModel});

  @override
  State<UpCommingTask> createState() => _UpCommingTaskState();
}

class _UpCommingTaskState extends State<UpCommingTask> {

  String _selectedDate = 'Not set';
  String _selectedTime = 'Not set';
  final TextEditingController noteController = TextEditingController();
  bool isLoading = false;
  late String currentEmail;
  final ProfileController _profileController = ProfileController();

  final UserDataController _userDataController = Get.find<UserDataController>();

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

  void _showPopupMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 0),
      items: const [
        PopupMenuItem(
          value: 'changeDate',
          child: Text('Change Schedule'),
        ),
      ],
    ).then((value) {
      if (value == 'changeDate') {
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
                setState(() {
                  isLoading = false;
                });
                return; // Don't pop if empty
              } else {

                print('Selected new Date $_selectedDate & $_selectedTime');
                Get.snackbar('Selected date', '$_selectedDate & $_selectedTime');
                await updateDataCustomer(note);
                await updateDataWorker(note);
                await updateDataIntoMain(note);

                setState(() {
                  isLoading = false;
                  _userDataController.fetchUpcomingOnTaskData(currentEmail);
                });
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

  Future<void>updateDataCustomer(String note)async{
    try {
      // Step 1: Query the sub-collection to find the document with the matching message
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.upcommingModel.phoneNumber)
          .collection('workingComplaints')
          .where('message', isEqualTo: widget.upcommingModel.message)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Step 2: Get the first document
        DocumentSnapshot doc = querySnapshot.docs.first;

        // // Step 4: Increment the 'scheduleTime' if you are tracking updates
        // int scheduleTime = doc.get('scheduleTime') ?? 0;
        // scheduleTime++;

        // Step 3: Prepare data to update
        final dataToUpdate = {
          'note': note,  // Your note data
          'selectedDate':_selectedDate,
          'selectedTime' : _selectedTime,
          // Add other fields to update here
        };

        print(doc.id);

        // Step 5: Update the document
        await FirebaseFirestore.instance
            .collection('customers')
            .doc(widget.upcommingModel.phoneNumber)
            .collection('workingComplaints')
            .doc(doc.id)
            .update(dataToUpdate);

        print('Document updated successfully.');
      } else {
        print('No document found with the specified message.');
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  Future<void>updateDataWorker(String note)async{
    try {
      // Step 1: Query the sub-collection to find the document with the matching message
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(currentEmail)
          .collection('upComing')
          .where('message', isEqualTo: widget.upcommingModel.message)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Step 2: Get the first document
        DocumentSnapshot doc = querySnapshot.docs.first;

        // // Step 4: Increment the 'scheduleTime' if you are tracking updates
        // int scheduleTime = doc.get('scheduleTime') ?? 0;
        // scheduleTime++;

        // Step 3: Prepare data to update
        final dataToUpdate = {
          'note': note,  // Your note data
          'selectedDate':_selectedDate,
          'selectedTime' : _selectedTime,
          // Add other fields to update here
        };

        print(doc.id);

        // Step 5: Update the document
        await FirebaseFirestore.instance
            .collection('workers')
            .doc(currentEmail)
            .collection('upComing')
            .doc(doc.id)
            .update(dataToUpdate);

        print('Document updated successfully.');
        Get.snackbar('Success', 'Document updated successfully.');
      } else {
        print('No document found with the specified message.');
        Get.snackbar('Error', 'No document found with the specified message.');
      }
    } catch (e) {
      print('Error updating document: $e');
      Get.snackbar('Error', 'Failed to update document: $e');
    }
  }

  Future<void> updateDataIntoMain(String note) async {
    try {
      // Step 1: Query the collection to find the document with the matching message
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('complaints')
          .where('message', isEqualTo: widget.upcommingModel.message)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Step 2: Get the first document
        DocumentSnapshot doc = querySnapshot.docs.first;

        // Step 3: Fetch the document data and cast it to Map<String, dynamic>
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Step 4: Check if the 'scheduleTime' field exists, if not default to 0
        int scheduleTime = data.containsKey('scheduleTime') ? data['scheduleTime'] as int : 0;

        // Step 5: Increment the 'scheduleTime' field
        scheduleTime++;

        // Step 6: Prepare data to update
        final dataToUpdate = {
          'note': note,  // Your note data
          's-selectedDate': _selectedDate,
          's-selectedTime': _selectedTime,
          'scheduleTime': scheduleTime,  // Update the scheduleTime
        };

        print(doc.id);

        // Step 7: Update the document
        await FirebaseFirestore.instance
            .collection('complaints')
            .doc(doc.id)
            .update(dataToUpdate);

        print('Document updated successfully.');
      } else {
        print('No document found with the specified message.');
      }
    } catch (e) {
      print('Error updating document: $e');
    }
  }


  // Future<void> _saveDataToWorker() async {
  //   final data = {
  //     'address': widget.upcommingModel.address,
  //     'fullName': widget.upcommingModel.fullName,
  //     'message': widget.upcommingModel.message,
  //     'phoneNumber': widget.upcommingModel.phoneNumber,
  //     'productCode': widget.upcommingModel.productCode,
  //     'productImage': widget.upcommingModel.productImage,
  //     'productName': widget.upcommingModel.productName,
  //     'update': widget.upcommingModel.update,
  //     'issueCategory': widget.upcommingModel.type,
  //     'selectedDate': _selectedDate,
  //     'selectedTime': _selectedTime,
  //     'ticketId': widget.upcommingModel.ticketId
  //   };
  //
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('workers')
  //         .doc(currentEmail)
  //         .collection('upComing')
  //         .add(data);
  //
  //     // await FirebaseFirestore.instance
  //     //     .collection('customers')
  //     //     .doc(widget.onTaskModel.phoneNumber)
  //     //     .collection('complaints')
  //     //     .doc(widget.onTaskModel.documentId)
  //     //     .update(
  //     //     {'selectedDate': _selectedDate, 'selectedTime': _selectedTime});
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Successfully Saved'),
  //       ),
  //     );
  //     setState(() {
  //       _userDataController.fetchUpcomingOnTaskData(currentEmail);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateFormat('dd-MM-yyyy').format(picked);
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
                    Expanded(
                      child: Text(
                        widget.upcommingModel.productName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                          widget.upcommingModel.ticketId,
                          style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                        Text(
                          widget.upcommingModel.fullName,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.upcommingModel.phoneNumber,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.upcommingModel.address,
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
                          'Date: ${widget.upcommingModel.selectedDate}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Date: ${widget.upcommingModel.selectedTime}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.upcommingModel.type,
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