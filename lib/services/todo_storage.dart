import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoStorage {
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  // Preserve storage keys used in the earlier Taskify release.
  Future<List<Todo>> load() async {
    final saved = await _prefs.getString('taskify_todos');
    if (saved == null) return [];
    return (jsonDecode(saved) as List)
        .map((item) => Todo.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  Future<void> save(List<Todo> todos) async {
    await _prefs.setString(
      'taskify_todos',
      jsonEncode(todos.map((task) => task.toJson()).toList()),
    );
  }

  Future<Map<String, String>> loadProfile() async {
    final saved = await _prefs.getString('taskify_profile');
    if (saved == null) return {};
    return Map<String, String>.from(jsonDecode(saved) as Map);
  }

  Future<void> saveProfile(Map<String, String> profile) async {
    await _prefs.setString('taskify_profile', jsonEncode(profile));
  }
}
