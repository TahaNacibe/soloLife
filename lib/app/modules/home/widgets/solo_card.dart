import 'package:SoloLife/app/data/models/solo.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:animated_glitch/animated_glitch.dart';
import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';


class DailyCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  final List<Daily> tasks = DailyTasks().readTasks();
  final bool isBox;
  DailyCard({super.key,required this.isBox});

int finished(){
  int finished = 0;
  for(Daily task in tasks){
    if(!task.isGoing){
      finished = finished +1 ;
    }
  }
  return finished;
}
  @override
  Widget build(BuildContext context) {
    final color = const Color.fromARGB(255, 80, 39, 176);
    var squareWidth = Get.width - 12.0.wp;
    return isBox? GestureDetector(
      onTap: () {
       Navigator.popAndPushNamed(context, "soloDetails");
      },
      child: AnimatedGlitch(
  controller: AnimatedGlitchController(),
        child: Stack(
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
                  StepProgressIndicator(
                    roundedEdges: Radius.circular(20),
                    totalSteps: tasks.isEmpty? 1 : tasks.length,
                    currentStep:
                        tasks.isEmpty? 0 : finished(),
                    size: 5,
                    padding: 0,
                    selectedGradientColor: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withOpacity(0.5), color],
                    ),
                    unselectedGradientColor: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.white],
                    ),
                  ),
            
                  Padding(
                    padding: EdgeInsets.all(5.0.wp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Daily Quests",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontFamily: "Quick",
                              fontSize: 12.0.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 1.5.wp,
                        ),
                        Text(
                          '${tasks.length} Task',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: color),
                        ),
                      ],
                    ),
                  ),
                  Align(alignment: Alignment.bottomRight,
                    child: Padding(
                    padding: EdgeInsets.all(6.0.wp),
                    child: Icon(
                      Icons.star,
                      color: color,
                    ),
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
         Navigator.popAndPushNamed(context, "soloDetails");
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
          child: ListTile(
            leading: SizedBox(
              width: 30,
              height: 30,
              child: Icon(
                      Icons.star,
                      color: color,
                    ),
            ),
                  title: Text(
                          "Daily Quests",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontFamily: "Quick",
                              fontSize: 12.0.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle:Text(
                          '${tasks.length} Task',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: color),
                        ),
                        trailing: CircularStepProgressIndicator(
                          selectedColor: Colors.purple,
                          unselectedColor: Colors.grey.withOpacity(.4),
                          padding: 0,
              totalSteps: tasks.isEmpty? 1 : tasks.length,
              currentStep: tasks.isEmpty? 0 : finished(),
              width: 40,
              height: 40,
              roundedCap: (_, isSelected) => isSelected,
          ),
          ),
        ),
      ),
    );
  }
}
