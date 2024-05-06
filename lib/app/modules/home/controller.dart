import 'package:SoloLife/app/data/models/profile.dart';
import 'package:SoloLife/app/data/models/task.dart';
import 'package:SoloLife/app/data/providers/task/provider.dart';
import 'package:SoloLife/app/data/services/expScal/exp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:SoloLife/app/data/services/storage/repository.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});
  final formKey = GlobalKey<FormState>();
  final editCtrl = TextEditingController();
  final tapIndex = 0.obs;
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;
  final Profile user = ProfileProvider().readProfile();


  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
    editCtrl.dispose();
    super.onClose();
  }

  void changeTapIndex(int index) {
    tapIndex.value = index;
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void changeTask(Task? select) {
    task.value = select;
  }

//? global variable user profile
    Profile userData = ProfileProvider().readProfile();
//? set as done or not
  void changeTodos(List<dynamic> select) {
    doingTodos.clear();
    doneTodos.clear();
    for (int i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status == true) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }
//? add new taskParent if not already exist
  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }
//? delete taskParent from the list
  void deleteTask(Task task) {
    tasks.remove(task);
  }

  updateTask(Task task, String title) {
    var todos = task.todos ?? [];
    if (containeTodo(todos, title)) {
      return false;
    }
    var todo = {'title': title, 'done': false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    return true;
  }
//? return true if exist in the list else false
  bool containeTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }
//? add new sub task 'toDo' to parent Task
  bool addTodo(String title,bool state) {
    bool isFree = false;
      if (title.contains("--free") || state) {
      title = title.replaceAll("--free", "");
      isFree = true;
  }
    int level = user.level;
    int exp = getExpForTheTasks(level,isFree);
    int coins = getCoinsForTheTasks(isFree);
    print("===========$coins");
    var todo = {'title': title, 'done': false,'exp':exp, 'coins':coins};
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }
    var doneTodo = {'title': title, 'done': true, "exp":exp, 'coins':coins};
    if (doneTodos
        .any((element) => mapEquals<String, dynamic>(doneTodo, element))) {
      return false;
    }
    doingTodos.add(todo);
    return true;
  }
//? update the toDos List
  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos,
    ]);
    print(task.value);
    var newTask = task.value!.copyWith(todos: newTodos);
    print(newTask);
    int oldIdx = tasks.indexOf(task.value);
    tasks[oldIdx] = newTask;
    tasks.refresh();
  }
//? set a subTask as done or not done ??
  void doneTodo(String title,int addExp, int coins) {
    var doingTodo = {'title': title, 'done': false,"exp":addExp, "coins":coins};
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
        print("=============$index");
    doingTodos.removeAt(index);
    var doneTodo = {'title': title, 'done': true,"exp":addExp, "coins":coins};
    doneTodos.add(doneTodo);
    // add the new exp to the user
    userData.exp = userData.exp + addExp;
    userData.coins = userData.coins + coins;
    ProfileProvider().saveProfile(userData,"exp");
    doingTodos.refresh();
    doneTodos.refresh();
  }
//? delete the finished toDos
  void deleteDoneTodo(dynamic doneTodo) {
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  //? delete the ongoing toDos
  void deleteDoingTodo(dynamic doingTodo) {
    int index = doingTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    doingTodos.refresh();
  }
//? return true if the subTask List is empty
  bool isTodosEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }
//? get the number of done subTasks
  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res += 1;
      }
    }
    return res;
  }
//? get number of all the SubTasks 
  int getTotalTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }
//? get the number of the subTasks that are finished
  int getTotalDoneTask() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (int j = 0; j < tasks[i].todos!.length; j++) {
          if (tasks[i].todos![j]['done'] == true) {
            res += 1;
          }
        }
      }
    }
    return res;
  }
}
