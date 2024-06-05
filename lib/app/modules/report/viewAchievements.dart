import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/data/models/achievements.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class AchievementsPage extends StatefulWidget {
  final String title;
  const AchievementsPage({super.key, this.title = ""});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  // initialize the vars
  Profile user = ProfileProvider().readProfile();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // check for the scroll to item
    if (widget.title != "") {
      final index = achievementsArchive.values
          .toList()
          .indexWhere((item) => item.title == widget.title);
      // Scroll to the specific item after the first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToItem(index);
      });
    }
  }

// get the item location based on it's index
  void _scrollToItem(int index) {
    index = index > 52 ? 52 : index;
    double position = index * 115.0; // Assuming each item has a fixed height
    _scrollController.animateTo(
      position,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

// remove the controller
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // initialize the vars
    List<dynamic> yourAchievements = user.achievements;
    List<dynamic> achievements = achievementsArchive.values.toList();
    int percent = (yourAchievements.length * 100) ~/ achievements.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Achievements",
          style: TextStyle(fontFamily: "Quick", fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            septateLine("Statics"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor, // Shadow color
                        spreadRadius: 1, // Extends the shadow beyond the box
                        blurRadius: 5, // Blurs the edges of the shadow
                        offset: const Offset(
                            0, 3), // Moves the shadow slightly down and right
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // the open achievement count widget
                    CircularStepProgressIndicator(
                      totalSteps: achievements.length,
                      currentStep: yourAchievements.length,
                      stepSize: 8,
                      selectedColor: Colors.indigo,
                      unselectedColor: Colors.blueGrey.withOpacity(.1),
                      padding: 0,
                      width: 100,
                      height: 100,
                      selectedStepSize: 15,
                      roundedCap: (_, __) => true,
                      child: Center(
                          child: Text(
                        "$percent%",
                        style: TextStyle(
                            fontFamily: "Quick",
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )),
                    ),
                    // the states here
                    Text.rich(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Quick",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        TextSpan(children: [
                          TextSpan(
                              text: "${yourAchievements.length}\n",
                              style: TextStyle(color: Colors.indigo)),
                          TextSpan(text: "Unlocked")
                        ])),
                    Text.rich(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Quick",
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        TextSpan(children: [
                          TextSpan(
                              text: "${achievements.length}\n",
                              style: TextStyle(color: Colors.indigo)),
                          TextSpan(text: "Total"),
                        ])),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text.rich(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Quick",
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          TextSpan(children: [
                            TextSpan(
                                text:
                                    "${achievements.length - yourAchievements.length}\n",
                                style: TextStyle(color: Colors.indigo)),
                            TextSpan(text: "Locked"),
                          ])),
                    ),
                  ],
                ),
              ),
            ),
            septateLine("Achievement"),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  brief item = achievements[index]!;
                  bool isOpen = yourAchievements.contains(item.id);
                  bool isHidden = item.isHidden;
                  if (isHidden && !isOpen) {
                    return Container();
                  } else {
                    return achievementItem(
                        item.title, item.rarity, item.description, isOpen);
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget achievementItem(
      String title, int rarity, String description, bool isOpen) {
    Color color = rarity == 7
        ? Colors.purple
        : rarity == 6
            ? Colors.red
            : rarity == 5
                ? Colors.orange
                : rarity == 4
                    ? Colors.blue
                    : Colors.brown;
    description =
        isOpen && rarity == 7 ? "Surpass all the limits" : description;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor, // Shadow color
                      spreadRadius: 1, // Extends the shadow beyond the box
                      blurRadius: 5, // Blurs the edges of the shadow
                      offset: const Offset(
                          0, 3), // Moves the shadow slightly down and right
                    )
                  ]),
              child: ListTile(
                title: Text(
                  isOpen ? title : "????",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: "Quick"),
                ),
                subtitle: Text(
                  description,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontFamily: "Quick"),
                ),
                trailing: SizedBox(
                    width: 40,
                    height: 40,
                    child: isOpen
                        ? Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Icon(
                                  Icons.star,
                                  color: color,
                                ),
                              ),
                              Text("$rarity",
                                  style: TextStyle(
                                      color: color,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Quick")),
                            ],
                          )
                        : Icon(Icons.lock, color: color)),
                leading: Icon(
                  IconPack.trophy,
                  color: color,
                  size: 50,
                ),
              )),
        ),
        if (!isOpen)
          Positioned.fill(
            child: Container(
              color: Theme.of(context).cardColor.withOpacity(.6),
            ),
          )
      ],
    );
  }

  Widget septateLine(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Divider(),
          Container(
              padding: EdgeInsets.all(8),
              color: Theme.of(context).cardColor,
              child: Text(
                title,
                style: TextStyle(
                    fontFamily: "Quick",
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              )),
        ],
      ),
    );
  }
}
