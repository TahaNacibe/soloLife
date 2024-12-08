import 'dart:convert';
import 'dart:io';
import 'package:SoloLife/app/data/models/budget.dart';
import 'package:SoloLife/app/data/models/volt.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/solo.dart';
import 'package:SoloLife/app/data/models/state.dart';
import 'package:SoloLife/app/data/models/task.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File> saveObjectsToFile(
    Profile user,
    UserState state,
    List<Daily> dailies,
    List<Task> tasks,
    List<Volt> volts,
    List<deposit> budget) async {
  // Request permissions
  var status = await Permission.storage.request();
  if (!status.isGranted) {
    throw Exception('Storage permission not granted');
  }
  // Create directory
  final directory = Directory('/storage/emulated/0/Download');
  if (!(await directory.exists())) {
    await directory.create(recursive: true);
  }

  final filePath = path.join(directory.path, 'SoloLifeBuckUp.json');

  // Convert objects to JSON with type information
  List<Map<String, dynamic>> jsonList = [
    ObjectWrapper(objectType: 'Profile', data: user.toJson()).toJson(),
    ObjectWrapper(objectType: 'UserState', data: state.toJson()).toJson(),
    ObjectWrapper(
            objectType: 'DailyList',
            data: {'dailies': dailies.map((item) => item.toJson()).toList()})
        .toJson(),
    ObjectWrapper(
        objectType: 'TaskList',
        data: {'tasks': tasks.map((item) => item.toJson()).toList()}).toJson(),
    ObjectWrapper(
        objectType: 'VoltageList',
        data: {'volt': volts.map((item) => item.toJson()).toList()}).toJson(),
    ObjectWrapper(
            objectType: 'budget',
            data: {'budget': budget.map((item) => item.toJson()).toList()})
        .toJson(),
  ];

  String jsonString = jsonEncode(jsonList);

  // Write the JSON string to the file
  print("is there");
  return File(filePath).writeAsString(jsonString);
}

Future<void> retrieveObjectsFromFile(
    BuildContext context) async {
  // Request permissions
  var status = await Permission.storage.request();
  if (!status.isGranted) {
    throw Exception('Storage permission not granted');
  }
  // Create directory
  final directory = Directory('/storage/emulated/0/Download');
  if (!(await directory.exists())) {
    await directory.create(recursive: true);
  }

  final filePath = path.join(directory.path, 'SoloLifeBuckUp.json');

  // Read the file
  String jsonString = await File(filePath).readAsString();

  // Decode the JSON string
  List<dynamic> jsonList = jsonDecode(jsonString);

  // Convert JSON to objects
  Profile? user;
  UserState? state;
  List<Daily>? dailies;
  List<Task>? tasks;
  List<Volt>? volts;
  List<deposit>? budget;

  for (var json in jsonList) {
    ObjectWrapper wrapper = ObjectWrapper.fromJson(json);
    switch (wrapper.objectType) {
      case 'Profile':
        user = Profile.fromJson(wrapper.data);
        break;
      case 'UserState':
        state = UserState.fromJson(wrapper.data);
        break;
      case 'DailyList':
        dailies = (wrapper.data['dailies'] as List<dynamic>)
            .map((item) => Daily.fromJson(item))
            .toList();
        break;
      case 'TaskList':
        tasks = (wrapper.data['tasks'] as List<dynamic>)
            .map((item) => Task.fromJson(item))
            .toList();
        break;
      case 'VoltageList':
        volts = (wrapper.data['volt'] as List<dynamic>)
            .map((item) => Volt.fromJson(item))
            .toList();
        break;
      case 'budget':
        budget = (wrapper.data['budget'] as List<dynamic>)
            .map((item) => deposit.fromJson(item))
            .toList();
        break;
      default:
        throw Exception('Unknown object type');
    }
  }

  ProfileProvider().saveProfile(user!, "", context);
  StatesProvider().writeState(state!);
  DailyTasks().writeTasks(dailies!);
  TaskProvider().writeTasks(tasks!);
  Amount().writeBudget(budget!);
  VoltageProvider().writeVolt(volts!);
}

class ObjectWrapper {
  final String objectType;
  final Map<String, dynamic> data;

  ObjectWrapper({required this.objectType, required this.data});

  Map<String, dynamic> toJson() => {
        'objectType': objectType,
        'data': data,
      };

  factory ObjectWrapper.fromJson(Map<String, dynamic> json) => ObjectWrapper(
        objectType: json['objectType'],
        data: Map<String, dynamic>.from(json['data']),
      );
}

Future<void> fastSaveBackup() async {
  Profile user = ProfileProvider().readProfile();
  UserState state = StatesProvider().readState();
  List<Daily> dailies = DailyTasks().readTasks();
  List<Task> tasks = TaskProvider().readTasks();
  List<Volt> volts = VoltageProvider().readVolt();
  List<deposit> budget = Amount().readBudget();
  await saveObjectsToFile(user, state, dailies, tasks, volts, budget);
}

Future<void> getData(BuildContext context) async {
  await retrieveObjectsFromFile(context);

}
