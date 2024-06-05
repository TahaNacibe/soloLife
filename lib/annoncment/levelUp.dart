import 'package:SoloLife/app/data/models/achievements.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';


// the tools and the level needed for them to unlock in a map (keys are the levels and names as values)
Map<int, dynamic> locks = {
  2: "Vault",
  4: "Budget Manger",
  5: "Jobs Available",
  7: "Voltage System",
  10: "Master Control",
  20: "Monster Mode",
};

//? this function handle the pop up of the level up 
void levelUpDialog(BuildContext context) {
  // for the progress bar
  int currentSteps = 0;

  // get user information 'for the level'
  Profile user = ProfileProvider().readProfile();

  //the achievements for the levels type get handled here
  achievementsHandler("level", context);

  //the dialog body for the pop up
  showDialog(
    barrierDismissible: true, 
    context: context,
    builder: (BuildContext context) {

      // so it refresh with every step the progress bar take
      return StatefulBuilder(
        builder: (context, setState) {

          // every 60 milliseconds add 1 to the step progress indicator
          Future.delayed(Duration(milliseconds: 60), () {
            currentSteps += 1;

            // refresh the ui while the steps taking are less than 11
            if (currentSteps < 11) {
              setState(() {});
            }
          });

          return AlertDialog(
            title: Text(
              // switching the content progress section to Leveled up section
              currentSteps < 10 ? "Preparing" : 'Leveled Up',
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontFamily: "Quick", fontWeight: FontWeight.bold),
            ),
            content: AnimatedContainer(
              // in 150ms and when the current steps surpass 7 increase the container size to 170 pixel
                duration: Duration(milliseconds: 150),
                height: currentSteps < 7 ? 40 : 170, 

                child: (currentSteps == 10) // in case steps reach 10 switch to the Leveled up part of the ui 
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Lv.${user.level}",
                                  style: TextStyle(
                                      fontFamily: "Quick",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 30,
                                color: Colors.indigo,
                              ),
                              Text("Lv.${user.level + 1}",
                                  style: TextStyle(
                                      fontFamily: "Quick",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Divider(),
                          ),

                          // checking any new tools if available in that level
                          if (locks.keys.contains(user.level+1))
                            Text("New:\n  - ${locks[user.level+1]}",
                                style: TextStyle(
                                    fontFamily: "Quick",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          // fixed rewards of each level
                          Text("Rewords:\n + 10 Attribute points\n + 100 runes",
                              style: TextStyle(
                                  fontFamily: "Quick",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))
                        ],
                      )

                      // the loading part of the ui
                    : Container(
                        width: 50,
                        height: 50,
                        child: Column(
                          children: [
                            StepProgressIndicator(
                              roundedEdges: Radius.circular(30),
                              totalSteps: 9,
                              selectedSize: 8,
                              currentStep: currentSteps,
                              selectedColor: Colors.indigo,
                              unselectedColor: Theme.of(context).cardColor,
                              padding: 0,
                            ),
                            Text("${currentSteps}0/100",
                                style: TextStyle(
                                    fontFamily: "Quick",
                                    fontWeight: FontWeight.w600))
                          ],
                        ))),
          );
        },
      );
    },
  );
}

