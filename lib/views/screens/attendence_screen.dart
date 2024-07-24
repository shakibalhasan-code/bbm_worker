import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:bbm_worker/views/item/attendance_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/attendance_record.dart';
import '../../core/models/worker.dart';

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen> {
  late bool isAttended = false;
  late String userEmail = '';
  UserModel? userModel;
  List<AttendanceRecord> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    fetchUserAuth();
  }

  void fetchUserAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('email') ?? '';

    // Fetch user data from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('workers')
        .doc(userEmail)
        .get();
    setState(() {
      userModel =
          UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>);
    });
    fetchAttendanceStatus();
    fetchAttendanceRecords();
  }

  void fetchAttendanceStatus() async {
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DocumentSnapshot attendanceDoc = await FirebaseFirestore.instance
        .collection('attendance')
        .doc(todayDate)
        .collection('workers')
        .doc(userEmail)
        .get();

    setState(() {
      isAttended = attendanceDoc.exists;
    });
  }

  void fetchAttendanceRecords() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('workers')
        .doc(userEmail)
        .collection('attendance')
        .get();

    setState(() {
      attendanceRecords = querySnapshot.docs
          .map((doc) => AttendanceRecord.fromFirestore(
              doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> markAttendance() async {
    // Request location permissions
    if (await Permission.location.request().isGranted) {
      // Fetch location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String currentTime = DateFormat('hh:mm a').format(DateTime.now());

      // Convert coordinates to address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      String location =
          '${place.street}, ${place.locality}, ${place.subLocality}, ${place.postalCode}';

      // Store attendance data in Firestore
      await FirebaseFirestore.instance
          .collection('attendance')
          .doc(todayDate)
          .collection('workers')
          .doc(userEmail)
          .set({
        'fullName': userModel!.fullName,
        'email': userModel!.email,
        'imageUrl': userModel!.imageUrl,
        'phone': userModel!.phone,
        'role': userModel!.role,
        'attended': true,
        'time': currentTime,
        'date': todayDate,
        'location': location,
      });

      await FirebaseFirestore.instance
          .collection('workers')
          .doc(userEmail)
          .collection('attendance')
          .doc(todayDate)
          .set({
        'date': todayDate,
        'time': currentTime,
        'location': location,
        'attended': true,
      });

      setState(() {
        isAttended = true;
      });

      Get.snackbar('Success',backgroundColor: AppColors.appThemeColor,colorText: Colors.white, 'You\'re attended from now');
      fetchAttendanceRecords(); // Refresh the attendance records after marking attendance
    } else {
      Get.snackbar('Permission Denied',backgroundColor: Colors.red,colorText: Colors.white,
          'Location permission is required to mark attendance');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          userModel != null
              ? Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.appThemeColor.withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: userModel!.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(userModel!.fullName,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                                Text(userModel!.role,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                                Text(userModel!.email,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white)),
                                const SizedBox(height: 8),
                                GestureDetector(
                                  onLongPress: () {
                                    markAttendance();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: isAttended
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      child: Text(
                                          isAttended
                                              ? 'Presented'
                                              : 'Absent - Long Press Now',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: attendanceRecords.length,
              itemBuilder: (context, index) {
                AttendanceRecord record = attendanceRecords[index];
                return AttendanceItem(
                  attendanceRecord: record,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
