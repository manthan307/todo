import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/model/todo_page_model.dart';

part 'todo_pages.g.dart';

@riverpod
class TodoPageNotifier extends _$TodoPageNotifier {
  static const String _listKey = 'todo_pages';

  @override
  List<TodoPage> build() {
    _loadFromPrefs(); // async, non-blocking
    return [TodoPage(id: 'default', title: 'My Tasks')]; // default fallback
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_listKey);
    if (jsonString != null) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonString);
        final List<TodoPage> loaded = decoded
            .map((e) => TodoPage.fromJson(e))
            .toList();
        state = loaded;
      } catch (e) {
        // If JSON is corrupted or invalid, fallback silently
      }
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_listKey, jsonString);
  }

  void addList(String title) {
    if (title.trim().isEmpty) return;
    final newList = TodoPage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    state = [...state, newList];
    _saveToPrefs();
  }

  void removeList(String id) {
    state = state.where((item) => item.id != id).toList();
    _saveToPrefs();
  }

  void updateList(String id, String newTitle) {
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(title: newTitle) else item,
    ];
    _saveToPrefs();
  }
}
