import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:SoloLife/app/modules/report/viewAchivments.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Achievements {
  String title;
  String type;
  String id;
  int rarity;
  String description;
  bool isHidden;

  Achievements({
    required this.title,
    required this.type,
    required this.id,
    required this.rarity,
    this.description = "no Description for that item",
    this.isHidden = false,
  });
}

void achievementsHandler(String type, BuildContext context) {
  Profile user = ProfileProvider().readProfile();
  List<dynamic> achievements = user.achievements;
  String result = achievementWatcher(type).trim();
  if (result.isNotEmpty) {
    if (!achievements.contains(result)) {
        user.achievements.add(result);
      Achievements current = achievementsArchive[result]!;
      int expCount = current.rarity == 7
          ? 150000
          : current.rarity == 6
              ? 1000
              : current.rarity == 5
                  ? 500
                  : current.rarity == 4
                      ? 250
                      : 100;
      user.coins += expCount;
      achievementsDialog(context, current.title, current.rarity, expCount);
      ProfileProvider().saveProfile(user, "exp", context);
    }
    //
  }
}

void achievementsDialog(
    BuildContext context, String achievementName, int rarity, int coin) {
  Color color = rarity == 7
      ? Colors.purple
      : rarity == 6
          ? Colors.red
          : rarity == 5
              ? Colors.orange
              : rarity == 4
                  ? Colors.blue
                  : Colors.brown;
  String prize = rarity == 7
      ? "15K"
      : rarity == 6
          ? "5k"
          : rarity == 5
              ? "1k"
              : rarity == 4
                  ? "500"
                  : "250";
  AnimatedSnackBar(
    builder: ((context) {
      return GestureDetector(
        onTap: () {
          print("=========================$achievementName");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AchievementsPage(title: achievementName),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: color, width: 0.5),
              color: color.withOpacity(.9),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(.5), // Shadow color
                  spreadRadius: 1, // Extends the shadow beyond the box
                  blurRadius: 5, // Blurs the edges of the shadow
                  offset: const Offset(
                      0, 3), // Moves the shadow slightly down and right
                )
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Icon(
                      IconPack.trophy,
                      color: Colors.white,
                      size: 33,
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: Text.rich(
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                        TextSpan(children: [
                          TextSpan(
                            text: 'Achievement Unlocked!\n',
                            style: TextStyle(
                                fontFamily: "Quick",
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          TextSpan(
                            text: achievementName,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Quick"),
                          )
                        ])),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      IconPack.rune_stone,
                      color: Colors.white,
                      size: 20,
                    ),
                    Text(
                      "+$prize",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quick",
                          color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }),
  ).show(context);
}

String achievementWatcher(String type) {
  final homeCtrl = Get.find<HomeController>();
  var completedTasks = homeCtrl.getTotalDoneTask();
  int allTasks = homeCtrl.getTotalTask();
  var ongoingTasks = allTasks - completedTasks;

  Profile user = ProfileProvider().readProfile();
  UserState state = StatesProvider().readState();
  var properties = state.toJson().entries;

  if (type == "state") {
    String result = "";
    for (var element in properties) {
      int value = int.tryParse(element.value.toString()) ?? 0;
      if (value >= 1000) {
        if (!user.achievements.contains("${element.key}3")) {
          result = "${element.key}3\n";
        } else {
          continue;
        }
      } else if (value >= 500) {
        if (!user.achievements.contains("${element.key}2")) {
          result = "${element.key}2\n";
        } else {
          continue;
        }
      } else if (value >= 100) {
        if (!user.achievements.contains("${element.key}1")) {
          result = "${element.key}1\n";
        } else {
          continue;
        }
      }
    }
    return result.trim(); // Return the accumulated result after the loop
  } else if (type == "done") {
    if (completedTasks >= 1000) {
      return "Finished1000";
    } else if (completedTasks >= 500) {
      return "Finished500";
    } else if (completedTasks >= 300) {
      return "Finished300";
    } else if (completedTasks >= 100) {
      return "Finished100";
    }
  } else if (type == "ongoing") {
    if (ongoingTasks >= 1000) {
      return "onGoing1000";
    } else if (ongoingTasks >= 500) {
      return "onGoing500";
    } else if (ongoingTasks >= 300) {
      return "onGoing300";
    } else if (ongoingTasks >= 100) {
      return "onGoing100";
    }
  } else if (type == "all") {
    if (allTasks >= 1200) {
      return "Create1000";
    } else if (allTasks >= 600) {
      return "Create500";
    } else if (allTasks >= 400) {
      return "Create300";
    } else if (allTasks >= 200) {
      return "Create100";
    }
  } else if (type == "coins") {
    if (user.coins >= 100000) {
      return "Rich";
    } else if (user.coins == 0 && user.level != 1) {
      return "Broke";
    }
  } else if (type == "level") {
    if (user.level >= 10000) {
      return "Level10000";
    } else if (user.level >= 500) {
      return "Level500";
    } else if (user.level >= 100) {
      return "Level100";
    } else if (user.level >= 40) {
      return "Level40";
    } else if (user.level >= 5) {
      return "Level5";
    } else if (user.level >= 1) {
      return "Level1";
    }
  } else if (type == "job") {
    if (user.job == "Fighter") {
      return "Fighter";
    } else if (user.job == "Healer") {
      return "Healer";
    } else if (user.job == "Ranger") {
      return "Ranger";
    } else if (user.job == "Assassin") {
      return "Assassin";
    } else if (user.job == "Mage") {
      return "Mage";
    } else if (user.job == "Tanker") {
      return "Tanker";
    } else if (user.job == "Necromancer") {
      return "Necromancer";
    }
  } else if (type == "mood") {
    if (user.keys!.contains("solo") && !user.achievements.contains("solo")) {
      return "solo";
    } else if (user.keys!.contains("dream") &&
        !user.achievements.contains("dream")) {
      return "dream";
    } else if (user.keys!.contains("manager") &&
        !user.achievements.contains("manager")) {
      return "manager";
    } else if (user.keys!.contains("voltage") &&
        !user.achievements.contains("voltage")) {
      return "voltage";
    } else if (user.keys!.contains("monster") &&
        !user.achievements.contains("monster")) {
      return "monster";
    } else if (user.keys!.contains("master") &&
        !user.achievements.contains("master")) {
      return "master";
    }
  } else if (type == "box") {
    return "box";
  } else if (type == "double") {
    return "double";
  } else if (type == "world") {
    return "world";
  } else if (type == "nuh") {
    return "nuh";
  } else if (type == "LetHimCock") {
    return "LetHimCock";
  } else if (type == "WhoLet") {
    return "WhoLet";
  } else if (type == "penalty") {
    return "penalty";
  } else if (type == "hax") {
    return "hax";
  }
  return ""; // Return empty string if no achievement is met
}

Map<String, Achievements> achievementsArchive = {
  //? the 3 star achievements for stats
  "intelligence1": Achievements(
      title: "Basis of Mind",
      type: "state",
      id: "intelligence1",
      rarity: 3,
      description: "Reach 100 in Intelligence "),
  "agility1": Achievements(
      title: "beginning of Agility",
      type: "state",
      id: "agility1",
      rarity: 3,
      description: "Reach 100 in Agility "),
  "sense1": Achievements(
      title: "The Basis of Sense",
      type: "state",
      id: "sense1",
      rarity: 3,
      description: "Reach 100 in Sense "),
  "strength1": Achievements(
      title: "Foundation of Power",
      type: "state",
      id: "strength1",
      rarity: 3,
      description: "Reach 100 in Strength "),
  "vitality1": Achievements(
      title: "The Core of Life",
      type: "state",
      id: "vitality1",
      rarity: 3,
      description: "Reach 100 in Vitality "),
  "mana1": Achievements(
      title: "Born Of a Mage",
      type: "state",
      id: "mana1",
      rarity: 3,
      description: "Reach 100 in Mana "),
  "points1": Achievements(
      title: "Point Over Load I",
      type: "state",
      id: "points1",
      rarity: 3,
      description: "Reach 100 in Saved Points "),
  //? the 4 star achievements for stats
  "intelligence2": Achievements(
      title: "Master of Mind",
      type: "state",
      id: "intelligence2",
      rarity: 4,
      description: "Reach 500 in Intelligence "),
  "agility2": Achievements(
      title: "Bloom of Agility",
      type: "state",
      id: "agility2",
      rarity: 4,
      description: "Reach 500 in Agility "),
  "sense2": Achievements(
      title: "The rule of Perception",
      type: "state",
      id: "sense2",
      rarity: 4,
      description: "Reach 500 in Sense "),
  "strength2": Achievements(
      title: "Body Of Steal",
      type: "state",
      id: "strength2",
      rarity: 4,
      description: "Reach 500 in Strength "),
  "vitality2": Achievements(
      title: "Into immortality",
      type: "state",
      id: "vitality2",
      rarity: 4,
      description: "Reach 500 in Vitality "),
  "mana2": Achievements(
      title: "The Great Mage",
      type: "state",
      id: "mana2",
      rarity: 4,
      description: "Reach 500 in Mana "),
  "points2": Achievements(
      title: "Point Over Load II",
      type: "state",
      id: "points2",
      rarity: 4,
      description: "Reach 500 in Saved Points "),
  //? the 5 star achievements for stats
  "intelligence3": Achievements(
      title: "The anchor of Intelligence",
      type: "state",
      id: "intelligence3",
      rarity: 5,
      description: "Reach 1000 in Intelligence "),
  "agility3": Achievements(
      title: "The anchor of Agility",
      type: "state",
      id: "agility3",
      rarity: 5,
      description: "Reach 1000 in Agility "),
  "sense3": Achievements(
      title: "The anchor of Sense",
      type: "state",
      id: "sense3",
      rarity: 5,
      description: "Reach 1000 in Sense "),
  "strength3": Achievements(
      title: "The anchor of Strength",
      type: "state",
      id: "strength3",
      rarity: 5,
      description: "Reach 1000 in Strength "),
  "vitality3": Achievements(
      title: "The anchor of Vitality",
      type: "state",
      id: "vitality3",
      rarity: 5,
      description: "Reach 1000 in Vitality "),
  "mana3": Achievements(
      title: "The anchor of Mana",
      type: "state",
      id: "mana3",
      rarity: 5,
      description: "Reach 1000 in Mana "),
  "points3": Achievements(
      title: "Point Over Load III",
      type: "state",
      id: "points3",
      rarity: 5,
      description: "Reach 1000 in Saved Points "),
  //? Tasks 3 Star achievements
  "Finished100": Achievements(
      title: "Quest Conqueror I",
      type: "done",
      id: "Finished100",
      rarity: 3,
      description: "Complete 100 Task you create"),
  "onGoing100": Achievements(
      title: "nah I would Win I",
      type: "ongoing",
      id: "onGoing100",
      rarity: 3,
      description: "Have 100 new Task as OnGoing Tasks"),
  "Create100": Achievements(
      title: "Surpass Your Limit I",
      type: "all",
      id: "Create100",
      rarity: 3,
      description:
          "Have a Total of 200 Tasks in Finished and Ongoing together"),
  //? Tasks 4 Star achievements
  "Finished300": Achievements(
      title: "Quest Conqueror II",
      type: "done",
      id: "Finished300",
      rarity: 4,
      description: "Complete 300 Task you create"),
  "onGoing300": Achievements(
      title: "nah I would Win II",
      type: "ongoing",
      id: "onGoing300",
      rarity: 4,
      description: "Have 300 new Task as OnGoing Tasks"),
  "Create300": Achievements(
      title: "Surpass Your Limit II",
      type: "all",
      id: "Create300",
      rarity: 4,
      description:
          "Have a Total of 400 Tasks in Finished and Ongoing together"),
  //? Tasks 5 Star achievements
  "Finished500": Achievements(
      title: "Quest Conqueror III",
      type: "done",
      id: "Finished500",
      rarity: 5,
      description: "Complete 500 Task you create"),
  "onGoing500": Achievements(
      title: "nah I would Win III",
      type: "ongoing",
      id: "onGoing500",
      rarity: 5,
      description: "Have 500 new Task as OnGoing Tasks"),
  "Create500": Achievements(
      title: "Surpass Your Limit III",
      type: "all",
      id: "Create500",
      rarity: 5,
      description:
          "Have a Total of 600 Tasks in Finished and Ongoing together"),
  //? Tasks 6 Star achievements
  "Finished1000": Achievements(
      title: "Quest Conqueror IV",
      type: "done",
      id: "Finished1000",
      rarity: 6,
      description: "Complete 1000 Task you create"),
  "onGoing1000": Achievements(
      title: "nah I would Win IV",
      type: "ongoing",
      id: "onGoing1000",
      rarity: 6,
      description: "Have 1000 new Task as OnGoing Tasks"),
  "Create1000": Achievements(
      title: "Surpass Your Limit IV",
      type: "all",
      id: "Create1000",
      rarity: 6,
      description:
          "Have a Total of 1200 Tasks in Finished and Ongoing together"),
  //? main profile info achievements Level and Coins
  "Rich": Achievements(
      title: "Coin Tycoon",
      type: "coins",
      id: "Rich",
      rarity: 5,
      description: "Accumulated 100000 Runes"),
  "Broke": Achievements(
      title: "What happened to my savings?",
      type: "coins",
      id: "Broke",
      rarity: 4,
      description: "Use all your Runes in the shop"),
  //? 3 stars
  "Level1": Achievements(
      title: "The Beginning",
      type: "level",
      id: "Level1",
      rarity: 3,
      description: "Every Journey Have a start"),
  //? 4 stars
  "Level40": Achievements(
      title: "a True Beginning",
      type: "level",
      id: "Level40",
      rarity: 4,
      description: "Reached level 40"),
  "Level100": Achievements(
      title: "Level Novice",
      type: "level",
      id: "Level100",
      rarity: 4,
      description: "Reached level 100"),
  //? 5 stars
  "Level500": Achievements(
      title: "Level Maestro",
      type: "level",
      id: "Level500",
      rarity: 5,
      description: "Reached level 500"),
  //? 6 stars
  "Level1000": Achievements(
      title: "Born of The Legend",
      type: "level",
      id: "Level1000",
      rarity: 6,
      description: "Reached level 1000"),
  //? 7 start
  "Origin": Achievements(
      title: "Origin of The World",
      type: "state",
      id: "Origin",
      rarity: 7,
      description: "????????????"),
  //? the jobs achievements
  "Level5": Achievements(
      title: "You're 18 get a job",
      type: "level",
      id: "Level5",
      rarity: 4,
      description: "Get your first Class"),
  "Fighter": Achievements(
      title: "No magic? Okay!",
      type: "job",
      id: "Fighter",
      rarity: 4,
      description: "Get Classer Fighter"),
  "Healer": Achievements(
      title: "Redo of Healer, huh?",
      type: "job",
      id: "Healer",
      rarity: 4,
      description: "Get Classer Healer"),
  "Ranger": Achievements(
      title: "It's Time for AimBot",
      type: "job",
      id: "Ranger",
      rarity: 4,
      description: "Get Classer Ranger"),
  "Assassin": Achievements(
      title: "I Killed my father",
      type: "job",
      id: "Assassin",
      rarity: 4,
      description: "Get Classer Assassin"),
  "Mage": Achievements(
      title: "I found a cool stick",
      type: "job",
      id: "Mage",
      rarity: 4,
      description: "Get Classer Mage"),
  "Tanker": Achievements(
      title: "I'm not masochist but-",
      type: "job",
      id: "Tanker",
      rarity: 4,
      description: "Get Classer Tanker"),
  "Necromancer": Achievements(
      title: "Arise",
      type: "job",
      id: "Necromancer",
      rarity: 4,
      description: "Get Classer Necromancer"),
  //? the moods achievements
  "solo": Achievements(
      title: "The Preparation To Become Powerful",
      type: "mood",
      id: "solo",
      rarity: 3,
      description: "Activate Daily Quests for the first time",
      isHidden: true),
  "dream": Achievements(
      title: "I better hide that",
      type: "mood",
      id: "dream",
      rarity: 3,
      description: "Activate Dream space for the first time",
      isHidden: true),
  "manager": Achievements(
      title: "Here come the money",
      type: "mood",
      id: "manager",
      rarity: 3,
      description: "Activate the budget manager for the first time",
      isHidden: true),
  "voltage": Achievements(
      title: "I don't Know ...",
      type: "mood",
      id: "voltage",
      rarity: 3,
      description: "Activate Voltage for the first time",
      isHidden: true),
  "master": Achievements(
      title: "Hack mood on!!",
      type: "mood",
      id: "master",
      rarity: 3,
      description: "Activate the master control for the first time",
      isHidden: true),
  "monster": Achievements(
      title: "I think i missed up",
      type: "mood",
      id: "monster",
      rarity: 3,
      description: "Activate monster mood for the first time",
      isHidden: true),
  //? some radome shit
  "box": Achievements(
      title: "a Box?",
      type: "mood",
      id: "box",
      rarity: 4,
      description: "find the box",
      isHidden: true),
  "double": Achievements(
      title: "Deja-Vu!",
      type: "mood",
      id: "double",
      rarity: 4,
      description: "we already have that at home",
      isHidden: true),
  "world": Achievements(
      title: "Za WARDUO",
      type: "mood",
      id: "world",
      rarity: 4,
      description: "Create a Side Quest on the daily collection",
      isHidden: true),
  "nuh": Achievements(
      title: "Nuh Huh",
      type: "mood",
      id: "nuh",
      rarity: 4,
      description: "Im in't doing that one, no thank you",
      isHidden: true),
  "LetHimCock": Achievements(
      title: "Let Him Cook",
      type: "mood",
      id: "LetHimCock",
      rarity: 4,
      description: "Have over 20 task on the daily quest collection",
      isHidden: true),
  "WhoLet": Achievements(
      title: "Who let bro cook?",
      type: "mood",
      id: "WhoLet",
      rarity: 4,
      description:
          "Miss all the daily quest you added when you have at least 20 active quest",
      isHidden: true),
  "penalty": Achievements(
      title: "Penalty Zone!!",
      type: "mood",
      id: "penalty",
      rarity: 4,
      description: "Failed to complete the daily quest once",
      isHidden: true),
  "hax": Achievements(
      title: "Hax Mode: ON!",
      type: "mood",
      id: "hax",
      rarity: 4,
      description: "Use command in the box screen",
      isHidden: true),
  //? the budget manager
  //? the voltage
  //? buy the frame one
};
