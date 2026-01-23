import 'package:flutter/material.dart';
import 'package:scrollkill/screens/settingScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/main.png',
              width: 300,
              height: 200,
              // fit: BoxFit.cover,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text("Scroll",style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontSize: 60
                )),
                Text("Kill", style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                   color: Theme.of(context).colorScheme.primary,
                  fontSize: 60
                  // fontWeight: FontWeight.w800
                ),)
              ],
            ),

            Spacer(),

            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text("Take Control of Your ", style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 26
                ),),
                Text("Scrolling", style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),),

              ],
            ),

            SizedBox(height: 50,),

            SizedBox(
              height: 70,
              child: ElevatedButton(onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>SettingScreen()));
              }, style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),

                )
              ), child: Text("Get Started",style: Theme.of(context).textTheme.headlineMedium,),),
            )
          ]
        ),
      ),
    );
  }
}
