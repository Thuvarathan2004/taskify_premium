import 'package:flutter/material.dart';
import '../models/todo.dart';
class TaskList extends StatelessWidget { final List<Todo> tasks;
  final String filter;
  final ValueChanged<String> onFilter;
  final ValueChanged<String> onToggle, onDelete;
  const TaskList({super.key, required this.tasks, required this.filter,
    required this.onFilter, required this.onToggle, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    final visible = tasks.where((t) => filter == 'Completed' ? t.done :
      filter == 'Pending' ? !t.done : true).toList();
    final shades = [const Color(0xFFAD7AFF),
      const Color(0xFFFFBB5C), const Color(0xFF42E7C2)];
    return Padding(padding: const EdgeInsets.all(20), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('My Tasks ✨', style: TextStyle(
          fontSize: 30, fontWeight: FontWeight.w900)),
        const Text('Make every little step count',
          style: TextStyle(color: Colors.white70)), const SizedBox(height: 22),
        Wrap(spacing: 8, children: ['All', 'Pending', 'Completed'].asMap()
          .entries.map((e) => ChoiceChip(label: Text(e.value),
          selected: filter == e.value, selectedColor: shades[e.key],
          labelStyle: TextStyle(color: filter == e.value ? Colors.black :
            shades[e.key], fontWeight: FontWeight.bold),
          side: BorderSide(color: shades[e.key]),
          onSelected: (_) => onFilter(e.value))).toList()), const SizedBox(height: 18),
        Expanded(child: visible.isEmpty
          ? const Center(child: Text('Nothing here yet ✨'))
          : ListView.builder(itemCount: visible.length, itemBuilder: (_, i) {
            final t = visible[i];
            final shade = t.done ? shades[2] : shades[1];
            return Container(margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: [
                  shade.withAlpha(65), const Color(0xFF1A244B)]),
                border: Border.all(color: shade.withAlpha(110))), child: ListTile(
                leading: Checkbox(value: t.done, activeColor: shades[2],
                  onChanged: (_) => onToggle(t.id)),
                title: Text(t.title, style: TextStyle(
                  decoration: t.done ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.bold)),
                subtitle: Text(t.done ? '✓ Completed' : '● Pending',
                  style: TextStyle(color: shade)), trailing: IconButton.filledTonal(
                  style: IconButton.styleFrom( backgroundColor: const Color(0xFF65324E)),
                  tooltip: 'Delete task', onPressed: () => onDelete(t.id),
                  icon: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFFFF83AA))), ));
          })), ]));
  }
}
