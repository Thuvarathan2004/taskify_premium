import 'package:flutter/material.dart';
import '../models/todo.dart';

class TaskList extends StatelessWidget {
  final List<Todo> tasks;
  final String filter;
  final ValueChanged<String> onFilter;
  final ValueChanged<Todo> onEdit;
  final ValueChanged<Todo> onDelete;
  final ValueChanged<Todo> onApprove;

  const TaskList({
    super.key,
    required this.tasks,
    required this.filter,
    required this.onFilter,
    required this.onEdit,
    required this.onDelete,
    required this.onApprove,
  });

  static Color statusColor(String value) => switch (value) {
        'Todo' => const Color(0xFF5BAEFF),
        'Pending' => const Color(0xFFFFAE4C),
        'Approved' => const Color(0xFF42E8AD),
        'Cancelled' => const Color(0xFFFF6D8F),
        _ => const Color(0xFFB68BFF),
      };

  @override
  Widget build(BuildContext context) {
    final visible = tasks.where((t) => filter == 'All' || t.status == filter).toList();
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('My To-Do List ✨',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        Text('${tasks.length} tasks • Tap edit to update status',
            style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 17),
        SizedBox(
          height: 43,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final item in ['All', ...Todo.statuses])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(item),
                    selected: filter == item,
                    side: BorderSide(color: statusColor(item)),
                    selectedColor: statusColor(item),
                    labelStyle: TextStyle(
                      color: filter == item ? Colors.black : statusColor(item),
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (_) => onFilter(item),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 17),
        Expanded(
          child: visible.isEmpty
              ? const Center(child: Text('No tasks in this section yet ✨'))
              : ListView.builder(
                  itemCount: visible.length,
                  itemBuilder: (_, index) {
                    final task = visible[index];
                    final color = statusColor(task.status);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(colors: [
                          color.withAlpha(68),
                          const Color(0xFF17203F),
                        ]),
                        border: Border.all(color: color.withAlpha(150)),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Checkbox(
                            value: task.status == 'Approved',
                            activeColor: const Color(0xFF42E8AD),
                            onChanged: (_) => onApprove(task),
                          ),
                          Expanded(
                            child: Text(task.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                          IconButton(
                            tooltip: 'Update task',
                            onPressed: () => onEdit(task),
                            icon: const Icon(Icons.edit, color: Color(0xFF75BDFF)),
                          ),
                          IconButton(
                            tooltip: 'Delete task',
                            onPressed: () => onDelete(task),
                            icon: const Icon(Icons.delete_outline,
                                color: Color(0xFFFF6D8F)),
                          ),
                        ]),
                        if (task.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 7),
                            child: Text(task.description, maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Wrap(spacing: 12, runSpacing: 5, children: [
                            Text('● ${task.status}', style: TextStyle(color: color)),
                            if (task.name.isNotEmpty) Text('👤 ${task.name}'),
                            if (task.dueDate.isNotEmpty) Text('📅 ${task.dueDate}'),
                          ]),
                        ),
                      ]),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}
