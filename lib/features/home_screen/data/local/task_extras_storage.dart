import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_creative_routine/features/home_screen/data/models/task_model.dart';

class TaskExtrasStorage {
  static const String _key = 'task_extras';

  static Future<Map<String, dynamic>> _readAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};
    final decoded = jsonDecode(raw);
    return decoded is Map<String, dynamic> ? decoded : {};
  }

  static Future<List<TaskModel>> attachTo(List<TaskModel> tasks) async {
    final all = await _readAll();
    return tasks.map((task) => task.withExtras(all[task.id] as Map?)).toList();
  }

  static Future<void> save(TaskModel task) async {
    if (task.id.isEmpty) return;
    final all = await _readAll();
    all[task.id] = task.extrasToJson();
    await _write(all);
  }

  static Future<void> remove(String taskId) async {
    final all = await _readAll();
    all.remove(taskId);
    await _write(all);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  static Future<void> _write(Map<String, dynamic> all) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(all));
  }
}
