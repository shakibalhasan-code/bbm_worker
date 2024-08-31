import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:bbm_worker/core/models/unsolved_model.dart';

class UnsolvedItem extends StatelessWidget {
  final UnsolvedModel unsolvedModel;
  const UnsolvedItem({super.key, required this.unsolvedModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.appThemeColor.withOpacity(0.3),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      unsolvedModel.productName,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // const Icon(Icons.more_vert, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: Colors.blue),
                  const SizedBox(width: 5.0),
                  Text(
                    unsolvedModel.unsolvedDate,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Icon(Icons.confirmation_num_outlined, color: Colors.blue),
                  const SizedBox(width: 5.0),
                  Text(
                    unsolvedModel.ticketId,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.blue),
                  const SizedBox(width: 5.0),
                  Text(
                    unsolvedModel.fullName,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Icon(Icons.call, color: Colors.blue),
                  const SizedBox(width: 5.0),
                  Text(
                    unsolvedModel.phoneNumber,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.blue),
                  const SizedBox(width: 5.0),
                  Text(
                    unsolvedModel.address,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Icon(Icons.message_outlined, color: Colors.blue),
                  const SizedBox(width: 5.0),
                  Text(
                    unsolvedModel.message,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue),
                  const SizedBox(width: 5.0),
                  Text(
                    unsolvedModel.note,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}