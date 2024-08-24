import 'package:bbm_worker/core/models/done_task_model.dart';
import 'package:flutter/material.dart';

import '../../core/models/upcomming_model.dart';
import '../../stylish/app_colors.dart';

class DoneTaskItem extends StatelessWidget {
  final DoneTaskModel doneTaskModel;
  const DoneTaskItem({super.key, required this.doneTaskModel});

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
                      doneTaskModel.productName,
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
                          doneTaskModel.ticketId,
                          style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                        Text(
                          doneTaskModel.fullName,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          doneTaskModel.phoneNumber,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          doneTaskModel.address,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          doneTaskModel.message,
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
                          'Date: ${doneTaskModel.date}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          doneTaskModel.type,
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
