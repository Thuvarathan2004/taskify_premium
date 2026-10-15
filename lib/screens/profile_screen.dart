import 'package:flutter/material.dart';
class ProfileScreen extends StatefulWidget { final String name, bio, avatar;
  final void Function(String, String, String) onSave;
  const ProfileScreen({super.key, required this.name, required this.bio,
    required this.avatar, required this.onSave});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  late final name = TextEditingController(text: widget.name);
  late final bio = TextEditingController(text: widget.bio);
  late String avatar = widget.avatar;
  @override
  void dispose() { name.dispose(); bio.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(22), child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Your Profile 💜', style: TextStyle(
          fontSize: 29, fontWeight: FontWeight.w900)), const SizedBox(height: 20),
        Container(padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(colors: [
              Color(0xFF8E3DDE), Color(0xFF2371CA)])), child: Column(children: [
            CircleAvatar(radius: 44, backgroundColor: Colors.white24,
              child: Text(avatar, style: const TextStyle(fontSize: 46))),
            const SizedBox(height: 9),
            Text(widget.name.isEmpty ? 'Create your profile' : 'Edit your profile',
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)), ])),
        const SizedBox(height: 18), const Text('Choose your avatar'),
        Wrap(spacing: 6, children: ['🚀', '🌈', '🐼', '🔥', '⭐', '💜']
          .map((e) => ChoiceChip(label: Text(e), selected: avatar == e,
            onSelected: (_) => setState(() => avatar = e))).toList()),
        const SizedBox(height: 15), TextField(controller: name, maxLength: 32,
          decoration: const InputDecoration(labelText: 'Your name',
            prefixIcon: Icon(Icons.person), border: OutlineInputBorder())),
        const SizedBox(height: 10),
        TextField(controller: bio, maxLength: 100, maxLines: 2,
          decoration: const InputDecoration(labelText: 'Short bio',
            prefixIcon: Icon(Icons.edit_note), border: OutlineInputBorder())),
        const SizedBox(height: 15), FilledButton.icon(onPressed: () {
          final value = name.text.trim();
          if (value.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter your name')));
            return;
          }
          widget.onSave(value, bio.text.trim(), avatar);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile saved! 💜')));
        }, icon: const Icon(Icons.save_rounded), label: const Text('Save profile')), ]));
}
