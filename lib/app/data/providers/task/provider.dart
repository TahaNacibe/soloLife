import 'dart:convert';
import 'package:SoloLife/annoncment/levelUp.dart';
import 'package:SoloLife/app/data/models/achievements.dart';
import 'package:SoloLife/app/data/models/budget.dart';
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/shop_data.dart';
import 'package:SoloLife/app/data/models/solo.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/models/volt.dart';
import 'package:SoloLife/app/data/services/expScal/exp.dart';
import 'package:SoloLife/app/data/services/voiceCommand/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:SoloLife/app/core/utils/Keys.dart';
import 'package:SoloLife/app/data/models/task.dart';
import 'package:SoloLife/app/data/services/storage/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

// class for the normal collections and tasks
class TaskProvider {
  final _storage = Get.find<StorageService>();

  List<Task> readTasks() {
    var tasks = <Task>[]; // empty list for the data

    jsonDecode(_storage.read(taskKey).toString()) // read the storage
        .forEach((e) => tasks.add(Task.fromJson(e)));
        // transform from jason to task and added to the list 
    return tasks; 
  }

  // save new task and update the list
  void writeTasks(List<Task> tasks) {
    // to json to be saved
    _storage.write(taskKey, jsonEncode(tasks));
  }
}

// profile and user data storage services
class ProfileProvider {
  final _storage = Get.find<StorageService>(); // get the storage

  //? write the user info
  void saveProfile(Profile profile, String mood, BuildContext context) {
    //? leveling up mechanics check if user level up
    if (mood == "exp") {
      int capExp = getExpToNextLevel(profile.level);
      int currentExp = profile.exp; // get user current exp
      UserState state = StatesProvider().readState();
      int point = state.points;
      // if level up with equal amount reset the exp
      if (capExp == profile.exp) {
        // update some data
        profile.exp = 0;
        profile.level = profile.level + 1;
        state.points = point + 10;
        profile.coins += 100;

        // save changes
        StatesProvider().writeState(state);
        // level up dialog
        levelUpDialog(context);
        // if he get more than the cap add the extra to the next required
      } else if (capExp < currentExp) {
        int remain = currentExp - capExp; // the extra exp
        profile.exp = remain;
        profile.level = profile.level + 1;
        profile.coins += 100;
        state.points = point + 10;

        // save changes
        StatesProvider().writeState(state);
        // level up dialog
        levelUpDialog(context);
      }
    }
    //? save the user data
    _storage.write(profileKey, profile.toJson());
  }

  //? read the user info
  Profile readProfile() {
    final data = _storage.read(profileKey); // get the storage

    // create a default class to write in case of blanc 
    Profile defaultUser =
        Profile(userName: "■ ■ ■ ■", level: 1, exp: 0, keys: []);
        // if null write
    if (data == null) {
      _storage.write(profileKey, defaultUser.toJson());
    }
    // else read the data
    return Profile.fromJson(data);
  }

  //? check the user state if exit or not (return true if it empty)
  bool checkUserData() {
    bool state = _storage.read(profileKey) == {};
    return state;
  }

  //? check the user state, (as the one before it)
  bool checkUserState() {
    bool state = _storage.read(statesKey) == [];
    return state;
  }
}

// dailies function part
class DailyTasks {
  var dailyTasks = <Daily>[]; // empty var
  final _storage = Get.find<StorageService>(); // get the storage

// return a list of the dailies the user have
  List<Daily> readTasks() {
    jsonDecode(_storage.read(dailyKey).toString())
        .forEach((e) => dailyTasks.add(Daily.fromJson(e)));

        // switch from json than return 
    return dailyTasks;
  }

// save the tasks and write it on the storage
  void writeTasks(List<Daily> tasks) {
    _storage.write(dailyKey, jsonEncode(tasks));
  }
}

  //? daily tasks manager handling the reset at 00:00
class missing {
  // Observable list to hold tasks
  List<Daily> tasks = DailyTasks().readTasks();

// reseating the tasks, changing the exp and coins for each one
  void resetUnfinishedTasks(BuildContext context) {
    // go through each one and check the time
    for (var task in tasks) {
      DateTime now = DateTime.now();
      DateTime timesStamp = DateTime.parse(task.timeStamp);
      // Compare the date components
      if (now.year > timesStamp.year) {
        achievementForMissing(context);// the strike and dailies achievements

        // a year passed
        timesStamp = DateTime.now(); // get the new date
        task.timeStamp = timesStamp.toIso8601String(); // saving the new date
        task.exp = getExpForTheTasks(userInfo.level, task.isFree); // get exp for the task
        task.coins = getCoinsForTheTasks(task.isFree); // get coins for the task
        task.isGoing = true; // update too ongoing

      } else if (now.year == timesStamp.year && now.month > timesStamp.month) {
        achievementForMissing(context);

        // a month passed
        timesStamp = DateTime.now();
        task.exp = getExpForTheTasks(userInfo.level, task.isFree);
        task.timeStamp = timesStamp.toIso8601String();
        task.coins = getCoinsForTheTasks(task.isFree);
        task.isGoing = true;
      } else if (now.year == timesStamp.year &&
          now.month == timesStamp.month &&
          now.day > timesStamp.day) {
        achievementForMissing(context);

        // day passed
        timesStamp = DateTime.now();
        task.exp = getExpForTheTasks(userInfo.level, task.isFree);
        task.timeStamp = timesStamp.toIso8601String();
        task.coins = getCoinsForTheTasks(task.isFree);
        task.isGoing = true;
      }
    }
    // Update the UI with changes
    DailyTasks().writeTasks(tasks); // Save updated tasks to storage
  }


