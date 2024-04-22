import 'package:SoloLife/annoncment/updateLoge.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/modules/home/controller.dart';

import 'widgets/manager_card.dart';
import 'widgets/solo_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    bool theme = ThemeProvider().loadTheme();
    //? get user profile data 
    Profile userInfo = ProfileProvider().readProfile();
    List<dynamic> authority = userInfo.keys!;

    return Scaffold(
      appBar: AppBar(
        actions: [
              //
                if(userInfo.haveMessage)
          IconButton(onPressed: (){
                  updateDialog(context,(){
        });
        userInfo.haveMessage = false;
        ProfileProvider().saveProfile(userInfo, '');
          },icon: Icon(Icons.info,color: Colors.blue,size: 30,))
        ],
        backgroundColor: Theme.of(context).cardColor,
        title: Text("${formatDateTime(DateTime.now(),false)}",
        style: TextStyle(
          fontFamily: "Quick",
        fontWeight: FontWeight.bold),),
      ),
      body: Obx(
        () => IndexedStack(index: controller.tapIndex.value, children: [
          SafeArea(
            child: ListView(
              children: [
               
                UserInfoCard(),
                Obx(
                  () => GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      if(!userInfo.keys!.contains('wail'))
                      AddCard(),
                      if(authority.contains('solo'))
                          DailyCard(),
                          if(authority.contains('manager'))
                          ManagerCard(),
                          if(authority.contains('voltage'))
                          VoltageCard(),
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
                                child: TaskCard(task: element),
                              ),
                              child: TaskCard(task: element)): DreamCard(task:element),)
                          .toList(),
                          if(userInfo.keys!.contains('wail'))
                      AddCard(),
                          
                    ],
                  ),
                )
              ],
            ),
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
                  EasyLoading.showInfo('Please create your taks type');
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
