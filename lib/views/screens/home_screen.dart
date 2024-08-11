import 'package:bbm_worker/getx/user_data_controller.dart';
import 'package:bbm_worker/views/item/todays_work_item.dart';
import 'package:bbm_worker/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback card1Pressed,card2Pressed,card3Pressed,card4Pressed;
  const HomeScreen({super.key, required this.card1Pressed, required this.card2Pressed, required this.card3Pressed, required this.card4Pressed});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserDataController _userDataController = Get.put(UserDataController());
  late String userCurrentEmail = '';

  @override
  void initState() {
    super.initState();
    fetchUserAuth();
  }

  void fetchUserAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userCurrentEmail = prefs.getString('email') ?? '';

    if (userCurrentEmail.isNotEmpty) {
      await _userDataController.fetchTodayOnTaskData(userCurrentEmail);
      await _userDataController.fetchUpcomingOnTaskData(userCurrentEmail);
      await _userDataController.fetchWaitingOnTaskData(userCurrentEmail);
      await _userDataController.fetchReviewData(userCurrentEmail);
    }
  }

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
                  child: Obx(() {
                    return CustomCard(
                      icon: Icons.report,
                      text: 'Today\'s Work',
                      number: _userDataController.todayWorkCount.value,
                      onTap: widget.card1Pressed,
                    );
                  }),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Obx(() {
                    return CustomCard(
                      icon: Icons.timelapse_rounded,
                      text: 'Upcoming',
                      number: _userDataController.upcomingWorkCount.value,
                      onTap: widget.card2Pressed,

                    );
                  }),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return CustomCard(
                      icon: Icons.watch_later,
                      text: 'Waiting',
                      number: _userDataController.waitingWorkCount.value,
                      onTap: widget.card3Pressed,
                    );
                  }),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Obx(() {
                    return CustomCard(
                      icon: Icons.calendar_month_rounded,
                      text: 'Total Review',
                      number: _userDataController.reviewCount.value,
                      onTap: widget.card4Pressed,

                    );
                  }),
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
              child: Obx(() {
                final onTask = _userDataController.onTaskList;
                if (onTask.isEmpty) {
                  return const Center(child: Text('Maybe no work',style: TextStyle(color: Colors.white),));
                } else {
                  return ListView.builder(
                    itemCount: onTask.length,
                    itemBuilder: (context, index) {
                      return TodaysWorkItem(
                        onTaskModel: onTask[index],
                        workerEmail: userCurrentEmail,
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
