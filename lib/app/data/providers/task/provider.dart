import 'dart:convert';
import 'package:SoloLife/annoncment/levelUp.dart';
import 'package:SoloLife/app/data/models/achivments.dart';
import 'package:SoloLife/app/data/models/budget.dart';
import 'package:SoloLife/app/data/models/profile.dart';
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


class TaskProvider {
  final _storage = Get.find<StorageService>();

  List<Task> readTasks() {
    var tasks = <Task>[];
    jsonDecode(_storage.read(taskKey).toString())
        .forEach((e) => tasks.add(Task.fromJson(e)));
    return tasks;
  }

  void writeTasks(List<Task> tasks) {
    _storage.write(taskKey, jsonEncode(tasks));
  }
}



class ProfileProvider {
  final _storage = Get.find<StorageService>();

  //? write the user info
  void saveProfile(Profile profile,String mood,BuildContext context) {
    //? leveling up mechanics check if user level up
    if(mood == "exp"){
    int capExp = getExpToNextLevel(profile.level);
    int currentExp = profile.exp;// get user current exp
    UserState state = StatesProvider().readState();
    int point = state.points;
    // if level up with equal amount reset the exp
    if(capExp == profile.exp){
      profile.exp = 0;
      profile.level = profile.level + 1;
      state.points = point +10;
      profile.coins += 100;
      StatesProvider().writeState(state);
      levelUpDialog(context);
      achievementsHandler("level",context);
      // if he get more than the cap add the extra
    }else if(capExp < currentExp){

      int remain = currentExp - capExp;// the extra exp
      profile.exp = remain;
      profile.level = profile.level + 1;
      profile.coins += 100;
      state.points = point +10;
      StatesProvider().writeState(state);
      levelUpDialog(context);
      achievementsHandler("level",context);
    }
    }
    //? save the user data
    _storage.write(profileKey, profile.toJson());
}
  

  //? read the user info
  Profile readProfile(){
    final data = _storage.read(profileKey);
    Profile defaultUser = Profile(userName: "■ ■ ■ ■",level:1,exp:0,keys:[]);
  if (data == null){
    _storage.write(profileKey, defaultUser.toJson());
  } 
  return Profile.fromJson(data);
  }

  //? check the user state
  bool checkUserData(){
    bool state = _storage.read(profileKey) == {};
    return state;
  }
  //? check the user state
  bool checkUserState(){
    bool state = _storage.read(statesKey) == [];
    return state;
  }

}

class DailyTasks {
    var dailyTasks = <Daily>[];
  final _storage = Get.find<StorageService>();

  List<Daily> readTasks() {
    jsonDecode(_storage.read(dailyKey).toString())
        .forEach((e) => dailyTasks.add(Daily.fromJson(e)));
    return dailyTasks ;
  }

  void writeTasks(List<Daily> tasks) {
    _storage.write(dailyKey, jsonEncode(tasks));
  }


}

class DailyService{
  //? daily tasks manager 
  // Observable list to hold tasks
  List<Daily> tasks =  DailyTasks().readTasks();

    void resetUnfinishedTasks(BuildContext context) {
      Profile user = ProfileProvider().readProfile();
      int oldStrike = user.strike;
    for (var task in tasks) {
      DateTime now = DateTime.now();
     DateTime timesStamp = DateTime.parse(task.timeStamp);
    // Compare the date components
    if (now.year > timesStamp.year) {
      achievementForMissing(context);
      //strikeManager(context);
      // a year passed
      timesStamp = DateTime.now();
      task.timeStamp = timesStamp.toIso8601String();
      task.exp = getExpForTheTasks(userInfo.level,task.isFree);
      task.coins = getCoinsForTheTasks(task.isFree);
      task.isGoing = true;
    } else if (now.year == timesStamp.year && now.month > timesStamp.month) {
      achievementForMissing(context);
      //strikeManager(context);
      // a month passed
      timesStamp = DateTime.now();
      task.exp = getExpForTheTasks(userInfo.level,task.isFree);
      task.timeStamp = timesStamp.toIso8601String();
      task.coins = getCoinsForTheTasks(task.isFree);
      task.isGoing = true;
    } else if (now.year == timesStamp.year &&
        now.month == timesStamp.month &&
        now.day > timesStamp.day) {
          achievementForMissing(context);
          //strikeManager(context);
          // day passed
          timesStamp = DateTime.now();
          task.exp = getExpForTheTasks(userInfo.level,task.isFree);
          task.timeStamp = timesStamp.toIso8601String();
          task.coins = getCoinsForTheTasks(task.isFree);
          task.isGoing = true;
    }
    }
     // Update the UI with changes
    DailyTasks().writeTasks(tasks); // Save updated tasks to storage
  }

void strikeManager(BuildContext context){
  if(userInfo.keys!.contains("solo")){
  DateTime now = DateTime.now();
  Profile user = ProfileProvider().readProfile();
  List<Daily> tasksList = DailyTasks().readTasks();
  bool isSafe = false;
  DateTime timeStamp = DateTime.parse(tasksList[0].timeStamp);
  for (Daily task in tasksList) {
    if(!task.isGoing){
      isSafe = true;
      break;
    }
  }
  if (now.year == timeStamp.year &&
        now.month == timeStamp.month &&
        now.day > timeStamp.day) {
  if(isSafe){
  user.strike += 1;
  }else{
    user.strike = 0;
  }
  }
  ProfileProvider().saveProfile(user, "", context);
  }
}

