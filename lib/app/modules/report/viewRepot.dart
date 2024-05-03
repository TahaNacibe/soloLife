import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/core/values/colors.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/expScal/exp.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:spider_chart_updated/spider_chart_updated.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ReportPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserState states = StatesProvider().readState();
    return Scaffold(body: SafeArea(
      child: Obx(() {
        var createdTasks = homeCtrl.getTotalTask();
        var completedTasks = homeCtrl.getTotalDoneTask();
        var precent = (completedTasks / createdTasks * 100).toStringAsFixed(0);
        return ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0.wp),
              child: Text(
                'My Report',
                style: TextStyle(
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0.wp,
              ),
              child: Divider(thickness: 1,
              color: Theme.of(context).iconTheme.color!.withOpacity(.4),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Task Flow",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,fontFamily: "Quick"),),
            ),
            SizedBox(height: 8.0.wp),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  UnconstrainedBox(
                    child: SizedBox(
                      width: 35.0.wp,
                      height: 35.0.wp,
                      child: CircularStepProgressIndicator(
                        totalSteps: createdTasks == 0 ? 1 : createdTasks,
                        currentStep: completedTasks,
                        stepSize: 10,
                        selectedColor: green,
                        unselectedColor: Colors.grey[200],
                        padding: 0,
                        width: 75,
                        height: 75,
                        selectedStepSize: 11,
                        roundedCap: (_, __) => true,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${createdTasks == 0 ? 0 : precent} %',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0.sp,
                              ),
                            ),
                            SizedBox(height: 1.0.wp),
                            Text(
                              'Efficiency',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 6.0.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatus(Colors.orange, completedTasks, 'Completed'),
                        _buildStatus(Colors.blue, createdTasks, 'Created'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Player Status",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,fontFamily: "Quick"),),
            ),
             Padding(
                          padding: const EdgeInsets.only(top:30),
                          child: Center(
            child: Container(
              width: 200,
              height: 200,
              child: SpiderChartUpdated(
                labels: [
                  "agility",
                  "intelligence",
                  "mana",
                  "sense",
                  "strength",
                  "vitality",
                           ],
                data: [
                  states.agility.toDouble(),
                  states.intelligence.toDouble(),
                  states.mana.toDouble(),
                  states.sense.toDouble(),
                  states.strength.toDouble(),
                  states.vitality.toDouble(),
                ],
                maxValue: getTotalPoint(states).toDouble(), // the maximum value that you want to represent (essentially sets the data scale of the chart)
                colors: <Color>[
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.teal,
                  Colors.yellow,
                  Colors.indigo,
                ],
              ),
            ),
                          ),
                        ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80,horizontal: 12),
            child: GestureDetector(
              onTap:(){
                 Navigator.pushNamed(context, "achievements");
              },
              child: Container(
                padding: EdgeInsets.all(15),
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
                child:
              Row(children: [
                Image.asset(
                  width: 120,
                  height: 120,
                  "assets/images/trophy.png"),
                  Text("check your achievements here ",style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold),)
              ],),)),
          ),
          Padding(
            padding: const EdgeInsets.all(40),
            child: GestureDetector(
              onTap:(){
                 Navigator.pushNamed(context, "Shop");
              },
              child: Container(
                padding: EdgeInsets.all(15),
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
                child:
              Row(children: [
                  Text("Shop ",style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.bold),)
              ],),)),
          )
          ],
        );
      }),
    ));
  }

  Row _buildStatus(Color color, int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 2.0.wp,
          width: 2.0.wp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 0.25.wp,
              color: color,
            ),
          ),
        ),
        SizedBox(width: 2.0.wp),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0.sp,
              ),
            ),
            SizedBox(height: 1.0.wp),
            Text(
              text,
              style: TextStyle(
                fontSize: 10.0.sp,
                color: Colors.grey,
              ),
            )
          ],
        )
      ],
    );
  }
}

int getTotalPoint(UserState states){
  return states.agility+states.intelligence+states.mana+states.sense+states.strength+states.vitality;
}

Widget titleBar(
  String name,
  int state,
  int defaultState,
  Color advance,
  BuildContext context,
  String stateRequired){
 bool result = state < defaultState;
  return GestureDetector(
    onTap: (){
      final snackBar = SnackBar(
        duration: Duration(seconds: 1),
      backgroundColor:advance,
      content: Text(result? "Required $stateRequired : $defaultState" : "Is That Your Limit ?",
      style: TextStyle(
        color: Theme.of(context).iconTheme.color,
    fontWeight: FontWeight.bold,
    fontFamily: "Quick",
    )));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    },
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 2,
              color:advance)
          ),
          child: Stack(
            children: [
              Text(name,
              style: TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                color: advance),),
                if(result)
              Align(alignment: Alignment.centerRight,
                child: Container(decoration: BoxDecoration(
                  color: Theme.of(context).cardColor
                ),
                  child: Icon(Icons.lock,color: advance,)),
              )
            ],
          ),
        ),
        if(result)
        Container(color: Theme.of(context).cardColor.withOpacity(.4),)
      ],
    ),
  );
}


Widget titleBarMax(
  String name,
  UserState state,
  Color advance,
  BuildContext context,){
 bool result = checkState(UserState(intelligence: 1000,agility: 1000,sense: 1000,strength: 1000,mana: 1000,vitality: 1000),state);
  return GestureDetector(
    onTap: (){
      final snackBar = SnackBar(
        duration: Duration(seconds: 1),
      backgroundColor:advance,
      content: Text(result? "Required All Status 1000" :"You are Now The New Origin",
      style: TextStyle(
        color: Theme.of(context).iconTheme.color,
    fontWeight: FontWeight.bold,
    fontFamily: "Quick",
    )));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    },
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 2,
              color:advance)
          ),
          child: Stack(
            children: [
              Text(name,
              style: TextStyle(
                fontFamily: "Quick",
                fontWeight: FontWeight.bold,
                color: advance),),
                if(result)
              Align(alignment: Alignment.centerRight,
                child: Container(decoration: BoxDecoration(
                  color: Theme.of(context).cardColor
                ),
                  child: Icon(Icons.lock,color: advance,)),
              )
            ],
          ),
        ),
        if(result)
        Container(color: Theme.of(context).cardColor.withOpacity(.4),)
      ],
    ),
  );
}