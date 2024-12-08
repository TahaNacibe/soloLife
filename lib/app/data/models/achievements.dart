import 'package:SoloLife/app/core/utils/icon_pack_icons.dart';
import 'package:SoloLife/app/data/models/budget.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/modules/home/controller.dart';
import 'package:SoloLife/app/modules/report/viewAchievements.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// the achievements class
class brief {
  String title; // title for it
  String type; // type to filter
  String id; // id to get the achievement later
  int rarity; // for reword and color
  String description; // a brief description under it
  bool isHidden; // is the achievement showing or need to be unlocked first 

  // the data
  brief({
    required this.title,
    required this.type,
    required this.id,
    required this.rarity,
    this.description = "no Description for that item",
    this.isHidden = false,
  });
}

// the function ha,del all the achievements and the pop up dialog for them
void achievementsHandler(String type, BuildContext context) {
  // read user data
  Profile user = ProfileProvider().readProfile();

  // get user achievements list
  List<dynamic> achievements = user.achievements;

  // getting rid of all the unwanted parts of the achievements type we passed
  String result = achievementWatcher(type).trim();
  // if the watcher return nothing just ignore it, if it return something
  if (result.isNotEmpty) {
    // check if the achievement is already open
    if (!achievements.contains(result)) {
      //if no added the achievement to the list
      user.achievements.add(result);
      brief current = achievementsArchive[result]!;
      // getting the achievement reword based on it's rarity
      int expCount = current.rarity == 7
          ? 150000
          : current.rarity == 6
              ? 1000
              : current.rarity == 5
                  ? 750
                  : current.rarity == 4
                      ? 500
                      : 250;
      user.coins += expCount;
      // showing the achievement message
      achievementsDialog(context, current.title, current.rarity, expCount);
      // save changes
      ProfileProvider().saveProfile(user, "exp", context);
    }
    //
  }
}

