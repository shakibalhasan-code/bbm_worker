import 'package:bbm_worker/core/models/ontask_model.dart';
import 'package:bbm_worker/getx/user_data_controller.dart';
import 'package:bbm_worker/views/item/todays_work_item.dart';
import 'package:bbm_worker/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      await _userDataController.fetchOnTaskData(userCurrentEmail);
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
            const Row(
              children: [
                Expanded(
                  child: CustomCard(
                    icon: Icons.report,
                    text: 'Total Reports',
                  ),
                ),
                 SizedBox(
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
            const Row(
              children: [
                Expanded(
                  child: CustomCard(
                    icon: Icons.watch_later,
                    text: 'Waiting',
                  ),
                ),
                 SizedBox(
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
              child: Obx(() {
                final onTask = _userDataController.onTaskList;
                if (onTask.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: onTask.length,
                    itemBuilder: (context, index) {
                      return TodaysWorkItem(
                        ontask: onTask[index],
                        index: index,
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