  // handling the strike and it's data
  void strikeManager(BuildContext context) {
    // check if the user have solo active
    if (userInfo.keys!.contains("solo")) {
      // update the date
      DateTime now = DateTime.now();
      Profile user = ProfileProvider().readProfile(); // read the profile
      List<Daily> tasksList = DailyTasks().readTasks(); // the tasks list 
      bool isSafe = false;
      DateTime timeStamp = DateTime.parse(tasksList[0].timeStamp);
      // check if at least on is done to save the strike
      for (Daily task in tasksList) {
        if (!task.isGoing) {
          isSafe = true;
          break;
        }
      }
      if (now.year == timeStamp.year &&
          now.month == timeStamp.month &&
          now.day > timeStamp.day) {
        if (isSafe) {
          user.strike += 1;
        } else {
          user.strike = 0;
        }
      }

      // save the date
      ProfileProvider().saveProfile(user, "", context);
    }
  }

  // handling the achievements for the missing case
    void achievementForMissing(BuildContext context) {
    for (Daily task in tasks) {
      if (task.isGoing == true) {
        achievementsHandler("penalty", context);
      }
      if (task.isGoing == true && tasks.length >= 20) {
        achievementsHandler("WhoLet", context);
      }
    }
  }

  // set the tasks to reset at 00:00
  void scheduleTaskReset(BuildContext context) {
    if (userInfo.keys!.contains('solo')) {
      resetUnfinishedTasks(context);
    }
  }
}

// budget functions 
class Amount {
  final _storage = Get.find<StorageService>(); // start the storage

// return the list of budget entries 
  List<deposit> readBudget() {
    var budget = <deposit>[];
    if (jsonDecode(_storage.read(managerKey).toString()) != null) {
      // decode the json strings
      jsonDecode(_storage.read(managerKey).toString())
          .forEach((e) => budget.add(deposit.fromJson(e)));
    }
    // return the list 
    return budget;
  }

// save and update the data
  void writeBudget(List<deposit> budget) {
    _storage.write(managerKey, jsonEncode(budget));
  }

  // get the total amount in the budget 
  int totalGater(List budget) {
    int total = 0;
    int min = 0;
    // loop through the elements and added their values
    for (deposit element in budget) {
      element.add ? total = total + element.amount : min = min + element.amount;
    }
    total = total - min;
    // return it
    return total;
  }
}

//the states classes management 
class StatesProvider {
  final _storage = Get.find<StorageService>(); // start the storage services

// read the states from the storage
  UserState readState() {
    UserState result = UserState();
    if (jsonDecode(_storage.read(statesKey).toString()) != null) {
      // decoding the json file to an object
      Map<String, dynamic> raw =
          jsonDecode(_storage.read(statesKey).toString());
      result = UserState.fromJson(raw);
    } else {
      // else there is no state so write it
      writeState(result);
    }
    // return the value
    return result;
  }

// save and update the states
  void writeState(UserState state) {
    _storage.write(statesKey, jsonEncode(state));
  }

// check the existing of the states
  bool checkStates() {
    return _storage.read(statesKey) == [];
  }
}

// formate the date for the budget manager items
String formatDateTime(DateTime now, bool full) {
  final day =
      now.day.toString().padLeft(2, '0'); // Pad with leading zero if necessary
  final month =
      DateFormat('MMM').format(now); // Use DateFormat for month abbreviation
  final year = now.year.toString();
  final hour = now.hour.toString().padLeft(2, '0');
  final minute = now.minute.toString().padLeft(2, '0');
  if (full) {
    return '$day.$month.$year $hour:$minute';
  } else {
    return '$day.$month.$year';
  }
}

// manage theme
class ThemeProvider {
  final _isDarkMode = false.obs;

  bool get isDarkMode => _isDarkMode.value;

  bool loadTheme() {
    _isDarkMode.value = GetStorage().read('isDarkMode') ?? false;
    return _isDarkMode.value;
  }

  void toggleTheme() {
    _isDarkMode.value = GetStorage().read('isDarkMode') ?? false;
    _isDarkMode.value = !_isDarkMode.value;
    GetStorage().write('isDarkMode', _isDarkMode.value);
  }
}

// the voltage manager 
class VoltageProvider {
  final _storage = Get.find<StorageService>(); // start the storage services

// read the volts list 
  List<Volt> readVolt() {
    var volt = <Volt>[]; // empty to get the data
    if (jsonDecode(_storage.read(voltageKey).toString()) != null) {
      // decode from jason
      jsonDecode(_storage.read(voltageKey).toString())
          .forEach((e) => volt.add(Volt.fromJson(e)));
    }
    return volt;
  }

// write or update
  void writeVolt(List<Volt> volt) {
    _storage.write(voltageKey, jsonEncode(volt));
  }
}

// shop manager
class ShopProvider {
  final _storage = Get.find<StorageService>();

  ShopData readTodayList() {
    ShopData result = shopData(); 
    Profile user = ProfileProvider().readProfile();
    if (user.date.isEmpty) {
      writeShopData(result);
    } else {
      if (int.parse(user.date) < DateTime.now().day) {
        writeShopData(result);
      } else {
        result.todayList = user.todayShop.join("_");
      }
    }

    return result;
  }

  void writeShopData(ShopData data) {
    Profile user = ProfileProvider().readProfile();
    ShopData data = shopData();
    user.date = data.date;
    user.todayShop = data.todayList.split("_");
  }

  bool checkStates() {
    return _storage.read(shopKey) == [];
  }
}
