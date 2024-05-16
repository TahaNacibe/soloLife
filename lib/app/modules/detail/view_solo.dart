import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/data/models/achivments.dart';
import 'package:SoloLife/app/data/models/solo.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/expScal/exp.dart';
import 'package:SoloLife/app/data/services/voiceCommand/service.dart';
import 'package:SoloLife/app/modules/home/widgets/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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
  bool isFree = false;
  @override
  Widget build(BuildContext context) {
    int level = userInfo.level;
    List<Daily> finished =tasks.where((task) => !task.isGoing).toList(); 
    List<Daily> onGoing =tasks.where((task) => task.isGoing).toList(); 
    bool isExist(String name){
      return tasks.any((object) => object.title == name);
    }
    
    final  RxInt totalTodos =
                      tasks.length.obs;
    void addTask(String title,bool free,int getExp,String time,int getCoins){
      tasks.add(
                                    Daily(
                                      isFree: free,
                                      title: title, 
                                      exp: getExp,
                                      coins: getCoins,
                                      timeStamp: time));
    }
    return Scaffold(
      
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
                        Container(
                          decoration:BoxDecoration(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                                color: Theme.of(context).cardColor,
                                boxShadow:[BoxShadow(
                                color: Theme.of(context).shadowColor, // Shadow color
                                spreadRadius: 2, // Extends the shadow beyond the box
                                blurRadius: 5, // Blurs the edges of the shadow
                                offset: const Offset(0, 6), // Moves the shadow slightly down and right
                                )]
                                ),
                          child: Column(children:[Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(padding: const EdgeInsets.all(12),
                                    decoration:const BoxDecoration(
                              //color: Colors.purple,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10))
                                              ),
                                    child: const Icon(
                                      Icons.star,
                                      color: Colors.purple,
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
                              IconButton(onPressed: (){
                                Navigator.popAndPushNamed(context, "HomePage");
                              }, icon: Icon(Icons.close))
                            ],
                          ),
                        
                          Obx(() {
                            return Padding(
                                padding: EdgeInsets.only(
                                  left: 14.0.wp,
                                  right: 14.0.wp,
                                  top: 1.0.wp,
                                ),
                                child: Column(
                                  children: [
                                     Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        actionBarItem("onGoing","${onGoing.length}",Colors.purple,false),
                                        actionBarItem("Finished","${finished.length}",Colors.purple,false),
                                        actionBarItem("Tasks","$totalTodos",Colors.purple,false),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        children: [
                                          
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
                                    ),
                                   
                                  ],
                                ),
                              );
                            }),
                           Padding(
                              padding: const EdgeInsets.symmetric(horizontal:60),
                              child: Divider(color: Theme.of(context).iconTheme.color!.withOpacity(.2),),
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
                            decoration: InputDecoration(
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                  enabledBorder:const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.transparent),),
                                prefixIcon: Padding(
                                padding: const EdgeInsets.only(bottom:10,right: 8),
                                child: GestureDetector(
                                  onTap:(){
                                     isFree = !isFree;
                                    setState((){});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color:isFree? Colors.red : Colors.blue),
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      isFree? "No Exp" : "Exp",
                                    style: TextStyle(
                                      color: isFree? Colors.red : Colors.blue,
                                      fontFamily:"Quick",
                                      fontWeight: FontWeight.w600),),
                                  ),
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
                                        addTask(title, isFree, getExpForTheTasks(level,isFree)*point, time,getCoinsForTheTasks(isFree));
                                              DailyTasks().writeTasks(tasks);
                                              achievementsHandler("world",context);
                                              EasyLoading.showSuccess('Todo item add success');
                                              setState(() {});
                                      }
                                      if(tasks.length == 20){
                                      achievementsHandler("LetHimCock",context);
                                      }
                                      isFree = false;
                                      titleController.clear();
                                     }
                                    },
                                  icon: Container(padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(15),
                                            ),
                                    child: const Icon(Icons.add,color:Colors.white)),
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
            // List of daily tasks
            Padding(
              padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                     Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.0.wp,
                        horizontal: 5.0.wp,
                      ),
                      child: Stack(alignment: Alignment.centerLeft,
                        children: [
                              Divider(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).cardColor,
                          ),
                            child: Text('Ongoing Quests',
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontFamily: "Quick",
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                                    ),
                    if(onGoing.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top:8.0,bottom: 20),
                      child: Text("No Quests Left For Today",style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      fontFamily: "Quick")),
                    ),
                    ReorderableListView.builder(
                        onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item = onGoing.removeAt(oldIndex);
                      onGoing.insert(newIndex, item);
                      tasks = onGoing + finished;
                      widget.dailyTasksController.writeTasks(tasks);
                    });
                  },
                      physics:const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: onGoing.length,
                      itemBuilder: (context, index) {
                        final task = onGoing[index];
                        if(task.standard){
                        Map quest = mainQuests(task.title,level,userInfo.keys!.contains('monster'));
                          return Padding(
                                key: ObjectKey(index),
                              padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 5),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                                                        color: Theme.of(context).cardColor,
                                                        boxShadow:[
                                                        BoxShadow(
                                                        color: Theme.of(context).shadowColor, // Shadow color
                                                        spreadRadius: 2, // Extends the shadow beyond the box
                                                        blurRadius: 5, // Blurs the edges of the shadow
                                                        offset: const Offset(0, 3), // Moves the shadow slightly down and right
                                                        )]
                                                        ),
                              child: Column(
                                key: ValueKey(task.title),
                                children: [
                                  ListTile(
                                    title: Text.rich(
                                      TextSpan(children:[
                                        TextSpan(text:quest['title']),
                                        const TextSpan(text:' ['),
                                        TextSpan(text: "${quest['number']}",style:const TextStyle(color:Colors.purple)),
                                        const TextSpan(text:"]"),
                                         
                                      ]),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Quick"),),
                                      leading: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                          width: 20,
                                                          height: 20,
                                        child: Checkbox(
                                          value: !task.isGoing,
                                                                        onChanged: (value){
                                        task.isGoing = !task.isGoing;
                                        addExp(task.exp,context);
                                        addCoins(task.coins,context);
                                        widget.dailyTasksController.writeTasks(tasks);
                                        setState((){});                      
                                                                        },
                                                                      ),
                                      ),
                                      subtitle: Row(
                                                children: [
                                                Text(task.exp == 0
                                                ? "Side Quest" 
                                                : "Exp :${task.exp}",
                                                style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Quick",
                                                          color:Colors.blue.withOpacity(.8),
                                                          fontSize: 14),),
                                                          if(task.coins != 0)
                                                          Padding(
                                                            padding: const EdgeInsets.only(left:16),
                                                            child: Row(children: [
                                                            Icon(IconPack.rune_stone,color: Colors.orange,),
                                                              Text(" ${task.coins}",
                                                              style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: "Quick",
                                                            fontSize: 14),)
                                                            ],),
                                                          )
                                              ],),
                                  )
                                ],
                              ),
                            ),
                          );
                        }else{
                          Map quest = sideQuests(task.title);
                          bool hasNumber = quest["number"] == " ";
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
                          confirmDismiss: (_) async{
                              bottomShit(context,onGoing[index],(){
                                setState((){});
                              });
                              return false;
                            },
                          child: Padding(
                                key: ObjectKey(index),
                              padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 5),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                                                        color: Theme.of(context).cardColor,
                                                        boxShadow:[
                                                        BoxShadow(
                                                        color: Theme.of(context).shadowColor, // Shadow color
                                                        spreadRadius: 2, // Extends the shadow beyond the box
                                                        blurRadius: 5, // Blurs the edges of the shadow
                                                        offset: const Offset(0, 3), // Moves the shadow slightly down and right
                                                        )]
                                                        ),
                              child: Column(
                                children: [
                                  ListTile(
                                        title: Text.rich(
                                          TextSpan(children:[
                                            TextSpan(text:quest['title']),
                                            if(hasNumber)
                                            const TextSpan(text:' ['),
                                            if(hasNumber)
                                            TextSpan(text: "${quest['number']}",style:const TextStyle(color:Colors.purple)),
                                            if(hasNumber)
                                            const TextSpan(text:"]"),
                                             
                                          ]),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Quick"),),
                                          leading: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                              width: 20,
                                                              height: 20,
                                            child: Checkbox(
                                              value: !task.isGoing,
                                                                            onChanged: (value){
                                            task.isGoing = !task.isGoing;
                                            addExp(task.exp,context);
                                            addCoins(task.coins,context);
                                            widget.dailyTasksController.writeTasks(tasks);
                                            setState((){});                      
                                                                            },
                                                                          ),
                                          ),
                                          subtitle: Row(
                                                    children: [
                                                    Text(task.exp == 0
                                                    ? "Side Quest" 
                                                    : "Exp :${task.exp}",
                                                    style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: "Quick",
                                                              color:Colors.blue.withOpacity(.8),
                                                              fontSize: 14),),
                                                              if(task.coins != 0)
                                                              Padding(
                                                                padding: const EdgeInsets.only(left:16),
                                                                child: Row(children: [
                                                                Icon(IconPack.rune_stone,color: Colors.orange,),
                                                                  Text(" ${task.coins}",
                                                                  style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: "Quick",
                                                                fontSize: 14),)
                                                                ],),
                                                              )
                                                  ],),
                                      ),
                                  
                                ],
                              ),
                            ),
                          ),
                        );
                        }
                        
                      },
                    ),
                    if(finished.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 2.0.wp,
                        horizontal: 5.0.wp,
                      ),
                      child: Stack(alignment: Alignment.centerLeft,
                        children: [
                              Divider(),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).cardColor,
                          ),
                            child: Text('Finished Quests',
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontFamily: "Quick",
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                                    ),
                    ListView.builder(
                      physics:const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: finished.length,
                      itemBuilder: (context, index) {
                        final task = finished[index];
                        if(task.standard){
                        Map quest = mainQuests(task.title,level,userInfo.keys!.contains('monster'));
                          return Padding(
                                key: ObjectKey(index),
                              padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 5),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                                                        color: Theme.of(context).cardColor,
                                                        boxShadow:[
                                                        BoxShadow(
                                                        color: Theme.of(context).shadowColor, // Shadow color
                                                        spreadRadius: 2, // Extends the shadow beyond the box
                                                        blurRadius: 5, // Blurs the edges of the shadow
                                                        offset: const Offset(0, 3), // Moves the shadow slightly down and right
                                                        )]
                                                        ),
                              child: Column(
                                key: ValueKey(task.title),
                                children: [
                                  ListTile(
                                    title: Text.rich(
                                      TextSpan(children:[
                                        TextSpan(text:quest['title']),
                                        const TextSpan(text:' ['),
                                        TextSpan(text: "${quest['number']}",style:const TextStyle(color:Colors.purple)),
                                        const TextSpan(text:"]"),
                                         
                                      ]),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.lineThrough,
                                        fontFamily: "Quick"),),
                                      leading: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                          width: 20,
                                                          height: 20,
                                        child:Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                                      width: 20,
                                                      height: 20,
                                                      child: Icon(Icons.done_all)
                                                    ),
                                      ),
                                      subtitle: Row(
                                                children: [
                                                Text(task.exp == 0
                                                ? "Side Quest" 
                                                : "Exp :${task.exp}",
                                                style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Quick",
                                                          color:Colors.blue.withOpacity(.6),
                                                          fontSize: 14),),
                                                          if(task.coins != 0)
                                                          Padding(
                                                            padding: const EdgeInsets.only(left:16),
                                                            child: Row(children: [
                                                            Icon(IconPack.rune_stone,color: Colors.orange.withOpacity(.6),),
                                                              Text(" ${task.coins}",
                                                              style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: "Quick",
                                                            fontSize: 14),)
                                                            ],),
                                                          )
                                              ],),
                                  )
                                ],
                              ),
                            ),
                          );
                        }else{
                          Map quest = sideQuests(task.title);
                          bool hasNumber = quest["number"] == " ";
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
                          confirmDismiss: (_) async{
                              bottomShit(context,onGoing[index],(){
                                setState((){});
                              });
                              return false;
                            },
                          child: Padding(
                                key: ObjectKey(index),
                              padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 5),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration:BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                                                        color: Theme.of(context).cardColor,
                                                        boxShadow:[
                                                        BoxShadow(
                                                        color: Theme.of(context).shadowColor, // Shadow color
                                                        spreadRadius: 2, // Extends the shadow beyond the box
                                                        blurRadius: 5, // Blurs the edges of the shadow
                                                        offset: const Offset(0, 3), // Moves the shadow slightly down and right
                                                        )]
                                                        ),
                              child: Column(
                                children: [
                                  ListTile(
                                        title: Text.rich(
                                          TextSpan(
                                            children:[
                                            TextSpan(text:quest['title']),
                                            if(hasNumber)
                                            const TextSpan(text:' ['),
                                            if(hasNumber)
                                            TextSpan(text: "${quest['number']}",style:const TextStyle(color:Colors.purple)),
                                            if(hasNumber)
                                            const TextSpan(text:"]"),
                                             
                                          ]),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.lineThrough,
                                            fontFamily: "Quick"),),
                                          leading: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                    ),
                                                              width: 20,
                                                              height: 20,
                                            child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                                      width: 20,
                                                      height: 20,
                                                      child: Icon(Icons.done_all)
                                                    ),
                                          ),
                                          subtitle: Row(
                                                    children: [
                                                    Text(task.exp == 0
                                                    ? "Side Quest" 
                                                    : "Exp :${task.exp}",
                                                    style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: "Quick",
                                                              color:Colors.blue.withOpacity(.6),
                                                              fontSize: 14),),
                                                              if(task.coins != 0)
                                                              Padding(
                                                                padding: const EdgeInsets.only(left:16),
                                                                child: Row(children: [
                                                                Icon(IconPack.rune_stone,color: Colors.orange.withOpacity(.6),),
                                                                  Text(" ${task.coins}",
                                                                  style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: "Quick",
                                                                fontSize: 14),)
                                                                ],),
                                                              )
                                                  ],),
                                      ),
                                  
                                ],
                              ),
                            ),
                          ),
                        );
                        }
                        
                      },
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }

