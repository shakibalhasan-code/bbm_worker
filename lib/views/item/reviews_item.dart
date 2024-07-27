import 'package:flutter/material.dart';

import '../../core/models/reiview_model.dart';
import '../../stylish/app_colors.dart';

class ReviewsItem extends StatelessWidget {
  final ReviewModel reviewModel;

  const ReviewsItem({super.key, required this.reviewModel});

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
              decoration: BoxDecoration(
                color: AppColors.appThemeColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
              ),
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(reviewModel.endedDate, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name: ${reviewModel.customerName}', style: TextStyle(color: Colors.white),),
                        Text('Location: ${reviewModel.address}', style: TextStyle(color: Colors.white),),
                        Text('Review: ${reviewModel.review}', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
