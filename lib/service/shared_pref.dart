import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../model/task_model.dart';

class SharedPrefService {
  static const String taskKey = "tasks";

  /// Save task list
  static Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> taskList = tasks
        .map((task) => jsonEncode(task.toJson()))
        .toList();

    await prefs.setStringList(taskKey, taskList);
  }

  /// Load task list
  static Future<List<TaskModel>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? taskList = prefs.getStringList(taskKey);

    print("Stored Tasks: $taskList");

    if (taskList == null) {
      return [];
    }

    return taskList
        .map((task) => TaskModel.fromJson(jsonDecode(task)))
        .toList();
  }
}