 /* void achievementForMissing(BuildContext context,DateTime day1, DateTime day2){
    if(day1.difference(day2) > Duration(days: 1)){
      print("=====================yeb more than a day");
    achievementsHandler("penalty",context);
    if(tasks.length >= 20){
      print("==========================yeb tow");
       achievementsHandler("WhoLet",context);
    }
    }
  }*/
  void achievementForMissing(BuildContext context){
    for (Daily task in tasks) {
      if(task.isGoing == true){
        achievementsHandler("penalty",context);
      }
      if(task.isGoing == true && tasks.length >= 20){
        achievementsHandler("WhoLet",context);
      }
    }
  }
  void scheduleTaskReset(BuildContext context) {
    if(userInfo.keys!.contains('solo')){
       resetUnfinishedTasks(context);
    }
  }
}


class BudgetProvider {
  final _storage = Get.find<StorageService>();

  List<Budget> readBudget() {
    var budget = <Budget>[];
    if(jsonDecode(_storage.read(managerKey).toString()) != null){
    jsonDecode(_storage.read(managerKey).toString())
        .forEach((e) => budget.add(Budget.fromJson(e)));
    }
    return budget;
  }

  void writeBudget(List<Budget> budget) {
    _storage.write(managerKey, jsonEncode(budget));
  }

  int totalGater(List budget){
    int total = 0;
    int min = 0;
    for (Budget element in budget) {
      element.add
      ?total = total + element.amount
      :min = min + element.amount;
    }
    total = total - min;
    return total;
  }
}

class StatesProvider {
  final _storage = Get.find<StorageService>();

  UserState readState() {
    UserState result = UserState();
    if(jsonDecode(_storage.read(statesKey).toString()) != null){
    Map<String,dynamic> raw = jsonDecode(_storage.read(statesKey).toString());
        result = UserState.fromJson(raw);
    }else{
      writeState(result);
    }
    return result;
  }

  void writeState(UserState state) {
    _storage.write(statesKey, jsonEncode(state));
  }

  bool checkStates(){
    return _storage.read(statesKey) == [];
  }

}

String formatDateTime(DateTime now,bool full) {
  final day = now.day.toString().padLeft(2, '0'); // Pad with leading zero if necessary
  final month = DateFormat('MMM').format(now); // Use DateFormat for month abbreviation
  final year = now.year.toString();
  final hour = now.hour.toString().padLeft(2, '0');
  final minute = now.minute.toString().padLeft(2, '0');
  if(full){
  return '$day.$month.$year $hour:$minute';
  }else{
    return '$day.$month.$year';
  }
}

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



class VoltageProvider {
  final _storage = Get.find<StorageService>();

  List<Volt> readVolt() {
    var volt = <Volt>[];
    if(jsonDecode(_storage.read(voltageKey).toString()) != null){
    jsonDecode(_storage.read(voltageKey).toString())
        .forEach((e) => volt.add(Volt.fromJson(e)));
    }
    return volt;
  }

  void writeVolt(List<Volt> volt) {
    _storage.write(voltageKey, jsonEncode(volt));
  }


}
