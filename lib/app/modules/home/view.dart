import 'dart:io';
import 'package:SoloLife/app/data/models/achievements.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/shop_data.dart';
import 'package:SoloLife/app/data/models/task.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/modules/home/widgets/add_card.dart';
import 'package:SoloLife/app/modules/home/widgets/add_dialog.dart';
import 'package:SoloLife/app/modules/home/widgets/dream_card.dart';
import 'package:SoloLife/app/modules/home/widgets/task_card.dart';
import 'package:SoloLife/app/modules/home/widgets/user_info_card.dart';
import 'package:SoloLife/app/modules/home/widgets/voltageCard.dart';
import 'package:SoloLife/app/modules/report/viewRepot.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:provider/provider.dart';
import 'widgets/manager_card.dart';
import 'widgets/solo_card.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // initialize the storage
  final controller = Get.find<HomeController>();

  // initialize the vars
  File? _profileImage;
  bool isThere = false;
  //? get user profile data
  Profile userInfo = ProfileProvider().readProfile();
  // start the check process
  bool isThereCover = false;
  File cover = File("");
  int navigationIndex = 0;
  List<String> defaultKeys = [
    "reverse",
    "master",
    "solo",
    "dream",
    "manager",
    "monster",
    "voltage"
  ];
  // the tools that will be counted on
  List<String> defaultKeysList = ["solo", "manager", "voltage"];

  // check the existing of the cover
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

// load the images for the profile and cover
  void _loadImages() {
    final profileImagePath = userInfo.pfpPath;

    setState(() {
      if (File(profileImagePath).existsSync()) {
        _profileImage = File(profileImagePath);
      }
    });
  }

// get the rank color
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
    missing().scheduleTaskReset(context);
    shopReset(context);
    // Call the method to check for the cover image existence when the page is initialized
    coverCheck();
  }

// the daily notification setUp
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
    _loadImages(); // get the image
    coverCheck(); // load the cover images
    //? get the necessary information for displaying the profile and cover
    bool theme = ThemeProvider().loadTheme();
    // get frame
    String frame = userInfo.framePath;
    // get user rank
    String rank = userInfo.rank;
    int strike = userInfo.strike;
    if (strike == 100) {
      achievementsHandler("flamenation", context);
    }
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
                                                                    'assets/images/cover.png')
                                                                as ImageProvider,
                                                  ),
                                                ),
                                              ),
                                              if (_profileImage == null)
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(.4),
                                                      shape: BoxShape.circle),
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
                                        bottomSheet(strike, context);
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
                              if (userInfo.keys!.any((element) =>
                                  defaultKeysList.contains(element)))
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
                                              achievementsHandler(
                                                  "youCanDoThat", context);
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
                                              achievementsHandler(
                                                  "youCanDoThat", context);
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
      bottomNavigationBar:  AnimatedBottomNavigationBar(
        shadow: Shadow(
          color: Colors.grey.withOpacity(.5),
          offset: Offset(0, 2),
          blurRadius: 8
        ),
          inactiveColor: Theme.of(context).iconTheme.color,
          activeColor: Colors.indigo,
          backgroundColor: Theme.of(context).cardColor,
          onTap: (int index) {
            controller.changeTapIndex(index);
            navigationIndex = index;
            setState(() {});
          },
          splashColor: Theme.of(context).iconTheme.color,
          gapLocation: GapLocation.center,
          elevation: 100,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 15,
          rightCornerRadius: 15,
          activeIndex: navigationIndex,
          icons: [Icons.apps, Icons.data_usage],
        
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
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor, // Shadow color
                      spreadRadius: 2, // Extends the shadow beyond the box
                      blurRadius: 5, // Blurs the edges of the shadow
                      offset: const Offset(
                          0, 6), // Moves the shadow slightly down and right
                    )
                  ],
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
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
                                TextSpan(
                                    text: " Lose ",
                                    style: TextStyle(color: Colors.red)),
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