void bottomShit(BuildContext context, Daily element,void Function() refresh) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: 300,
            child: Column(
              children: [
                Stack(alignment: Alignment.bottomCenter,
                  children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.vertical(top:Radius.circular(15) )
                      ),),
                    Align(alignment: Alignment.bottomCenter,
                      child: Icon(Icons.delete_sweep_outlined,color: Colors.red,size: 100,)),
                  ],
                ),
                Container(decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  
                ),
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text.rich(TextSpan(
                          style: TextStyle(
                            fontFamily: "Quick",
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                          children:[
                          TextSpan(
                            text: "Want to delete : ",
                          ),
                          TextSpan(
                            text: "${element.title}",
                            style: TextStyle(
                              color: Colors.red
                            )
                          ),
                          TextSpan(
                            text: "?\n"
                          )
                        ])),
                        Text("You wont get any Exp or Credit if you delete it",
                        style: TextStyle(fontFamily: "Quick",fontWeight: FontWeight.w600),),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                refresh();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color:Colors.blue)
                                ),
                                child: Text("Cancel",
                                style: TextStyle(
                                  fontFamily: "Quick",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.blue,
                                  fontSize: 17),)),
                            ),
                            GestureDetector(
                              onTap: () {
                                tasks.remove(element);
                            widget.dailyTasksController.writeTasks(tasks);
                                achievementsHandler("nuh",context);
                          refresh(); // Refresh the UI
                          Navigator.pop(context); // Close the bottom sheet
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color:Colors.red)
                                ),
                                child: Text("Delete",
                                style: TextStyle(
                                  fontFamily: "Quick",
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red,
                                  fontSize: 17),)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

}

