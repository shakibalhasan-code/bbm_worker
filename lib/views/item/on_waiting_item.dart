import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../core/models/waiting_model.dart';
import '../../../../getx/user_data_controller.dart';
import '../../stylish/app_colors.dart';

class WaitingWorkItem extends StatefulWidget {
  final WaitingModel waitingModel;
  final String workerEmail;

  const WaitingWorkItem({
    Key? key,
    required this.waitingModel,
    required this.workerEmail,
  }) : super(key: key);

  @override
  _WaitingWorkItemState createState() => _WaitingWorkItemState();
}

class _WaitingWorkItemState extends State<WaitingWorkItem> {
  final UserDataController _userDataController = Get.find<UserDataController>();
  final TextEditingController noteController = TextEditingController();
  bool isLoading = false;

  String _selectedDate = 'Not set';
  String _selectedTime = 'Not set';

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

// Your existing code with suggested improvements...
  void _showPopupMenu() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          offset.dx, offset.dy, offset.dx + 40, offset.dy + 40),
      items: const [
        PopupMenuItem(
          value: 'schedule',
          child: Text('Set Schedule'),
        ),
        PopupMenuItem(
          value: 'unsolved',
          child: Text('Set Unsolved'),
        ),
        PopupMenuItem(
          value: 'call',
          child: Text('Call to customer'),
        ),
      ],
    ).then((value) {
      if (value == 'schedule') {
        _selectDate(context).then((_) {
          _selectTime(context).then((_) {
            if (_selectedDate.isNotEmpty && _selectedTime.isNotEmpty) {
               _storeDataToFirestore();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please Select a date '),
                ),
              );
            }
          });
        });
      } else if (value == 'call') {
        if (widget.waitingModel.phoneNumber != null) {
          FlutterPhoneDirectCaller.callNumber(widget.waitingModel.phoneNumber!);
        } else {
          Get.snackbar('Failed to call', 'Sorry, phone number is empty');
        }
      } else if (value == 'unsolved') {
        _showDoneNoteDialog(context);
      }
    });
  }

  Future<void> _storeDataToUnsolve() async {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd'); // Format as needed
    final formattedDate = formatter.format(now);

    final data = {
      'address': widget.waitingModel.address,
      'fullName': widget.waitingModel.fullName,
      'message': widget.waitingModel.message,
      'phoneNumber': widget.waitingModel.phoneNumber,
      'productCode': widget.waitingModel.productCode,
      'productImage': widget.waitingModel.productImage,
      'productName': widget.waitingModel.productName,
      'update': widget.waitingModel.update,
      'issueCategory': widget.waitingModel.type,
      'unsolvedDate': formattedDate,
      'workerEmail': widget.workerEmail,
      'ticketId': widget.waitingModel.ticketNumber,
      'note': noteController.text,
      'date':formattedDate
    };

    try {
      await FirebaseFirestore.instance
          .collection('unsolved')
          .add(data); // Using .add() to automatically generate a document ID

      await deleteDocumentByString('complaints', widget.waitingModel.ticketNumber);

      await _userDataController.removeWaitingTask(
          widget.workerEmail, widget.waitingModel.documentId);
    } catch (e) {
      print('Error storing unsolved data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to store data: $e')),
      );
    }
  }

  Future<void> deleteDocumentByString(String collection, dataString) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('id', isEqualTo: dataString)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('complaints')
            .doc(docId)
            .delete();

        print('Document deleted successfully!');
      } else {
        print('No matching document found.');
      }
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<void> deleteCusSubCollDocumentByString() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.waitingModel.phoneNumber)
          .collection('complaints')
          .where('id', isEqualTo: widget.waitingModel.ticketNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('complaints')
            .doc(docId)
            .delete();

        print('Document deleted successfully!');
      } else {
        print('No matching document found.');
      }
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<void> deleteWorkSubCollDocumentByString() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.workerEmail)
          .collection('complaints')
          .where('id', isEqualTo: widget.waitingModel.ticketNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('complaints')
            .doc(docId)
            .delete();

        print('Document deleted successfully!');
      } else {
        print('No matching document found.');
      }
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  Future<void> writeDataToCustomer() async {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd'); // Format as needed
    final formattedDate = formatter.format(now);
    final data = {
      'address': widget.waitingModel.address,
      'fullName': widget.waitingModel.fullName,
      'message': widget.waitingModel.message,
      'phoneNumber': widget.waitingModel.phoneNumber,
      'productCode': widget.waitingModel.productCode,
      'productImage': widget.waitingModel.productImage,
      'productName': widget.waitingModel.productName,
      'update': widget.waitingModel.update,
      'issueCategory': widget.waitingModel.type,
      'unsolvedDate': formattedDate,
      'workerEmail': widget.workerEmail,
      'ticketId': widget.waitingModel.ticketNumber,
      'note': noteController.text

    };

    try{
      FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.waitingModel.phoneNumber)
          .collection('unsolved')
          .add(data);
      print('the unsolve data saved into customer unsolved');
    }catch(e){
      print('failed the unsolve data saved into customer unsolved $e');

    }
  }
  Future<void> writeDataToWorker() async {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd'); // Format as needed
    final formattedDate = formatter.format(now);
    final data = {
      'address': widget.waitingModel.address,
      'fullName': widget.waitingModel.fullName,
      'message': widget.waitingModel.message,
      'phoneNumber': widget.waitingModel.phoneNumber,
      'productCode': widget.waitingModel.productCode,
      'productImage': widget.waitingModel.productImage,
      'productName': widget.waitingModel.productName,
      'update': widget.waitingModel.update,
      'issueCategory': widget.waitingModel.type,
      'unsolvedDate': formattedDate,
      'workerEmail': widget.workerEmail,
      'ticketId': widget.waitingModel.ticketNumber,
      'note': noteController.text

    };

    try{
      FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.workerEmail)
          .collection('unsolved')
          .add(data);
      print('the unsolve data saved into customer unsolved');
    }catch(e){
      print('failed the unsolve data saved into customer unsolved $e');

    }
  }


  Future<String?> _showDoneNoteDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsolved Note'),
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
                setState(() async {
                  await _storeDataToUnsolve();
                  await writeDataToWorker();
                  await writeDataToCustomer();
                  await deleteCusSubCollDocumentByString();
                  await deleteWorkSubCollDocumentByString();
                  Navigator.pop(context);
                });
                setState(() {
                  isLoading = false;
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

  Future<void> _storeDataToFirestore() async {
    final data = {
      'address': widget.waitingModel.address,
      'fullName': widget.waitingModel.fullName,
      'message': widget.waitingModel.message,
      'phoneNumber': widget.waitingModel.phoneNumber,
      'productCode': widget.waitingModel.productCode,
      'productImage': widget.waitingModel.productImage,
      'productName': widget.waitingModel.productName,
      'update': widget.waitingModel.update,
      'issueCategory': widget.waitingModel.type,
      'selectedDate': _selectedDate,
      'selectedTime': _selectedTime,
      'ticketId': widget.waitingModel.ticketNumber
    };

    try {
      await FirebaseFirestore.instance
          .collection('workers')
          .doc(widget.workerEmail)
          .collection('upComing')
          .add(data);

      await FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.waitingModel.phoneNumber)
          .collection('workingComplaints')
          .add(data);

      await FirebaseFirestore.instance
          .collection('customers')
          .doc(widget.waitingModel.phoneNumber)
          .collection('complaints')
          .doc(widget.waitingModel.documentId)
          .update(
              {'selectedDate': _selectedDate, 'selectedTime': _selectedTime});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully Saved'),
        ),
      );
    } catch (e) {
      print(e);
    }
    await deleteDataFromWorker();
  }

  Future<void>deleteDataFromWorker()async{
    await FirebaseFirestore.instance
        .collection('workers')
        .doc(widget.workerEmail)
        .collection('complaints')
        .where('ticketId', isEqualTo: widget.waitingModel.ticketNumber)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        print(querySnapshot.docs);
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Task successfully Moved'),
            ),
          );
        });

      }

      setState(() {
        _userDataController.fetchWaitingOnTaskData(widget.workerEmail);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.waitingModel.documentId);
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.waitingModel.productName!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onPressed: _showPopupMenu,
                        ),
                      ],
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
                          widget.waitingModel.ticketNumber,
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        Text(
                          widget.waitingModel.fullName!,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.waitingModel.phoneNumber!,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.waitingModel.address!,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.waitingModel.message!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Date: $_selectedDate',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Time: $_selectedTime',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          widget.waitingModel.type!,
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
