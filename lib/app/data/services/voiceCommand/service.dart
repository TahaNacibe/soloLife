import 'package:SoloLife/app/core/utils/extensions.dart';
import 'package:SoloLife/app/core/values/icons.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/solo.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/models/task.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/expScal/exp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

//? get user profile data
Profile userInfo = ProfileProvider().readProfile();
List<dynamic> authority = userInfo.keys ?? [];

// hin message for help command
String helpHint = """'master control' --> to activate master level\n
'protocol solo' --> to activate daily quests\n
'protocol dream' --> to open the vault\n
'protocol manager' --> to open budget tracker\n
'protocol monster' --> to activate monster mode\n
'change name --'new Name'' --> To change userName\n
'self destruct' --> erase all data\n
'change theme' --> switch theme\n
'player mode' --> back to player mode\n
'protocol voltage' --> open voltage mode\n
'set password' --> create new password\n
'set password --'old Password' --'new password' --> to update password""";

//? the main commands control
String authorityLevel(String command, BuildContext context) {
  if (command.contains("change name")) {
    changeName(command, context);
    return "name changed complete";
  }
  if (command.contains("reverse")) {
    userInfo.keys!.contains("reverse")
        ? userInfo.keys!.remove("reverse")
        : userInfo.keys!.add("reverse");
    return "Okay You Have it now ";
  }
  // check if user is master
  if (authority.contains('master')) {
    // if master activate authority according to command and return string to show the user the action
    // solo protocol
    if (command.contains("protocol solo") && !authority.contains("solo")) {
      soloProtocol(context);
      return "Protocol Solo Activated";
      // dream pack
    } else if (command.contains('protocol dream') &&
        !authority.contains("dream")) {
      dreamProtocol(context);
      return "protocol dream Activated";
      // manager budget pack
    } else if (command.contains('protocol manager') &&
        !(authority.contains("manager"))) {
      managerProtocol(context);
      return "Protocol manager Activated";
      // monster protocol case
    } else if (command.contains('protocol monster') &&
        !authority.contains("monster")) {
      monsterProtocol(context);
      return "monster protocol activated";
      // voltage
    } else if (command.contains('protocol voltage') &&
        !authority.contains("voltage")) {
      voltageMode(context);
      return "voltage protocol activated";
    } else if (command.contains('s rank')) {
      if (!authority.contains("honkai1")) {
        userInfo.achievements.add("honkai1");
      } else {
        userInfo.achievements.remove("honkai1");
      }
      return "achivment protocol activated";
    } else if (command.contains('sentence')) {
      if (!authority.contains("sentence")) {
        userInfo.achievements.add("sentence");
      } else {
        userInfo.achievements.remove("sentence");
      }
      return "achivment protocol activated";
    } else if (command.contains('flamenation')) {
      if (!authority.contains("flamenation")) {
        userInfo.achievements.add("flamenation");
      } else {
        userInfo.achievements.remove("flamenation");
      }
      return "achivment protocol activated";
    } else if (command.contains('orv')) {
      if (!authority.contains("orv")) {
        userInfo.achievements.add("orv");
      } else {
        userInfo.achievements.remove("orv");
      }
      return "achivment protocol activated";
      // change the user name
    } else if (command.contains('player mode')) {
      playerMood(context);
      return "Player Mode Activated";
      // delete all data
    } else if (command.contains('self destruct')) {
      eraseAll();
      return 'erase all data';
      // set password
    } else if (command.contains('set password')) {
      return setPassword(command, context);
      // help command
    } else if (command.contains('help')) {
      return helpHint;
    } else if (command.contains('protocol op')) {
      op(context);
      return "All States has been Maxed out";
      //
    } else if (command.contains("change theme")) {
      ThemeProvider().toggleTheme();
      return "you may need to restart the app for change to take effect";
    } else if (command.contains('point --')) {
      int value = int.parse(command.replaceAll('point --', ''));
      UserState state = StatesProvider().readState();
      state.points += value;
      StatesProvider().writeState(state);
      return "$value points were added";
    } else {
      for (String level in authority) {
        if (command.contains(level)) {
          return "$level Already Active";
        }
      }
      return "Not recognized command";
    }
    // here if user try to activate master control
  } else if (command.contains("master control") &&
      !authority.contains("master")) {
    // do the command
    masterControl(context);
    return 'Master control activated ';
  } else if (command.contains("help")) {
    return helpHint;
  } else if (command.contains("change theme")) {
    ThemeProvider().toggleTheme();
    return "you may need to restart the app for change to take effect";
  } else {
    return "only master level can use commands !! ";
  }
}