// the achievement dialog pop up
void achievementsDialog(
    BuildContext context, String achievementName, int rarity, int coin) {
  // change it's color depending on it's rarity
  Color color = rarity == 7
      ? Colors.purple
      : rarity == 6
          ? Colors.red
          : rarity == 5
              ? Colors.orange
              : rarity == 4
                  ? Colors.blue
                  : Colors.brown;

  // settings the rewords depending on the rarity
  String prize = rarity == 7
      ? "15K"
      : rarity == 6
          ? "5k"
          : rarity == 5
              ? "1k"
              : rarity == 4
                  ? "500"
                  : "250";

  // the pop up UI
  AnimatedSnackBar(
    builder: ((context) {
      return GestureDetector(
        onTap: () {
          // click to go see the achievement it scroll to almost it's place
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
          //
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
                            text: achievementName, // the achievement name
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
                      "+$prize", // the reword of the achievement
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

// the function is responsible on getting the right achievement data
String achievementWatcher(String type) {
  // getting the tasks state in the app
  final homeCtrl = Get.find<HomeController>();
  var completedTasks = homeCtrl.getTotalDoneTask(); // total completed tasks
  int allTasks = homeCtrl.getTotalTask(); // total tasks
  var ongoingTasks =
      allTasks - completedTasks; // getting the onGoing tasks number

  // getting the budget manager information
  List<deposit> budget = Amount().readBudget(); // read data
  int value = Amount().totalGater(budget); // get total amount

  // read user profile info
  Profile user = ProfileProvider().readProfile();

  // read user states information
  UserState state = StatesProvider().readState();
  var properties =
      state.toJson().entries; // turn them to list maps for iteration

  // in case the type is state (using the state data)
  if (type == "state") {
    String result = ""; // initialing a empty result

    // loop through the maps we got and check
    for (var element in properties) {
      int value = int.tryParse(element.value.toString()) ?? 0;
      // first case
      if (value >= 1000) {
        if (!user.achievements.contains("${element.key}3")) {
          result =
              "${element.key}3\n"; // changing the result to the achievements key of that case
        } else {
          continue; // other wise just skip
        }
        // second case
      } else if (value >= 500) {
        if (!user.achievements.contains("${element.key}2")) {
          result = "${element.key}2\n";
        } else {
          continue;
        }
        // last case
      } else if (value >= 100) {
        if (!user.achievements.contains("${element.key}1")) {
          result = "${element.key}1\n";
        } else {
          continue;
        }
      }
    }
    return result.trim(); // Return the accumulated result after the loop

    // the type done
  } else if (type == "done") {
    // check the tasks -completed how much?
    if (completedTasks >= 1000) {
      return "Finished1000"; // return the achievement key
    } else if (completedTasks >= 500) {
      return "Finished500";
    } else if (completedTasks >= 300) {
      return "Finished300";
    } else if (completedTasks >= 100) {
      return "Finished100";
    }
    // checking the ongoing tasks 
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
    // checking the total tasks
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
    // achievements about the credit 
  } else if (type == "coins") {
    // case 1
    if (user.coins >= 100000) {
      return "Rich";
      // case 2
    } else if (user.coins == 0 && user.level != 1) {
      return "Broke";
    }

    // level related achievements
  } else if (type == "level") {
    // return a key based on the player current level
    if ((user.level + 1) == 10000) {
      return "Level10000";
    } else if ((user.level) == 500) {
      return "Level500";
    } else if ((user.level) == 100) {
      return "Level100";
    } else if ((user.level) == 40) {
      return "Level40";
    } else if ((user.level) == 5) {
      return "Level5";
    } else if ((user.level) == 1) {
      return "Level1";
    }
    // achievements related to the jobs 
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
    // achievements related to the tools the user can unlock
  } else if (type == "mood") {
    // here check if the user is activating the tool for the first time 
    // before giving the achievement
    if (user.keys!.contains("solo") && 
    !user.achievements.contains("solo")) {
      return "solo";
      // as usual return a key
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
    // achievements related to the budget manager section
  } else if (type == "budget") {
    //check if the user have the achievement here first or it will always ignore the rest
    if (value < 0 && !user.achievements.contains("debt")) {
      return "debt";
      // return a key
    } else if (value >= 1000 && !user.achievements.contains("extra")) {
      return "extra";
      // the other half have a condition checked by a separate function
    } else if (value == 0 && budget.isNotEmpty) {
      return "zero";
    } else if (checkTheCase(budget) == 1) {
      return "saving";
    } else if (checkTheCase(budget) == 2) {
      return "spending";
    }
    // the achievements related to the voltage tool (more in the upComing part)
  } else if (type == "voltage") {
    if (user.voltage == 5) {
      return "good";
    } else if (user.voltage == -5) {
      return "bad";
    }

    // additions needed special cases to accrues
    // here the condition is being checked before calling the function 
  } else if (type == "99good") {
    return "lastGood";
  } else if (type == "99bad") {
    return "lastBad";
  } else if (type == "balance") {
    return "balance";
  } else if (type == "extra") {
    return "weDon";
  } else if (type == "extra2") {
    return "soMuch";
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
  } else if (type == "orv1") {
    return "orv";
  } else if (type == "orv2") {
    return "dokkaebi";
  } else if (type == "fate") {
    return "unlimited";
  } else if (type == "honkai1") {
    return "honkai1";
  } else if (type == "sentence") {
    return "sentence";
  } else if (type == "flamenation") {
    return "flamenation";
  } else if (type == "youCanDoThat") {
    return "youCanDoThat";
  }
  return ""; // Return empty string if no achievement is met
}

// the budget needed a special checking, the function return a number for each case
int checkTheCase(List<deposit> budget) {
  int number = 0;
  // the first case 1 : the last actions were all green
  if (budget.length >= 3) {
    if (budget[budget.length - 1].add == true &&
        budget[budget.length - 2].add == true &&
        budget[budget.length - 3].add == true) {
      number = 1;
      // the second case the last actions were all rede
    } else if (budget[budget.length - 1].add == false &&
        budget[budget.length - 2].add == false &&
        budget[budget.length - 3].add == false) {
      number = 2;
    }
  } else {
    // else default
    number = 3;
  }
  return number;
}


//the achievements list is here and managed here
Map<String, brief> achievementsArchive = {
  //? the 3 star achievements for stats
  "intelligence1": brief(
      title: "Basis of Mind",
      type: "state",
      id: "intelligence1",
      rarity: 3,
      description: "Reach 100 in Intelligence "),
  "agility1": brief(
      title: "beginning of Agility",
      type: "state",
      id: "agility1",
      rarity: 3,
      description: "Reach 100 in Agility "),
  "sense1": brief(
      title: "The Basis of Sense",
      type: "state",
      id: "sense1",
      rarity: 3,
      description: "Reach 100 in Sense "),
  "strength1": brief(
      title: "Foundation of Power",
      type: "state",
      id: "strength1",
      rarity: 3,
      description: "Reach 100 in Strength "),
  "vitality1": brief(
      title: "The Core of Life",
      type: "state",
      id: "vitality1",
      rarity: 3,
      description: "Reach 100 in Vitality "),
  "mana1": brief(
      title: "Born Of a Mage",
      type: "state",
      id: "mana1",
      rarity: 3,
      description: "Reach 100 in Mana "),
  "points1": brief(
      title: "Point Over Load I",
      type: "state",
      id: "points1",
      rarity: 3,
      description: "Reach 100 in Saved Points "),
  //? the 4 star achievements for stats
  "intelligence2": brief(
      title: "Master of Mind",
      type: "state",
      id: "intelligence2",
      rarity: 4,
      description: "Reach 500 in Intelligence "),
  "agility2": brief(
      title: "Bloom of Agility",
      type: "state",
      id: "agility2",
      rarity: 4,
      description: "Reach 500 in Agility "),
  "sense2": brief(
      title: "The rule of Perception",
      type: "state",
      id: "sense2",
      rarity: 4,
      description: "Reach 500 in Sense "),
  "strength2": brief(
      title: "Body Of Steal",
      type: "state",
      id: "strength2",
      rarity: 4,
      description: "Reach 500 in Strength "),
  "vitality2": brief(
      title: "Into immortality",
      type: "state",
      id: "vitality2",
      rarity: 4,
      description: "Reach 500 in Vitality "),
  "mana2": brief(
      title: "The Great Mage",
      type: "state",
      id: "mana2",
      rarity: 4,
      description: "Reach 500 in Mana "),
  "points2": brief(
      title: "Point Over Load II",
      type: "state",
      id: "points2",
      rarity: 4,
      description: "Reach 500 in Saved Points "),
  //? the 5 star achievements for stats
  "intelligence3": brief(
      title: "The anchor of Intelligence",
      type: "state",
      id: "intelligence3",
      rarity: 5,
      description: "Reach 1000 in Intelligence "),
  "agility3": brief(
      title: "The anchor of Agility",
      type: "state",
      id: "agility3",
      rarity: 5,
      description: "Reach 1000 in Agility "),
  "sense3": brief(
      title: "The anchor of Sense",
      type: "state",
      id: "sense3",
      rarity: 5,
      description: "Reach 1000 in Sense "),
  "strength3": brief(
      title: "The anchor of Strength",
      type: "state",
      id: "strength3",
      rarity: 5,
      description: "Reach 1000 in Strength "),
  "vitality3": brief(
      title: "The anchor of Vitality",
      type: "state",
      id: "vitality3",
      rarity: 5,
      description: "Reach 1000 in Vitality "),
  "mana3": brief(
      title: "The anchor of Mana",
      type: "state",
      id: "mana3",
      rarity: 5,
      description: "Reach 1000 in Mana "),
  "points3": brief(
      title: "Point Over Load III",
      type: "state",
      id: "points3",
      rarity: 5,
      description: "Reach 1000 in Saved Points "),
  //? Tasks 3 Star achievements
  "Finished100": brief(
      title: "Quest Conqueror I",
      type: "done",
      id: "Finished100",
      rarity: 3,
      description: "Complete 100 Task you create"),
  "onGoing100": brief(
      title: "nah I would Win I",
      type: "ongoing",
      id: "onGoing100",
      rarity: 3,
      description: "Have 100 new Task as OnGoing Tasks"),
  "Create100": brief(
      title: "Surpass Your Limit I",
      type: "all",
      id: "Create100",
      rarity: 3,
      description:
          "Have a Total of 200 Tasks in Finished and Ongoing together"),
  //? Tasks 4 Star achievements
  "Finished300": brief(
      title: "Quest Conqueror II",
      type: "done",
      id: "Finished300",
      rarity: 4,
      description: "Complete 300 Task you create"),
  "onGoing300": brief(
      title: "nah I would Win II",
      type: "ongoing",
      id: "onGoing300",
      rarity: 4,
      description: "Have 300 new Task as OnGoing Tasks"),
  "Create300": brief(
      title: "Surpass Your Limit II",
      type: "all",
      id: "Create300",
      rarity: 4,
      description:
          "Have a Total of 400 Tasks in Finished and Ongoing together"),
  //? Tasks 5 Star achievements
  "Finished500": brief(
      title: "Quest Conqueror III",
      type: "done",
      id: "Finished500",
      rarity: 5,
      description: "Complete 500 Task you create"),
  "onGoing500": brief(
      title: "nah I would Win III",
      type: "ongoing",
      id: "onGoing500",
      rarity: 5,
      description: "Have 500 new Task as OnGoing Tasks"),
  "Create500": brief(
      title: "Surpass Your Limit III",
      type: "all",
      id: "Create500",
      rarity: 5,
      description:
          "Have a Total of 600 Tasks in Finished and Ongoing together"),
  //? Tasks 6 Star achievements
  "Finished1000": brief(
      title: "Quest Conqueror IV",
      type: "done",
      id: "Finished1000",
      rarity: 6,
      description: "Complete 1000 Task you create"),
  "onGoing1000": brief(
      title: "nah I would Win IV",
      type: "ongoing",
      id: "onGoing1000",
      rarity: 6,
      description: "Have 1000 new Task as OnGoing Tasks"),
  "Create1000": brief(
      title: "Surpass Your Limit IV",
      type: "all",
      id: "Create1000",
      rarity: 6,
      description:
          "Have a Total of 1200 Tasks in Finished and Ongoing together"),
  //? main profile info achievements Level and Coins
  "Rich": brief(
      title: "Coin Tycoon",
      type: "coins",
      id: "Rich",
      rarity: 5,
      description: "Accumulated 100000 Runes"),
  "Broke": brief(
      title: "What happened to my savings?",
      type: "coins",
      id: "Broke",
      rarity: 4,
      description: "Use all your Runes in the shop"),
  //? 3 stars
  "Level1": brief(
      title: "The Beginning",
      type: "level",
      id: "Level1",
      rarity: 3,
      description: "Every Journey Have a start"),
  //? 4 stars
  "Level40": brief(
      title: "a True Beginning",
      type: "level",
      id: "Level40",
      rarity: 4,
      description: "Reached level 40"),
  "Level100": brief(
      title: "Level Novice",
      type: "level",
      id: "Level100",
      rarity: 4,
      description: "Reached level 100"),
  //? 5 stars
  "Level500": brief(
      title: "Level Maestro",
      type: "level",
      id: "Level500",
      rarity: 5,
      description: "Reached level 500"),
  //? 6 stars
  "Level1000": brief(
      title: "Born of The Legend",
      type: "level",
      id: "Level1000",
      rarity: 6,
      description: "Reached level 1000"),
  //? 7 start
  "Origin": brief(
      title: "Origin of The World",
      type: "state",
      id: "Origin",
      rarity: 7,
      description: "????????????"),
  //? the jobs achievements
  "Level5": brief(
      title: "You're 18 get a job",
      type: "level",
      id: "Level5",
      rarity: 4,
      description: "Get your first Class"),
  "Fighter": brief(
      title: "No magic? Okay!",
      type: "job",
      id: "Fighter",
      rarity: 4,
      description: "Get Classer Fighter"),
  "Healer": brief(
      title: "Redo of Healer, huh?",
      type: "job",
      id: "Healer",
      rarity: 4,
      description: "Get Classer Healer"),
  "Ranger": brief(
      title: "It's Time for AimBot",
      type: "job",
      id: "Ranger",
      rarity: 4,
      description: "Get Classer Ranger"),
  "Assassin": brief(
      title: "I Killed my father",
      type: "job",
      id: "Assassin",
      rarity: 4,
      description: "Get Classer Assassin"),
  "Mage": brief(
      title: "I found a cool stick",
      type: "job",
      id: "Mage",
      rarity: 4,
      description: "Get Classer Mage"),
  "Tanker": brief(
      title: "I'm not masochist but-",
      type: "job",
      id: "Tanker",
      rarity: 4,
      description: "Get Classer Tanker"),
  "Necromancer": brief(
      title: "Arise",
      type: "job",
      id: "Necromancer",
      rarity: 4,
      description: "Get Classer Necromancer"),
  //? the moods achievements
  "solo": brief(
      title: "The Preparation To Become Powerful",
      type: "mood",
      id: "solo",
      rarity: 3,
      description: "Activate Daily Quests for the first time",
      isHidden: true),
  "dream": brief(
      title: "I better hide that",
      type: "mood",
      id: "dream",
      rarity: 3,
      description: "Activate Dream space for the first time",
      isHidden: true),
  "manager": brief(
      title: "Here come the money",
      type: "mood",
      id: "manager",
      rarity: 3,
      description: "Activate the budget manager for the first time",
      isHidden: true),
  "voltage": brief(
      title: "I don't Know ...",
      type: "mood",
      id: "voltage",
      rarity: 3,
      description: "Activate Voltage for the first time",
      isHidden: true),
  "master": brief(
      title: "It dose Nothing??",
      type: "mood",
      id: "master",
      rarity: 3,
      description: "Activate the master control for the first time",
      isHidden: true),
  "monster": brief(
      title: "I think i missed up",
      type: "mood",
      id: "monster",
      rarity: 3,
      description: "Activate monster mood for the first time",
      isHidden: true),
  //? some radome shit
  "box": brief(
      title: "a Box?",
      type: "mood",
      id: "box",
      rarity: 4,
      description: "find the box",
      isHidden: true),
  "double": brief(
      title: "Deja-Vu!",
      type: "mood",
      id: "double",
      rarity: 4,
      description: "we already have that at home",
      isHidden: true),
  "world": brief(
      title: "Za WARDUO",
      type: "mood",
      id: "world",
      rarity: 4,
      description: "Create a Side Quest on the daily collection",
      isHidden: true),
  "nuh": brief(
      title: "Nuh Huh",
      type: "mood",
      id: "nuh",
      rarity: 4,
      description: "Im in't doing that one, no thank you",
      isHidden: true),
  "LetHimCock": brief(
      title: "Let Him Cook",
      type: "mood",
      id: "LetHimCock",
      rarity: 4,
      description: "Have over 20 task on the daily quest collection",
      isHidden: true), 
  "WhoLet": brief(
      title: "Who let bro cook?",
      type: "mood",
      id: "WhoLet",
      rarity: 4,
      description:
          "Miss all the daily quest you added when you have at least 20 active quest",
      isHidden: true),
  "penalty": brief(
      title: "Penalty Zone!!",
      type: "mood",
      id: "penalty",
      rarity: 4,
      description: "Failed to complete the daily quest once",
      isHidden: true),
  "hax": brief(
      title: "Hax Mode: ON!",
      type: "mood",
      id: "hax",
      rarity: 4,
      description: "Use command in the box screen",
      isHidden: true),
  //? the budget manager
  "debt": brief(
      title: "Oh Boy!",
      type: "budget",
      id: "debt",
      rarity: 4,
      description: "go into debt, please don't",
      isHidden: true),
  "extra": brief(
      title: "I'm reach now",
      type: "budget",
      id: "extra",
      rarity: 4,
      description: "have over a 10000",
      isHidden: false),
  "zero": brief(
      title: "Thats bad",
      type: "budget",
      id: "zero",
      rarity: 4,
      description: "just be brock",
      isHidden: false),
  "saving": brief(
      title: "more Money",
      type: "budget",
      id: "saving",
      rarity: 4,
      description: "deposit 3 times in a row",
      isHidden: false),
  "spending": brief(
      title: "calm down",
      type: "budget",
      id: "spending",
      rarity: 4,
      description: "withdraw 3 times in a row",
      isHidden: false),
  "weDon": brief(
      title: "We don't do that here",
      type: "extra",
      id: "weDon",
      rarity: 4,
      description: "deposit a number with '.'",
      isHidden: true),
  "soMuch": brief(
      title: "wow, so much zeros",
      type: "extra2",
      id: "soMuch",
      rarity: 4,
      description: "do a transaction with 5 zeros",
      isHidden: true),
  //? the voltage
  "good": brief(
      title: "Uncle Approve",
      type: "voltage",
      id: "good",
      rarity: 4,
      description: "reach level 5 in voltage",
      isHidden: false),
  "bad": brief(
      title: "you'r a failure",
      type: "voltage",
      id: "bad",
      rarity: 4,
      description: "reach level -5 in voltage",
      isHidden: false),
  "lastGood": brief(
      title: "That was close",
      type: "99good",
      id: "lastGood",
      rarity: 4,
      description: "level up with 99 negative volt",
      isHidden: true),
  "lastBad": brief(
      title: "too bad",
      type: "99bad",
      id: "lastBad",
      rarity: 4,
      description: "level up with 99 positive volt",
      isHidden: true),
  "balance": brief(
      title: "as everything should be",
      type: "balance",
      id: "balance",
      rarity: 4,
      description: "have 50 negative and 50 positive volt",
      isHidden: false),
  //? anime and novel and others reference
  // the ovp
  "orv": brief(
      title: "The 49%...",
      type: "orv1",
      id: "orv",
      rarity: 4,
      description: "Kim D■kj■ ...",
      isHidden: true),
  "dokkaebi": brief(
      title: "dokkaebi shop",
      type: "orv2",
      id: "dokkaebi",
      rarity: 4,
      description: "watch ad to get a coin bag",
      isHidden: true),
  // fate
  "unlimited": brief(
      title: "Unlimited Collection work",
      type: "fate",
      id: "unlimited",
      rarity: 4,
      description: "create over 50 collection",
      isHidden: true),
  // honkai impact 3rd
  "honkai1": brief(
      title: "S-rank Valkyrie",
      type: "honkai1",
      id: "honkai1",
      rarity: 4,
      description: "for all the beauty in the world",
      isHidden: true),
  "sentence": brief(
      title: "Herrscher of sentence",
      type: "sentence",
      id: "sentence",
      rarity: 4,
      description: "level up with no negative volts",
      isHidden: false),
  "flamenation": brief(
      title: "Herrscher of flamenation",
      type: "reference",
      id: "flamenation",
      rarity: 4,
      description: "Reach 100 day strike",
      isHidden: false),
  "youCanDoThat": brief(
      title: "You Can Do That?",
      type: "reference",
      id: "youCanDoThat",
      rarity: 3,
      description:
          "find the shortcut i set because i was too lazy to change it from the settings",
      isHidden: true),
};
