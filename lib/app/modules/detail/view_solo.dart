import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/data/models/solo.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/expScal/exp.dart';
import 'package:SoloLife/app/data/services/voiceCommand/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SoloDetail extends StatefulWidget {
  final DailyTasks dailyTasksController = Get.find<DailyTasks>();

  SoloDetail({super.key});

  @override
  State<SoloDetail> createState() => _SoloDetailState();
}

class _SoloDetailState extends State<SoloDetail> {
  final TextEditingController titleController = TextEditingController();
  List<Daily> tasks = DailyTasks().readTasks();
  @override
  Widget build(BuildContext context) {
    int level = userInfo.level;
    List<Daily> finished =tasks.where((task) => !task.isGoing).toList(); 
    List<Daily> onGoing =tasks.where((task) => task.isGoing).toList(); 
    bool isExist(String name){
      return tasks.any((object) => object.title == name);
    }
    bool isFree = false;
    final  RxInt totalTodos =
                      tasks.length.obs;
    void addTask(String title,bool free,int getExp,String time){
      tasks.add(
                                    Daily(
                                      isFree: free,
                                      title: title, 
                                      exp: getExp,
                                      timeStamp: time));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Tasks'),
        leading: IconButton(onPressed:(){
          Navigator.popAndPushNamed(context, "HomePage");
        }, icon: Icon(Icons.arrow_back)),
      ),
      body: PopScope(
         canPop: false,
 onPopInvoked: (didPop) async {
  if (didPop) {
    return;
  }
         Navigator.popAndPushNamed(context, "HomePage");}
      ,
        child: ListView(
          children: [
            // Add task text field and button
                        Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor,
                        boxShadow:[BoxShadow(
                        color: Theme.of(context).shadowColor, // Shadow color
                        spreadRadius: 2, // Extends the shadow beyond the box
                        blurRadius: 5, // Blurs the edges of the shadow
                        offset: const Offset(0, 3), // Moves the shadow slightly down and right
                        )]
                        ),
                  child: Column(children:[Row(
                    children: [
                      Container(padding: const EdgeInsets.all(12),
                        decoration:const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))
                                  ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 3.0.wp,
                      ),
                      Text(
                        "Daily Quests",
                        style: TextStyle(
                          fontFamily: "Quick",
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                
                  Obx(() {
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 16.0.wp,
                        right: 16.0.wp,
                        top: 3.0.wp,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '$totalTodos Tasks',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 3.0.wp),
                          Expanded(
                              child: StepProgressIndicator(
                                roundedEdges: Radius.circular(15),
                            totalSteps: totalTodos.value == 0 ? 1 : totalTodos.value,
                            currentStep: finished.length,
                            size: 5,
                            padding: 0,
                            selectedGradientColor: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.purple.withOpacity(0.5), Colors.purple],
                            ),
                            unselectedGradientColor: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.grey[300]!, Colors.grey[300]!],
                            ),
                          ))
                        ],
                      ),
                    );
                  }),
                   Divider(
                    color: Theme.of(context).iconTheme.color!.withOpacity(.4),
                  ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 1.0.wp,
                  horizontal: 5.0.wp,
                ),
                child: Center(
                  child: TextFormField(
                    cursorColor: Theme.of(context).iconTheme.color,
                    controller: titleController,
                    autofocus: true,
                    decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                          enabledBorder:const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom :10),
                          child: Icon(
                            Icons.check_box_outline_blank,
                            color: Colors.grey[400],
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            String title = titleController.text;
                            if (title.isNotEmpty) {
                             int point = userInfo.keys!.contains("monster")? 2 : 1;
                              if(isExist(title)){
                                EasyLoading.showError('Todo item already exists');
                                setState((){});
                              }else{
                                String time = DateTime.now().toIso8601String();
                                
                                  if (title.contains("--free")) {
                                  title = title.replaceAll("--free", "");
                                  isFree = true;
                              }
                                addTask(title, isFree, getExpForTheTasks(level,isFree)*point, time);
                                      DailyTasks().writeTasks(tasks);
                                      EasyLoading.showSuccess('Todo item add success');
                                      setState(() {});
                              }
                              titleController.clear();
                             }
                            },
                          icon: Container(padding: const EdgeInsets.all(12),
                          decoration:const BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle
                                    ),
                            child: const Icon(Icons.done,color:Colors.white)),
                        )),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the quest title';
                      }
                      return null;
                    },
                  ),
                ),
              ),]),
                ),
              ),
            // List of daily tasks
            Padding(
              padding: const EdgeInsets.all(8.0),
                child: Container(padding: const EdgeInsets.all(12),
                    decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black.withOpacity(.2)),
                          color: Theme.of(context).cardColor,
                          boxShadow:[BoxShadow(
                          color: Theme.of(context).shadowColor, // Shadow color
                          spreadRadius: 2, // Extends the shadow beyond the box
                          blurRadius: 5, // Blurs the edges of the shadow
                          offset: const Offset(0, 3), // Moves the shadow slightly down and right
                          )]
                          ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top:8.0),
                      child: Text("Current Quests",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Quick")),
                    ),
                    if(onGoing.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top:8.0,bottom: 20),
                      child: Text("No Quests Left For Today",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Quick")),
                    ),
                    ListView.builder(
                      physics:const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: onGoing.length,
                      itemBuilder: (context, index) {
                        final task = onGoing[index];
                        if(task.standard){
                        Map quest = mainQuests(task.title,level,userInfo.keys!.contains('monster'));
                          return Column(
                            children: [
                              CheckboxListTile(
                                title: Text.rich(
                                  TextSpan(children:[
                                    TextSpan(text:quest['title']),
                                    const TextSpan(text:' ['),
                                    TextSpan(text: "${quest['number']}",style:const TextStyle(color:Colors.purple)),
                                    const TextSpan(text:"]")
                                  ]),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Quick"),),
                                    subtitle: Text(task.exp == 0? "Free Quest" : "Exp :${task.exp}"
                                    ,style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:Colors.blue,
                                    fontFamily: "Quick")),
                                value: !task.isGoing, // Checkbox value negation for completed tasks
                                onChanged: (value){
                                  task.isGoing = !task.isGoing;
                                  addExp(task.exp);
                                  widget.dailyTasksController.writeTasks(tasks);
                                  setState((){});                      
                                },
                              ),
                               Padding(
                                padding: EdgeInsets.symmetric(horizontal: 60),
                                child: Divider(
                                  color: Theme.of(context).iconTheme.color!.withOpacity(.4),
                                ),
                              )
                            ],
                          );
                        }else{
                          Map quest = sideQuests(task.title);
                          return Dismissible(
                          key: ValueKey(task.title),
                          background: Container(
                            color: Colors.red.withOpacity(0.8),
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 5.0.wp),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onDismissed: (_){
                            if(!task.standard){
                            tasks.remove(onGoing[index]);
                            widget.dailyTasksController.writeTasks(tasks);
                            setState((){});
                            }
                          },
                          child: Column(
                            children: [
                              CheckboxListTile(
                                title: Text.rich(
                                  TextSpan(children:[
                                    TextSpan(text:quest['title']),
                                    if(quest['number'] != "")
                                    const TextSpan(text:'  ['),
                                    if(quest['number'] != "")
                                    TextSpan(text: "${quest['number']}",style:const TextStyle(color:Colors.purple)),
                                    if(quest['number'] != "")
                                    const TextSpan(text:"]")
                                  ]),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Quick"),),
                                        subtitle: Text(task.exp == 0? "Free Quest" : "Exp :${task.exp}",
                                        style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:Colors.blue,
                                    fontFamily: "Quick")),
                                value: !task.isGoing, // Checkbox value negation for completed tasks
                                onChanged: (value){
                                  task.isGoing = !task.isGoing;
                                  addExp(task.exp);
                                  widget.dailyTasksController.writeTasks(tasks);
                                  setState((){});                      
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 60),
                                child: Divider(),
                              )
                            ],
                          ),
                        );
                        }
                        
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top:8.0),
                      child: Text('Finished Quests',
                      style:  TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Quick")),
                    ),
                    ListView.builder(
                      physics:const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: finished.length,
                      itemBuilder: (context, index) {
                        final task = finished[index];
                        if(task.standard){
                        Map quest = mainQuests(task.title,level,userInfo.keys!.contains('monster'));
                        print("=================$quest");
                          return Column(
                            children: [
                              ListTile(
                                title: Text.rich(
                                  TextSpan(children:[
                                    TextSpan(text:quest['title']),
                                    const TextSpan(text:'  ['),
                                    TextSpan(text: "${quest['number']}",style:const TextStyle(color:Colors.purple)),
                                    const TextSpan(text:"]")
                                  ]),
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Quick"),),
                                    //
                                    subtitle: Text(task.exp == 0? "Free Quest" : "Exp :${task.exp}",
                                        style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:Colors.grey,
                                    fontFamily: "Quick")),
                                //
                                trailing: const Icon(Icons.done,color:Colors.blue),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 60),
                                child: Divider(),
                              )
                            ],
                          );
                        }else{
                          Map quest = sideQuests(task.title);
                          return Dismissible(
                          key: ValueKey(task.title),
                          background: Container(
                            color: Colors.red.withOpacity(0.8),
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 5.0.wp),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onDismissed: (_){
                            if(!task.standard){
                            tasks.remove(finished[index]);
                            widget.dailyTasksController.writeTasks(tasks);
                            }
                          },
                          child: Column(
                            children: [
                              ListTile(
                                title: Text.rich(
                                  TextSpan(children:[
                                    TextSpan(text:quest['title']),
                                    if(quest['number'] != "")
                                    const TextSpan(text:'  ['),
                                    if(quest['number'] != "")
                                    TextSpan(text: "${quest['number']}",style:const TextStyle(color:Colors.purple)),
                                    if(quest['number'] != "")
                                    const TextSpan(text:"]")
                                  ]),
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Quick"),),
                                    subtitle: Text(task.exp == 0? "Free Quest" : "Exp :${task.exp}",
                                        style: const TextStyle(
                                          
                                    fontWeight: FontWeight.bold,
                                    color:Colors.grey,
                                    fontFamily: "Quick")),
                                trailing: const Icon(Icons.done,color:Colors.blue),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 60),
                                child: Divider(),
                              )
                            ],
                          ),
                        );
                        }
                        
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
