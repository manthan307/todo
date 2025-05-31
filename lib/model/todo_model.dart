import 'package:uuid/uuid.dart';

class Todo {
  static const _uuid = Uuid(); // UUID instance

  final String id;
  String title;
  String? description;
  bool completed;
  bool fav;
  String listId;
  final DateTime createdAt;

  Todo({
    String? id,
    required this.title,
    this.description,
    this.completed = false,
    this.fav = false,
    required this.listId,
    DateTime? createdAt, // Accept externally or auto-generate
  }) : id = id ?? _uuid.v6(),
       createdAt = createdAt ?? DateTime.now(); // 👈 default to now

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    bool? fav,
    String? listId,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      fav: fav ?? this.fav,
      listId: listId ?? this.listId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'completed': completed,
    'fav': fav,
    'listId': listId,
    'createdAt': createdAt.toIso8601String(), // Save as ISO string
  };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'] as String?,
    title: json['title'] as String,
    description: json['description'] as String?,
    completed: json['completed'] ?? false,
    fav: json['fav'] ?? false,
    listId: json['listId'],
    createdAt: DateTime.parse(json['createdAt']), // Parse string to DateTime
  );
}
