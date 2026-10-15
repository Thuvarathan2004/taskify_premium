class Todo {
  static const statuses = ['Todo', 'Pending', 'Approved', 'Cancelled'];

  final String id;
  final String name;
  final String title;
  final String description;
  final String dueDate;
  final String status;

  const Todo({
    required this.id,
    required this.name,
    required this.title,
    this.description = '',
    this.dueDate = '',
    this.status = 'Todo',
  });

  Todo copyWith({
    String? name,
    String? title,
    String? description,
    String? dueDate,
    String? status,
  }) => Todo(
        id: id,
        name: name ?? this.name,
        title: title ?? this.title,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'status': status,
      };

  factory Todo.fromJson(Map<String, dynamic> data) {
    // Earlier Taskify versions stored a boolean named "done".
    // Keep those existing local tasks when upgrading to four statuses.
    final oldStatus = data['done'] == true ? 'Approved' : 'Pending';
    final rawStatus = data['status']?.toString() ?? oldStatus;
    final safeStatus = rawStatus == 'Completed' ? 'Approved' : rawStatus;
    return Todo(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      dueDate: data['dueDate']?.toString() ?? '',
      status: statuses.contains(safeStatus) ? safeStatus : 'Pending',
    );
  }
}
