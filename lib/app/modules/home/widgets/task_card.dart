import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/data/models/task.dart';
import 'package:SoloLife/app/modules/detail/Viewtask.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TaskCard extends StatelessWidget {
  // initialize the storage services
  final HomeController homeCtrl = Get.find<HomeController>();

  // initialize the vars
  final Task task;
  final bool isBox;

  TaskCard({Key? key, required this.task, required this.isBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // initialize the vars
    final color = HexColor.fromHex(task.color);
    var squareWidth = Get.width - 12.0.wp;

    return isBox
        ? GestureDetector(
            onTap: () {
              homeCtrl.changeTask(task);
              homeCtrl.changeTodos(task.todos ?? []);
              //Get.to(() => DetailPage());
              Navigator.popAndPushNamed(context, "DetailPage");
            },
            child: Container(
              width: squareWidth / 2,
              height: squareWidth / 2,
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
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepProgressIndicator(
                    roundedEdges: Radius.circular(20),
                    totalSteps: homeCtrl.isTodosEmpty(task) ? 1 : task.todos!.length,
                    currentStep: homeCtrl.isTodosEmpty(task) ? 0 : homeCtrl.getDoneTodo(task),
                    size: 5,
                    padding: 0,
                    selectedGradientColor: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withOpacity(0.5), color],
                    ),
                    unselectedGradientColor: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.white],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(6.0.wp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: "Quick",
                            fontSize: 12.0.sp,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 1.5.wp,
                        ),
                        Text(
                          '${task.todos?.length ?? 0} Task',
                          style: TextStyle(fontWeight: FontWeight.bold, color: color),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(6.0.wp),
                      child: Icon(
                        IconData(task.icon, fontFamily: 'MaterialIcons'),
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              homeCtrl.changeTask(task);
              homeCtrl.changeTodos(task.todos ?? []);
              Get.to(() => DetailPage());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor, // Shadow color
                      spreadRadius: 1, // Extends the shadow beyond the box
                      blurRadius: 5, // Blurs the edges of the shadow
                      offset: const Offset(0, 3), // Moves the shadow slightly down and right
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(
                          IconData(task.icon, fontFamily: 'MaterialIcons'),
                          color: color,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Quick",
                                fontSize: 12.0.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${task.todos?.length ?? 0} Task',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // progress widget
                      CircularStepProgressIndicator(
                        selectedColor: color,
                        unselectedColor: Colors.grey.withOpacity(.4),
                        padding: 0,
                        totalSteps: homeCtrl.isTodosEmpty(task) ? 1 : task.todos!.length,
                        currentStep: homeCtrl.isTodosEmpty(task) ? 0 : homeCtrl.getDoneTodo(task),
                        width: 40,
                        height: 40,
                        roundedCap: (_, isSelected) => isSelected,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
