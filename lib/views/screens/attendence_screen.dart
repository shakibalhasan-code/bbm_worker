import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:bbm_worker/views/item/attendance_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class AttendenceScreen extends StatefulWidget {
  const AttendenceScreen({super.key});

  @override
  State<AttendenceScreen> createState() => _AttendenceScreenState();
}

class _AttendenceScreenState extends State<AttendenceScreen> {

  late bool isAttended = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.appThemeColor.withOpacity(0.3)
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
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
                            child: Image.network(
                              'https://st.depositphotos.com/34181562/60060/i/450/depositphotos_600606366-stock-photo-professional-engineer-black-women-working.jpg',
                              fit: BoxFit.cover,)
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Inmur Rashid', style: TextStyle(fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                          Text('Junior Engeneer', style: TextStyle(fontSize: 14,
                              color: Colors.white)),
                          Text('inmur@gmail.com', style: TextStyle(fontSize: 14,
                              color: Colors.white)),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onLongPress: (){
                              setState(() {
                                isAttended = true;
                                Get.snackbar('Success','Your\'e attended from now');

                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: isAttended ? Colors.green : Colors.red
                              ),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 3),
                                  child: Text(isAttended ? 'Presented' : 'Absent- Long Press Now',textAlign: TextAlign.center, style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                              ),
                            ),
                          )
                        ],
                      ),

                    ],
                  )
                ],
              ),
            ),
          ),
          //END OF HEAD CONTAINER
          const SizedBox(height: 10),
          Expanded(child: ListView.builder(
            padding: EdgeInsets.only(bottom: 10),
            itemCount: 10,
              itemBuilder: (context,index){
            return AttendanceItem();
          }))
        ],
      ),
    );
  }
}

// CachedNetworkImage(
// imageUrl: 'https://st.depositphotos.com/34181562/60060/i/450/depositphotos_600606366-stock-photo-professional-engineer-black-women-working.jpg',
// fit: BoxFit.cover,
// placeholder: (context,url)=>Center(child: LinearProgressIndicator(
// borderRadius: BorderRadius.circular(50),
// ),),
// errorWidget: ,
// ),
