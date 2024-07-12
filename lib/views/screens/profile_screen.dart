import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1,color: AppColors.appThemeColor)
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            'https://st.depositphotos.com/34181562/60060/i/450/depositphotos_600606366-stock-photo-professional-engineer-black-women-working.jpg',
                            fit: BoxFit.cover,)
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Text('Inmur Rashid',style: TextStyle(fontSize: 20,color: Colors.white),),
                    Text('Junior Engenner',style: TextStyle(fontSize: 15,color: Colors.white),),
                    Text('inmur@gmail.com',style: TextStyle(fontSize: 15,color: Colors.white),),
                    const SizedBox(height: 5,),
                     Divider(color: Colors.white,thickness: 1,endIndent: 1,),
                    Row(
                      children: [

                      ],
                    )

                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }
}
