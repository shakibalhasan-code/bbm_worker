import 'package:flutter/material.dart';

import '../../core/models/upcomming_model.dart';
import '../../stylish/app_colors.dart';

class UpCommingTask extends StatelessWidget {
  final UpcommingModel upcommingModel;
  const UpCommingTask({super.key, required this.upcommingModel});

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
                      upcommingModel.productName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.more_vert,
                    //     color: Colors.white,
                    //   ),
                    //   onPressed: _showPopupMenu,
                    // ),
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
                          upcommingModel.ticketId,
                          style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                        Text(
                          upcommingModel.fullName,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          upcommingModel.phoneNumber,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          upcommingModel.address,
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
                          'Date: ${upcommingModel.selectedDate}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Date: ${upcommingModel.selectedTime}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          upcommingModel.type,
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