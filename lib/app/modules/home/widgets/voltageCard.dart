import 'package:SoloLife/app/data/models/solo.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:animated_glitch/animated_glitch.dart';
import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class VoltageCard extends StatelessWidget {
  // initialize the storage
  final homeCtrl = Get.find<HomeController>();
  // initialize the vars
  final List<Daily> tasks = DailyTasks().readTasks();
  final bool isBox;

  VoltageCard({super.key, required this.isBox});

  @override
  Widget build(BuildContext context) {
    // initialize the vars
    var squareWidth = Get.width - 12.0.wp;
    
    return isBox? GestureDetector(
      onTap: () {
       Navigator.pushNamed(context, "volt");
      },
      child: AnimatedGlitch(
  controller: AnimatedGlitchController(),
        child: Stack(alignment: Alignment.center,
          children: [
            Container(
              width: squareWidth / 2,
              height: squareWidth /2,
              margin: EdgeInsets.all(2.0.wp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).cardColor, 
                boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 8,
            spreadRadius: -2,
            offset: const Offset(0, 7),
                )
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  Padding(
                    padding: EdgeInsets.all(5.0.wp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                        ),
                          child: Image.asset(
                            width:60.0.sp,
                            height: 60.0.sp,
                            'assets/images/thunder.png'),
                        ),
                        SizedBox(
                          height: 5.0.wp,
                        ),
                        Text(
                          "Voltage",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontFamily: "Quick",
                              fontSize: 12.0.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            
          ],
        ),
      ),
    ): GestureDetector(
      onTap:(){
         Navigator.pushNamed(context, "volt");
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container( padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(context).cardColor,
                              boxShadow:[BoxShadow(
                              color: Theme.of(context).shadowColor, // Shadow color
                              spreadRadius: 1, // Extends the shadow beyond the box
                              blurRadius: 5, // Blurs the edges of the shadow
                              offset: const Offset(0, 3), // Moves the shadow slightly down and right
                              )]
                            ),
          child: Row(children: [
            Container(decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                        ),
                          child: Image.asset(
                            width:60.0.sp,
                            height: 60.0.sp,
                            'assets/images/thunder.png'),
                        ),

                   Text(
                          "Voltage",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontFamily: "Quick",
                              fontSize: 12.0.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
          ],
                        
          ),
        ),
      ),
    );
  }
}