//? activate master control
void masterControl(BuildContext context) {
  userInfo.keys!.add('master');
  // update the user data
  ProfileProvider().saveProfile(userInfo, "", context);
}

//? activate master control
void voltageMode(BuildContext context) {
  userInfo.keys!.add('voltage');
  // update the user data
  ProfileProvider().saveProfile(userInfo, "", context);
}

//? activate solo protocol
void soloProtocol(BuildContext context) {
  if (!userInfo.keys!.contains("solo")) {
    userInfo.keys!.add('solo');
  }
  // update the user data
  ProfileProvider().saveProfile(userInfo, "", context);
  // get the date for the tasks
  String time = DateTime.now().toIso8601String();
  // create the first dailies
  List<Daily> startUp = [
    Daily(
        title: "Push-Ups  [100]",
        exp: getExpForTheTasks(userInfo.level, false),
        standard: true,
        timeStamp: time,
        coins: getCoinsForTheTasks(false)),
    Daily(
        title: "Set-Ups  [100]",
        exp: getExpForTheTasks(userInfo.level, false),
        standard: true,
        timeStamp: time,
        coins: getCoinsForTheTasks(false)),
    Daily(
        title: "Pull-Ups  [100]",
        exp: getExpForTheTasks(userInfo.level, false),
        standard: true,
        timeStamp: time,
        coins: getCoinsForTheTasks(false)),
    Daily(
        title: "Squats  [100]",
        exp: getExpForTheTasks(userInfo.level, false),
        standard: true,
        timeStamp: time,
        coins: getCoinsForTheTasks(false)),
    Daily(
        title: "Running  [10Km]",
        exp: getExpForTheTasks(userInfo.level, false),
        standard: true,
        timeStamp: time,
        coins: getCoinsForTheTasks(false)),
  ];
  // save the changes
  DailyTasks().writeTasks(startUp);
}

//? activate dream protocol
void dreamProtocol(BuildContext context) {
  // create the dream task pack
  List<Task> tasks = TaskProvider().readTasks();
  var task = Task(
    title: "Dream Space",
    icon: personIcon,
    color: Colors.red.toHex(),
  );
  tasks.add(task);
  TaskProvider().writeTasks(tasks);
  userInfo.keys!.add('dream');
  // update the user data
  ProfileProvider().saveProfile(userInfo, "", context);
}

//? activate manager protocol
void managerProtocol(BuildContext context) {
  userInfo.keys!.add('manager');
  // update the user data
  ProfileProvider().saveProfile(userInfo, "", context);
}

//? activate monster protocol
void monsterProtocol(BuildContext context) {
  userInfo.keys!.add('monster');
  // update the user data
  ProfileProvider().saveProfile(userInfo, "", context);
}

//? change user name
void changeName(String command, BuildContext context) {
  List<String> value = command.split(' ');
  value.removeRange(0, 2);
  String result = value.join(" ");
  userInfo.userName = result;
  ProfileProvider().saveProfile(userInfo, "", context);
}

//? delete data
void eraseAll() {
  final _storage = GetStorage();
  _storage.erase();
  SystemNavigator.pop();
}

//? setPassword
String setPassword(String command, BuildContext context) {
  List<String> value = command.split('--');
  value.removeRange(0, 1);
  // no old password case
  if (userInfo.password.isEmpty) {
    userInfo.password = value[0];
    ProfileProvider().saveProfile(userInfo, "", context);
    return "password set complete";
  } else if (value.length == 2 && userInfo.password == value[0].trim()) {
    value.removeAt(0);
    String result = value.join("");
    userInfo.password = result;
    ProfileProvider().saveProfile(userInfo, "", context);
    return "password update complete";
  } else {
    return "incorrect password\n to update password enter: set password --'old password' --'new password'";
  }
}

//? protocol op as fuck
void op(BuildContext context) {
  Profile user = ProfileProvider().readProfile();
  user.level = 9999;
  user.exp = getExpToNextLevel(9999);
  ProfileProvider().saveProfile(user, "exp", context);
  StatesProvider().writeState(UserState(
      agility: 1000,
      intelligence: 1000,
      mana: 10000,
      sense: 1000,
      strength: 10000,
      vitality: 1000,
      points: 100000000000));
}

//? remove master state
void playerMood(BuildContext context) {
  userInfo.keys!.remove('master');
  // update the user data
  ProfileProvider().saveProfile(userInfo, "", context);
}
