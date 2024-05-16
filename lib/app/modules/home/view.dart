import 'dart:io';

import 'package:SoloLife/annoncment/updateLoge.dart';
import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/data/models/achivments.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/task.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/modules/home/widgets/add_card.dart';
import 'package:SoloLife/app/modules/home/widgets/add_dialog.dart';
import 'package:SoloLife/app/modules/home/widgets/dream_card.dart';
import 'package:SoloLife/app/modules/home/widgets/task_card.dart';
import 'package:SoloLife/app/modules/home/widgets/user_info_card.dart';
import 'package:SoloLife/app/modules/home/widgets/voltageCard.dart';
import 'package:SoloLife/app/modules/report/viewRepot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/manager_card.dart';
import 'widgets/solo_card.dart';

class HomePage extends GetView<HomeController> {
   HomePage({super.key});

  //late File coverPath;
  bool isThereCover = false;
  List<String> defaultKeys = ["reverse","master","solo","dream","manager","monster","voltage"];
    Future<bool> coverCheck(String text){
      return File(text).exists();
    }
  @override
  Widget build(BuildContext context) {
    bool theme = ThemeProvider().loadTheme();
    coverCheck("/data/user/0/com.example.dreamseaker/app_flutter/cover_image.png").then((value){
      isThereCover = value;
    });
    //? get user profile data 
    Profile userInfo = ProfileProvider().readProfile();
    List<dynamic> authority = userInfo.keys!;
    bool isBox = !authority.contains("list");
    int count = isBox? 2 : 1;
    return Scaffold(
     
      body: Obx(
        () => IndexedStack(index: controller.tapIndex.value, 
        children: [
          Stack(
            children: [
              
              FutureBuilder(
                future: coverCheck("/data/user/0/com.example.dreamseaker/app_flutter/cover_image.png"),
                builder: (context,snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      if(!snapshot.data!)
                      Container(color: Colors.black.withOpacity(.2),
                        child: Image.asset("assets/images/cover.png",height: 180,width: MediaQuery.sizeOf(context).width,fit: BoxFit.cover,)),
                      if(snapshot.data!)
                      Container(color: Colors.black.withOpacity(.2),
                        child: Image.file(File("/data/user/0/com.example.dreamseaker/app_flutter/cover_image.png"),height: 180,width: MediaQuery.sizeOf(context).width,fit: BoxFit.cover,)),
                    ],
                  );
                  }else if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.none){
                    return Container();
                  }else{
                    return Container();
                  }
                }
              ),
              StatefulBuilder(
                builder: (context,setState) {
                  return ListView(
                    children: [
                     Padding(
                    padding: const EdgeInsets.only(top:10),
                    child: Align(alignment: Alignment.topRight,
                      child: Row(
                        children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 20,left: 8),
                              child: GestureDetector(
                                onTap:(){
                                  Navigator.pushNamed(context, "Inventory");
                                },
                                child: Icon(Icons.backpack,color: Colors.white,size:30)),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap:(){
                                  Navigator.popAndPushNamed(context, "Settings");
                                },
                          child: Icon(Icons.settings,color:Colors.white,size: 30,))],),
                    ),
                  ),
                      Stack(
                        children: [
                        
                          
                          Stack(
                            children: [
                              Container(
                              margin: EdgeInsets.only(top: 70),
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top:Radius.circular(25)),
                                color: Theme.of(context).cardColor,
                              ),
                                child: UserInfoCard()),
                                
                            ],
                          ),
                        ],
                      ),
                      Container(color: Theme.of(context).cardColor,
                      
                        child: Column(
                          children: [
                            //ToDo change the list to only get the tools
                            if(userInfo.keys!.any((element) => defaultKeys.contains(element)))
                            Column(
                              children: [
                              Stack(alignment: Alignment.centerLeft,
                                children: [
                                  Divider(),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 18),
                                    color: Theme.of(context).cardColor,
                                    child: Text(
                                    "Tools",
                                    style: TextStyle(
                                    fontFamily:"Quick",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),
                                GridView.count(
                                    childAspectRatio :isBox? 1 : 3.5,
                                    crossAxisCount: count,
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    children: [
                                      if(authority.contains('solo'))
                                          DailyCard(isBox: isBox,),
                                          if(authority.contains('manager'))
                                          ManagerCard(isBox:isBox,),
                                          if(authority.contains('voltage'))
                                          VoltageCard(isBox: isBox,),
                                    ],
                                  
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Stack(alignment: Alignment.centerLeft,
                                children: [
                                  Divider(),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 18),
                                    color: Theme.of(context).cardColor,
                                    child: Text(
                                    "Collections",
                                    style: TextStyle(
                                    fontFamily:"Quick",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              ),
                                Obx(
                                  () => GridView.count(
                                    
                                    childAspectRatio :isBox? 1 : 3.5,
                                    crossAxisCount: count,
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    children: [
                                      
                                      if(!userInfo.keys!.contains('reverse'))
                                      AddCard(change:(){
                                        count == 1? count = 2 : count = 1;
                                        isBox = !isBox;
                                        isBox? userInfo.keys!.remove("list") :userInfo.keys!.add("list");
                                        ProfileProvider().saveProfile(userInfo,"",context);
                                        setState((){});
                                      },),
                                      ...controller.tasks
                                          .map((element) => !(element.title == "Dream Space")? LongPressDraggable(
                                              data: element,
                                              onDragStarted: () =>
                                                  controller.changeDeleting(true),
                                              onDraggableCanceled: (_, __) =>
                                                  controller.changeDeleting(false),
                                              onDragEnd: (_) =>
                                                  controller.changeDeleting(false),
                                              feedback: Opacity(
                                                opacity: 0.8,
                                                child: TaskCard(task: element, isBox:isBox,),
                                              ),
                                              child: TaskCard(task: element,isBox:isBox,)): DreamCard(task:element,isBox: isBox,),)
                                          .toList(),
                                          if(userInfo.keys!.contains('reverse'))
                                      AddCard(change:(){
                                        count == 1? count = 2 : count = 1;
                                        isBox = !isBox;
                                         isBox? userInfo.keys!.remove("list") :userInfo.keys!.add("list");
                                        ProfileProvider().saveProfile(userInfo,"",context);
                                        setState((){});
                                      },),
                                          
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
              ),
            ],
          ),
          ReportPage(),
        ]),
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              backgroundColor:
                  controller.deleting.value ? Colors.red : theme? Colors.purple : Colors.blue,
              onPressed: () {

                if (controller.tasks.isNotEmpty) {
                  Get.to(() => AddDialog(), transition: Transition.downToUp);
                } else {
                  EasyLoading.showInfo('Please create your task type');
                }
              },
              child: Icon(
                controller.deleting.value ? Icons.delete : Icons.add,
                color: Colors.white,
              ),
              shape: const CircleBorder(),
            ),
          );
        },
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess('Delete Success');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(
          () => BottomNavigationBar(
            backgroundColor: Theme.of(context).cardColor,
            elevation: 2,
            onTap: (int index) => controller.changeTapIndex(index),
            currentIndex: controller.tapIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Padding(
                  padding: EdgeInsets.only(right: 15.0.wp),
                  child: Icon(
                    color: Theme.of(context).iconTheme.color,
                    Icons.apps,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Report',
                icon: Padding(
                  padding: EdgeInsets.only(left: 15.0.wp),
                  child:  Icon(
                    color: Theme.of(context).iconTheme.color,
                    Icons.data_usage,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
