import 'package:flutter/material.dart';

import '../../stylish/app_colors.dart';

class AttendanceItem extends StatelessWidget {
  const AttendanceItem({super.key});

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
                  child: Text('01-09-2024',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                  child:Row(
                    children: [
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Attended: Yes',style: TextStyle(color: Colors.white),),
                          Text('Location: Mirpur, Dhaka',style: TextStyle(color: Colors.white),),
                          Text('Time: 09:30AM',style: TextStyle(color: Colors.white),),
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
