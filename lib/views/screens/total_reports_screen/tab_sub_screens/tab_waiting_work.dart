import 'package:flutter/material.dart';

import '../../../item/todays_work_item.dart';

class TabWaitingWork extends StatelessWidget {
  const TabWaitingWork({super.key});

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
