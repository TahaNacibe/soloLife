import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/core/values/jobs.dart';
import 'package:SoloLife/app/data/models/achivments.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/expScal/exp.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:spider_chart_updated/spider_chart_updated.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ReportPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  int currentIndex = 1;
  ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserState states = StatesProvider().readState();
    Profile user = ProfileProvider().readProfile();
    List jobs = user.oldJobs!;
    return Scaffold(body: SafeArea(
      child: Obx(() {
        var createdTasks = homeCtrl.getTotalTask();
        var completedTasks = homeCtrl.getTotalDoneTask();
        var onGoingTasks = createdTasks - completedTasks;
        var precent = (completedTasks / createdTasks * 100).toStringAsFixed(0);
        return StatefulBuilder(
          builder: (context,setState) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Container(padding: EdgeInsets.all(15),
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
                    child: Column(
                      children: [
                        Stack(alignment: Alignment.centerLeft,
                  children: [
                    Divider(),
                    Container(
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.all(4.0.wp),
                      child: Text(
                        'Report',
                        style: TextStyle(
                          fontSize: 18.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                        //Icon(Icons.info,color: Colors.indigo,size: 25,),
                        Text("Welcome To Your Data Center Player",
                        style: TextStyle(
                          fontFamily: "Quick",
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),),
                      ],
                    ),
                  ),
                ),
                
                Row(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GestureDetector(
                        onTap:(){
                          currentIndex = 1;
                          setState((){});
                        },
                        child: pageButton("Task Flow",1,currentIndex,context)),
                    ),
                    GestureDetector(
                      onTap:(){
                          currentIndex = 2;
                          setState((){});
                        },
                      child: pageButton("Player",2,currentIndex,context)),
                            
                ],),
                SizedBox(height: 8.0.wp),
                if(currentIndex == 1)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          UnconstrainedBox(
                            child: SizedBox(
                              width: 50.0.wp,
                              height: 50.0.wp,
                              child: CircularStepProgressIndicator(
                                totalSteps: createdTasks == 0 ? 1 : createdTasks,
                                currentStep: completedTasks,
                                stepSize: 10,
                                selectedColor: Colors.indigo,
                                unselectedColor: Colors.grey[200],
                                padding: 0,
                                width: 100,
                                height: 100,
                                selectedStepSize: 11,
                                roundedCap: (_, __) => true,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${createdTasks == 0 ? 0 : precent} %',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo,
                                        fontSize: 20.0.sp,
                                      ),
                                    ),
                                    SizedBox(height: 1.0.wp),
                                    Text(
                                      'Efficiency',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                           Stack(alignment: Alignment.centerLeft,
                      children: [
                        Divider(),
                        Container(
                          color: Theme.of(context).cardColor,
                          padding: EdgeInsets.all(4.0.wp),
                          child: Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildStatus(Colors.orange, 
                                completedTasks,
                                "Tasks you complete", 
                                Icons.done_all_rounded,context),
                                
                                _buildStatus(
                                  Colors.blue, 
                                  onGoingTasks,"OnGoing Tasks", Icons.refresh_rounded,context),
                                
                                _buildStatus(
                                  Colors.indigo, 
                                  createdTasks,"Total Tasks", Icons.task,context),
                                
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
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
                    Icon(IconPack.trophy, color: Colors.indigo,size: 35,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("check your achievements ",
                            style: TextStyle(fontFamily: "Quick",
                            fontSize: 16,
                            fontWeight: FontWeight.bold),),
                            Text("${user.achievements.length} Unlocked ",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontFamily: "Quick",
                            fontSize: 16,
                            fontWeight: FontWeight.bold),),
                          ],
                        ),
                      )
                  ],),)),
              ),
                  ],
                ),
                if(currentIndex == 2)
                Column(
                  children: [
                    
            Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: jobList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                mainAxisExtent: 50,
                mainAxisSpacing: 10,
                  crossAxisCount: 2), 
                  itemBuilder: (context,index){
                    bool isOpen = jobs.contains(jobList[index]['name']);
                    return item(jobList[index]['name'], isOpen, 
                    jobList[index]['Icon'], context,jobList[index]['color'],jobList[index]['text']);
                  }),
            ),
                    Stack(alignment: Alignment.centerLeft,
                  children: [
                    Divider(),
                    Container(
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.all(4.0.wp),
                      child: Text(
                        'Player Status',
                        style: TextStyle(
                          fontSize: 18.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
                padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 12),
                child: Divider(color: Colors.transparent,),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
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
                    Icon(Icons.shopping_cart_rounded, color: Colors.indigo,size: 35,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Text("Open Shop ",
                            style: TextStyle(fontFamily: "Quick",
                            fontSize: 16,
                            fontWeight: FontWeight.bold),),
                            Text("${user.coins} Runes ",
                            style: TextStyle(fontFamily: "Quick",
                            fontSize: 16,
                            fontWeight: FontWeight.bold),),
                          ],
                        ),
                      )
                  ],),)),
              )
                  ],
                ),
                 
              ],
            );
          }
        );
      }),
    ));
  }

  Widget _buildStatus(Color color, int number, String text,IconData icon,BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor,
            
            boxShadow:[BoxShadow(
            color: Theme.of(context).shadowColor, // Shadow color
            spreadRadius: 1, // Extends the shadow beyond the box
            blurRadius: 5, // Blurs the edges of the shadow
            offset: const Offset(0, 3), // Moves the shadow slightly down and right
            )]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
              height: 3.0.wp,
              width: 3.0.wp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 0.5.wp,
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
                        fontSize: 13.0.sp,
                      ),
                    ),
                    SizedBox(height: 1.0.wp),
                    Text(
                      text,
                      style: TextStyle(
                        fontFamily: "Quick",fontWeight: FontWeight.bold,
                        fontSize: 11.0.sp,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Icon(icon,color: Colors.white))
          ],
        ),
      ),
    );
  }
}

