import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
class TodoStorage { final _prefs = SharedPreferencesAsync();
  Future<List<Todo>> load() async { final raw = await _prefs.getString('taskify_todos');
    if (raw == null) return [];
    return (jsonDecode(raw) as List).map((e) =>
      Todo.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }
  Future<void> save(List<Todo> tasks) => _prefs.setString('taskify_todos',
    jsonEncode(tasks.map((t) => t.toJson()).toList()));
  Future<Map<String, String>> loadProfile() async {
    final raw = await _prefs.getString('taskify_profile');
    return raw == null ? {} : Map<String, String>.from(jsonDecode(raw) as Map);
  }
  Future<void> saveProfile(String name, String bio, String avatar) =>
    _prefs.setString('taskify_profile', jsonEncode(
      {'name': name, 'bio': bio, 'avatar': avatar}));
}
