import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

void levelUpDialog(BuildContext context) {
  int currentSteps = 0;
  Profile user = ProfileProvider().readProfile();
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future.delayed(Duration(milliseconds: 60), () {
            currentSteps += 1;
            if (currentSteps < 11) {
              setState(() {});
            }
          });

          return AlertDialog(
  title: Text(
    currentSteps < 10?  "Preparing":'Leveled Up' ,
    textAlign: TextAlign.center,
    style: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.bold),
  ),
  content: AnimatedContainer(
    duration: Duration(milliseconds: 150),
    height:currentSteps < 8? 30 : 150, // Specify a fixed height
    child: currentSteps == 10
        ?Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Text("Lv.${user.level-1}",style: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.bold,fontSize: 22)),
              Icon(Icons.arrow_forward_rounded,size: 30,color: Colors.indigo,),
              Text("Lv.${user.level}",style: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.bold,fontSize: 22))
            ],),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Divider(),
            ),
            Text("Rewords:\n + 10 Attribute points\n + 100 runes",style: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.bold,fontSize: 16))
          ],
        )
        : Container(
          width: 50,
          height: 50,
          child: Column(
            children: [
              StepProgressIndicator(
                roundedEdges: Radius.circular(30),
                            totalSteps:9,
                            selectedSize: 8,
                            currentStep: currentSteps,
                            selectedColor: Colors.indigo,
                            unselectedColor: Theme.of(context).cardColor,
                            padding: 0,
                            ),
                            Text("${currentSteps}0/100",style: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.w600))
            ],
          ))
  ),
);


        },
      );
    },
  );
}
