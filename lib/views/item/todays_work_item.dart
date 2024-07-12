import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:flutter/material.dart';

class TodaysWorkItem extends StatelessWidget {
  const TodaysWorkItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                child: Text('Automatic Bakery Machine',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              ),
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child:Row(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Inmur Rashid',style: TextStyle(color: Colors.white),),
                    Text('Phone: 018********',style: TextStyle(color: Colors.white),),
                    Text('Address: Mirpur, Dhaka',style: TextStyle(color: Colors.white),),
                  ],
                )),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Date: 15-08-2024',style: TextStyle(color: Colors.white),),
                    Text('Time: Evening',style: TextStyle(color: Colors.white),),
                    Text('Type: Installation',style: TextStyle(color: Colors.white),),
                  ],
                ))
              ],
            )

            )
          ],
        )
      ),
    );
  }
}
