import 'package:flutter/material.dart';
import '../models/todo.dart';

class TaskFormScreen extends StatefulWidget {
  final Todo? initial;
  final String defaultName;

  const TaskFormScreen({super.key, this.initial, this.defaultName = ''});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final formKey = GlobalKey<FormState>();
  late final name = TextEditingController(
    text: widget.initial?.name ?? widget.defaultName,
  );
  late final title = TextEditingController(text: widget.initial?.title ?? '');
  late final description = TextEditingController(
    text: widget.initial?.description ?? '',
  );
  late String status = widget.initial?.status ?? 'Todo';
  late DateTime? dueDate = DateTime.tryParse(widget.initial?.dueDate ?? '');
  late final String taskId = widget.initial?.id ??
      DateTime.now().microsecondsSinceEpoch.toString();

  @override
  void dispose() {
    name.dispose();
    title.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null && mounted) setState(() => dueDate = date);
  }

  void saveTask() {
    if (!formKey.currentState!.validate()) return;
    final saved = Todo(
      id: taskId,
      name: name.text.trim(),
      title: title.text.trim(),
      description: description.text.trim(),
      dueDate: dueDate?.toIso8601String().split('T').first ?? '',
      status: status,
    );
    Navigator.pop(context, saved);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.initial == null ? 'Add New To-Do ✨' : 'Update To-Do ✏️'),
          backgroundColor: const Color(0xFF151A3C),
        ),
        body: SafeArea(
          child: Form(
            key: formKey,
            child: ListView(padding: const EdgeInsets.all(20), children: [
              Text('Task ID: $taskId',
                  style: const TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 18),
              TextFormField(
                controller: name,
                maxLength: 40,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your name'
                    : null,
              ),
              TextFormField(
                controller: title,
                maxLength: 80,
                decoration: const InputDecoration(labelText: 'Task title'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a task title'
                    : null,
              ),
              TextFormField(
                controller: description,
                maxLines: 3,
                maxLength: 250,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: pickDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(dueDate == null
                    ? 'Select due date (optional)'
                    : 'Due: ${dueDate!.toIso8601String().split('T').first}'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: Todo.statuses
                    .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                    .toList(),
                onChanged: (value) => setState(() => status = value ?? status),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: saveTask,
                icon: const Icon(Icons.save_rounded),
                label: Text(widget.initial == null ? 'Save New To-Do' : 'Save Changes'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF9A4DFF),
                  padding: const EdgeInsets.all(18),
                ),
              ),
            ]),
          ),
        ),
      );
}
