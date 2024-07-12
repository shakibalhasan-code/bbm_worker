import 'package:bbm_worker/views/item/todays_work_item.dart';
import 'package:bbm_worker/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    icon: Icons.report,
                    text: 'Total Reports',
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomCard(
                    icon: Icons.timelapse_rounded,
                    text: 'Todays Work',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    icon: Icons.watch_later,
                    text: 'Waiting',
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: CustomCard(
                    icon: Icons.calendar_month_rounded,
                    text: 'Todays Work',
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Today\'s Work',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return TodaysWorkItem();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
