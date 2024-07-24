import 'package:bbm_worker/core/models/attendance_record.dart';
import 'package:flutter/material.dart';

import '../../stylish/app_colors.dart';

class AttendanceItem extends StatelessWidget {
  final AttendanceRecord attendanceRecord;
  const AttendanceItem({super.key, required this.attendanceRecord});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.appThemeColor.withOpacity(0.3)
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: AppColors.appThemeColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                ),
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(attendanceRecord.date,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                  child:Row(
                    children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(attendanceRecord.attended ? 'Attended: ' 'Yes' : 'No',style: TextStyle(color: Colors.white),),
                          Text(attendanceRecord.location,style: TextStyle(color: Colors.white),),
                          Text(attendanceRecord.time,style: TextStyle(color: Colors.white),),
                        ],
                      )),
                    ],
                  )

              )
            ],
          )
      ),
    );
  }
}
