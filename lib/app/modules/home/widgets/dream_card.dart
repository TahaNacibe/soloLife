import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/data/models/task.dart';
import 'package:SoloLife/app/modules/detail/view_dream.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';


class DreamCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  final Task task;
  DreamCard({super.key, required this.task});

 @override
  Widget build(BuildContext context) {
    var squareWidth = Get.width - 12.0.wp;
    return GestureDetector(
      onTap: () {
        homeCtrl.changeTask(task);
        homeCtrl.changeTodos(task.todos ?? []);
        Get.to(() => DreamPage());
      },
      child: Container(
        width: squareWidth / 2,
        height: squareWidth /2,
        margin: EdgeInsets.all(2.0.wp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor, boxShadow: [
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
              totalSteps: homeCtrl.isTodosEmpty(task) ? 1 : task.todos!.length,
              currentStep:
                  homeCtrl.isTodosEmpty(task) ? 0 : homeCtrl.getDoneTodo(task),
              size: 5,
              padding: 0,
              selectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.orange.withOpacity(0.5), Colors.orange],
              ),
              unselectedGradientColor: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(6.0.wp,6.0.wp,6.0.wp,7.0.wp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
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
                    '${task.todos?.length ?? 0} Task',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                ],
              ),
            ),
            Align(alignment: Alignment.bottomRight,
              child: Container(
                decoration:BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomRight: Radius.circular(15))
                ),
                
                child: Padding(
                padding: EdgeInsets.all(6.0.wp),
                child: Icon(Icons.lock,
                  color: Colors.white,
                ),
                            ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
