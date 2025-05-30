class Todo {
  final String id;
  final String title;
  final bool completed;
  final bool fav;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
    this.fav = false,
  });

  Todo copyWith({String? title, bool? completed, bool? fav}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      fav: fav ?? this.fav,
    );
  }
}
