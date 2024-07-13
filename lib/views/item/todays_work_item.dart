import 'package:bbm_worker/core/models/ontask_model.dart';
import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:flutter/material.dart';

class TodaysWorkItem extends StatefulWidget {
  final int index;
  final OnTaskModel ontask;
  const TodaysWorkItem({super.key, required this.index, required this.ontask});

  @override
  _TodaysWorkItemState createState() => _TodaysWorkItemState();
}

class _TodaysWorkItemState extends State<TodaysWorkItem>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'Change Date':
        print('Change Date selected');
        break;
      case 'Change Time':
        print('Change Time selected');
        break;
      case 'Mark as Done':
        print('Mark as Done selected');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print('Item ${widget.index} tapped');
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
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
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.ontask.productName,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            elevation: 0,
                            padding: EdgeInsets.all(5),
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            onSelected: _onMenuSelected,
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem<String>(
                                  value: 'Change Date',
                                  child: Text('Change Date'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Change Time',
                                  child: Text('Change Time'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Mark as Done',
                                  child: Text('Mark as Done'),
                                ),
                              ];
                            },
                          ),
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
                                widget.ontask.fullName,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                widget.ontask.phoneNumber,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                widget.ontask.address,
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
                                'Date: 15-08-2024',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Time: Evening',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Type: Installation',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
