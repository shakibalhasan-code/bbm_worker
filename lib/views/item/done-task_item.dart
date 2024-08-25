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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        doneTaskModel.productName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        overflow: TextOverflow.ellipsis,
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: Colors.green, size: 16.0),
                            const SizedBox(width: 5.0),
                            Text(
                              'Date: ${doneTaskModel.date}',
                              style: const TextStyle(
                                color: Colors.white,

                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(Icons.confirmation_num_outlined, color: Colors.green, size: 16.0),
                            const SizedBox(width: 5.0),
                            Text(
                              'Ticket ID: ${doneTaskModel.ticketId}',
                              style: const TextStyle(
                                color: Colors.white,

                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, color: Colors.green, size: 16.0),
                            const SizedBox(width: 5.0),
                            Text(
                              doneTaskModel.fullName,
                              style: const TextStyle(
                                color: Colors.white,

                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        // Row(
                        //   children: [
                        //     const Icon(Icons.call, color: Colors.green, size: 16.0),
                        //     const SizedBox(width: 5.0),
                        //     Text(
                        //       doneTaskModel.phoneNumber,
                        //       style: const TextStyle(
                        //         color: Colors.black87,
                        //         fontSize: 14.0,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, color: Colors.green, size: 16.0),
                            const SizedBox(width: 5.0),
                            Expanded(
                              child: Text(
                                doneTaskModel.address,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(Icons.message_outlined, color: Colors.green, size: 16.0),
                            const SizedBox(width: 5.0),
                            Expanded(
                              child: Text(
                                doneTaskModel.message,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        // Row(
                        //   children: [
                        //     const Icon(Icons.star_border_outlined, color: Colors.green, size: 16.0),
                        //     const SizedBox(width: 5.0),
                        //     Text(
                        //       doneTaskModel.review,
                        //       style: const TextStyle(
                        //         color: Colors.red,
                        //         fontSize: 14.0,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 5.0),
                        // Row(
                        //   children: [
                        //     const Icon(Icons.star_border_outlined, color: Colors.green, size: 16.0),
                        //     const SizedBox(width: 5.0),
                        //     Text(
                        //       doneTaskModel.rating.toString(),
                        //       style: const TextStyle(
                        //         color: Colors.red,
                        //         fontSize: 14.0,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: Colors.green, size: 16.0),
                            const SizedBox(width: 5.0),
                            Text(
                              'Date: ${doneTaskModel.date}',
                              style: const TextStyle(
                                color: Colors.white,

                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(Icons.category_outlined, color: Colors.green, size: 16.0),
                            const SizedBox(width: 5.0),
                            Text(
                              doneTaskModel.type,
                              style: const TextStyle(
                                color: Colors.white,

                                fontSize: 14.0,
                              ),
                            ),
                          ],
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