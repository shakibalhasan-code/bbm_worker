import 'package:bbm_worker/views/item/todays_work_item.dart';
import 'package:flutter/material.dart';

class TabTodaysWork extends StatelessWidget {
  const TabTodaysWork({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context,index){
                    return TodaysWorkItem();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
