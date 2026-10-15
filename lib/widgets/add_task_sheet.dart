import 'package:flutter/material.dart';
class AddTaskSheet extends StatefulWidget { const AddTaskSheet({super.key});
  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}
class _AddTaskSheetState extends State<AddTaskSheet> {
  final controller = TextEditingController();
  @override
  void dispose() { controller.dispose(); super.dispose(); }
  void save() { final text = controller.text.trim();
    if (text.isNotEmpty) Navigator.pop(context, text);
  }
  @override
  Widget build(BuildContext context) => Padding( padding: EdgeInsets.fromLTRB(22, 20, 22,
      MediaQuery.viewInsetsOf(context).bottom + 28),
    child: Column(mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Create a new goal ✨',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        TextField(controller: controller, autofocus: true, maxLength: 80,
          textCapitalization: TextCapitalization.sentences, onSubmitted: (_) => save(),
          decoration: InputDecoration(hintText: 'What do you want to do?',
            filled: true, fillColor: const Color(0xFF26214E),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)))),
        FilledButton.icon(onPressed: save, icon: const Icon(Icons.add),
          label: const Text('Add task')), ]));
}
