import 'dart:io';
import 'package:SoloLife/annoncment/updateLoge.dart';
import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/data/models/achivments.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/solo.dart';
import 'package:SoloLife/app/data/models/task.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/modules/home/widgets/add_card.dart';
import 'package:SoloLife/app/modules/home/widgets/add_dialog.dart';
import 'package:SoloLife/app/modules/home/widgets/dream_card.dart';
import 'package:SoloLife/app/modules/home/widgets/task_card.dart';
import 'package:SoloLife/app/modules/home/widgets/user_info_card.dart';
import 'package:SoloLife/app/modules/home/widgets/voltageCard.dart';
import 'package:SoloLife/app/modules/report/viewRepot.dart';
import 'package:SoloLife/main.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'widgets/manager_card.dart';
import 'widgets/solo_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.find<HomeController>();
  File? _profileImage;
  bool isThere = false;
  //? get user profile data
  Profile userInfo = ProfileProvider().readProfile();
  //late File coverPath;
  bool isThereCover = false;
  File cover = File("");
  List<String> defaultKeys = [
    "reverse",
    "master",
    "solo",
    "dream",
    "manager",
    "monster",
    "voltage"
  ];
  List<String> defaultKeysList = [
    "solo",
    "manager",
    "voltage"
  ];
  void coverCheck() {
    Profile user = ProfileProvider().readProfile();
    if (user.coverPath != "") {
      setState(() {
        cover = File(user.coverPath);
        isThereCover = true;
      });
    } else {
      setState(() {
        cover = File("");
        isThereCover = false;
      });
    }
  }

  void _loadImages() {
    final profileImagePath = userInfo.pfpPath;

    setState(() {
      if (File(profileImagePath).existsSync()) {
        _profileImage = File(profileImagePath);
      }
    });
  }

  Color getRankColor(String rank) {
    switch (rank) {
      case "E":
        return Colors.brown[600]!; // Assign bronze color for "E"
      case "D":
        return Colors.green;
      case "C":
        return Colors.blue;
      case "B":
        return Colors.orange;
      case "A":
        return Colors.red;
      case "S":
        return Colors.yellow; // Assign teal color for "S"
      case "SS":
        return Colors.teal; // Assign indigo color for "SS"
      case "SSS":
        return Colors.indigo; // Assign pink color for "SSS"
      case "Z":
        return Colors.purple;
      default:
        return Colors.grey; // default color
    }
  }

  @override
  void initState() {
    super.initState();
    _scheduleDailyNotification();
    _loadImages();
    DailyService().scheduleTaskReset(context);
    // Call the method to check for the cover image existence when the page is initialized
    coverCheck();
  }

  void _scheduleDailyNotification() async {
    Profile user = ProfileProvider().readProfile();
    int strike = user.strike;
    if (user.keys!.contains("solo")) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: strike == 0 ? "Let's start" : "It's almost time",
          body: strike == 0
              ? "Let's get that strike up"
              : "Don't want to lose the $strike Day strike",
          notificationLayout: NotificationLayout.BigPicture,
        ),
        schedule: NotificationCalendar(
          hour: 22,
          minute: 0,
          second: 0,
          millisecond: 0,
          repeats: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadImages();
    coverCheck();
    //? get the necessary information for displaying the profile and cover
    bool theme = ThemeProvider().loadTheme();
    // get frame
    String frame = userInfo.framePath;
    // get user rank
    String rank = userInfo.rank;
    int strike = userInfo.strike;
    List<dynamic> authority = userInfo.keys!;
    bool isBox = !authority.contains("list");
    int count = isBox ? 2 : 1;
    return Scaffold(
      body: Stack(
        children: [
          isThereCover
              ? Container(
                  color: Colors.black.withOpacity(.2),
                  child: Image.file(
                    cover,
                    height: 180,
                    width: MediaQuery.sizeOf(context).width,
                    fit: BoxFit.cover,
                  ))
              : Container(
                  color: Colors.black.withOpacity(.2),
                  child: Image.asset(
                    "assets/images/cover.png",
                    height: 220,
                    width: MediaQuery.sizeOf(context).width,
                    fit: BoxFit.cover,
                  )),
          Obx(
            () => IndexedStack(index: controller.tapIndex.value, children: [
              Stack(
                children: [
                  StatefulBuilder(builder: (context, setState) {
                    return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20, left: 8),
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "Inventory");
                                          },
                                          child: Icon(Icons.backpack,
                                              color: Colors.white, size: 30)),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.popAndPushNamed(
                                          context, "Settings");
                                    },
                                    child: Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                      size: 30,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Stack(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(top: 80),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25)),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: UserInfoCard()),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.popAndPushNamed(
                                              context, "ProfileInformation");
                                        },
                                        child: Consumer(builder:
                                            (context, imageData, child) {
                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 5,
                                                        color: frame != ""
                                                            ? Colors.transparent
                                                            : getRankColor(
                                                                rank),
                                                      ),
                                                      shape: BoxShape.circle),
                                                  child: CircleAvatar(
                                                    radius: 50,
                                                    backgroundImage:
                                                        _profileImage != null
                                                            ? FileImage(
                                                                _profileImage!)
                                                            : AssetImage(
                                                                    'assets/images/giphy.gif')
                                                                as ImageProvider,
                                                  ),
                                                ),
                                              ),
                                              //? the Rank budget
                                              if (frame != "")
                                                Image.asset(
                                                  frame,
                                                  width: 130,
                                                  height: 125,
                                                  fit: BoxFit.cover,
                                                ),
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //!--------------------------------
                                        bottomSheet(strike,context);
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 33),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                      color: strike == 0
                                                          ? Colors.grey
                                                          : Color.fromARGB(255,
                                                                  201, 83, 28)
                                                              .withOpacity(.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .local_fire_department_rounded,
                                                        color: Colors.white,
                                                      ),
                                                      Text(
                                                        " $strike",
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          color: Theme.of(context).cardColor,
                          child: Column(
                            children: [
                              //ToDo change the list to only get the tools
                              if (userInfo.keys!.any(
                                  (element) => defaultKeysList.contains(element)))
                                Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.centerLeft,
                                      children: [
                                        Divider(),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18),
                                          color: Theme.of(context).cardColor,
                                          child: Text(
                                            "Tools",
                                            style: TextStyle(
                                                fontFamily: "Quick",
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    GridView.count(
                                      childAspectRatio: isBox ? 1 : 3.5,
                                      crossAxisCount: count,
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      children: [
                                        if (authority.contains('solo'))
                                          DailyCard(
                                            isBox: isBox,
                                          ),
                                        if (authority.contains('manager'))
                                          ManagerCard(
                                            isBox: isBox,
                                          ),
                                        if (authority.contains('voltage'))
                                          VoltageCard(
                                            isBox: isBox,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Divider(),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 18),
                                        color: Theme.of(context).cardColor,
                                        child: Text(
                                          "Collections",
                                          style: TextStyle(
                                              fontFamily: "Quick",
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => GridView.count(
                                      childAspectRatio: isBox ? 1 : 3.5,
                                      crossAxisCount: count,
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      children: [
                                        if (!userInfo.keys!.contains('reverse'))
                                          AddCard(
                                            change: () {
                                              count == 1
                                                  ? count = 2
                                                  : count = 1;
                                              isBox = !isBox;
                                              isBox
                                                  ? userInfo.keys!
                                                      .remove("list")
                                                  : userInfo.keys!.add("list");
                                              ProfileProvider().saveProfile(
                                                  userInfo, "", context);
                                              setState(() {});
                                            },
                                          ),
                                        ...controller.tasks
                                            .map(
                                              (element) => !(element.title ==
                                                      "Dream Space")
                                                  ? LongPressDraggable(
                                                      data: element,
                                                      onDragStarted: () =>
                                                          controller
                                                              .changeDeleting(
                                                                  true),
                                                      onDraggableCanceled:
                                                          (_, __) =>
                                                              controller
                                                                  .changeDeleting(
                                                                      false),
                                                      onDragEnd: (_) =>
                                                          controller
                                                              .changeDeleting(
                                                                  false),
                                                      feedback: Opacity(
                                                        opacity: 0.8,
                                                        child: TaskCard(
                                                          task: element,
                                                          isBox: isBox,
                                                        ),
                                                      ),
                                                      child: TaskCard(
                                                        task: element,
                                                        isBox: isBox,
                                                      ))
                                                  : DreamCard(
                                                      task: element,
                                                      isBox: isBox,
                                                    ),
                                            )
                                            .toList(),
                                        if (userInfo.keys!.contains('reverse'))
                                          AddCard(
                                            change: () {
                                              count == 1
                                                  ? count = 2
                                                  : count = 1;
                                              isBox = !isBox;
                                              isBox
                                                  ? userInfo.keys!
                                                      .remove("list")
                                                  : userInfo.keys!.add("list");
                                              ProfileProvider().saveProfile(
                                                  userInfo, "", context);
                                              setState(() {});
                                            },
                                          ),
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
                  }),
                ],
              ),
              ReportPage(),
            ]),
          ),
        ],
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              backgroundColor: controller.deleting.value
                  ? Colors.red
                  : theme
                      ? Colors.purple
                      : Colors.blue,
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
                  child: Icon(
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

void bottomSheet(int strike, BuildContext context) {
  showBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: EdgeInsets.only(top: 8),
              padding: EdgeInsets.all(20),
              height: 300,
              decoration: BoxDecoration(
                boxShadow:[BoxShadow(
                                color: Theme.of(context).shadowColor, // Shadow color
                                spreadRadius: 2, // Extends the shadow beyond the box
                                blurRadius: 5, // Blurs the edges of the shadow
                                offset: const Offset(0, 6), // Moves the shadow slightly down and right
                                )],
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.vertical(top:Radius.circular(30))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Container(
                          child: Icon(
                          Icons.local_fire_department,
                          color: Colors.orange,
                          size: 60,
                                                ),
                        ),

                          Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Quick",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                              "$strike\nCurrent Strike"),
                        ],
                      ),
                  Text.rich(
                      style: TextStyle(
                          fontFamily: "Quick",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      TextSpan(children: [
                        TextSpan(text: "You Will"),
                        TextSpan(text: " Lose ", style: TextStyle(color: Colors.red)),
                        TextSpan(
                            text:
                                "Your strike if you failed to complete at least one of your daily Quests"),
                      ])),
                      Divider(),
                  Text(
                    "A penalty will be placed if you fail",
                    style: TextStyle(
                        fontFamily: "Quick",
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
                    ],
                  ),
                    ],
                  ),
            )
          ],
        );
      });
}

/*class HomePage extends GetView<HomeController> {
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
*/
