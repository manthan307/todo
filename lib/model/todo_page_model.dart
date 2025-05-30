class TodoPage {
  final String id;
  final String title;

  TodoPage({required this.id, required this.title});

  TodoPage copyWith({String? title}) {
    return TodoPage(id: id, title: title ?? this.title);
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title};

  factory TodoPage.fromJson(Map<String, dynamic> json) =>
      TodoPage(id: json['id'], title: json['title']);
}
