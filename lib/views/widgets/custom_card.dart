import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final int number;
  final VoidCallback onTap;
  const CustomCard({super.key, required this.icon, required this.text, required this.number, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.appThemeColor.withOpacity(0.5),
          boxShadow: const [
            BoxShadow(blurRadius: 0.5,blurStyle: BlurStyle.normal)
          ]
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.appThemeColor
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(icon,color: Colors.white,),
                    ),
                  ),
                  const Spacer(),
                  Text(number.toString(),style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),)
                ],
              ),
              const SizedBox(height: 10),
              Text(text,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)
            ],
          ),
        ),
      ),
    );
  }
}
