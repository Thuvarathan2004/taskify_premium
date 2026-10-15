class Todo { final String id, title;
  final bool done;
  const Todo(this.id, this.title, {this.done = false});
  Todo toggle() => Todo(id, title, done: !done);
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'done': done};
  factory Todo.fromJson(Map<String, dynamic> m) => Todo(
    m['id'] as String, m['title'] as String, done: m['done'] as bool? ?? false);
}