Widget stateBar(Color color,String name){
  Color color = name == "solo"? Colors.indigo : name == "dream"? Colors.orange: name == "manager"? Colors.green : Colors.blue;
  return Stack(
    children: [
      Container(
        padding: EdgeInsets.all(35),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
      
      ),
        child:Text(name[0],
        style: TextStyle(
          fontFamily: "Quick",
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white
        ),)),
        Container(color: Colors.white.withOpacity(.2),
          child: Text(name))
    ],
  );
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
Widget pageButton(String title, int index,int currentIndex,BuildContext context){
  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: index == currentIndex? Theme.of(context).iconTheme.color!: Colors.transparent)),
      color: Theme.of(context).cardColor,
     
    ),
    child: Column(
      children: [
        Text(title,
        style: TextStyle(
          fontFamily: "Quick",
          fontSize: 18,
          fontWeight: FontWeight.bold),),
      ],
    ),  );
}

Widget item(String title,bool isOpen,IconData icon,BuildContext context,Color color,String text){
  return GestureDetector(
    onTap:(){
         final snackBar = SnackBar(
        duration: Duration(seconds: 2),
      backgroundColor:color,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text("Title bonce: $text",
            softWrap: true,
            style: TextStyle(
              color: Theme.of(context).iconTheme.color,
                fontWeight: FontWeight.bold,
                fontFamily: "Quick",
                )),
          ),
              Icon(icon)
        ],
      ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    },
    child: Stack(
      children: [
        Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color:color,width: 1.5),
                borderRadius: BorderRadius.circular(15)
              ),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$title",
              style: TextStyle(
                color:color,
                fontSize: 16,
                fontFamily: "Quick",
                fontWeight: FontWeight.bold),
                ),
          Align(alignment: Alignment.centerRight,
            child: Container(
              color:isOpen? Colors.transparent : Theme.of(context).cardColor.withOpacity(.4),
              child: Icon(isOpen? icon : Icons.lock,color: color,),),
          )
            ],
          ),
        ),
      ],
    ),
  );
}