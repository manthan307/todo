import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo/model/todo_model.dart';

part 'todo_provider.g.dart';

@riverpod
class TodoProvider extends _$TodoProvider {
  @override
  List<Todo> build() => [];

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }

  void toggleCompleted(String id) {
    state = state
        .map(
          (todo) =>
              todo.id == id ? todo.copyWith(completed: !todo.completed) : todo,
        )
        .toList();
  }

  void toggleFavorite(String id) {
    state = state
        .map((todo) => todo.id == id ? todo.copyWith(fav: !todo.fav) : todo)
        .toList();
  }

  void updateTodo(Todo updatedTodo) {
    state = state
        .map((todo) => todo.id == updatedTodo.id ? updatedTodo : todo)
        .toList();
  }

  List<Todo> getTodosByList(String listId) {
    return state.where((todo) => todo.listId == listId).toList();
  }

  void clearCompleted(String listId) {
    state = state
        .where((todo) => todo.listId != listId || !todo.completed)
        .toList();
  }
}
