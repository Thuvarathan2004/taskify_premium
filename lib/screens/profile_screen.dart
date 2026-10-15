import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, String> profile;
  final Future<void> Function(Map<String, String>) onSave;

  const ProfileScreen({super.key, required this.profile, required this.onSave});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();
  late final name = TextEditingController(text: widget.profile['name'] ?? '');
  late final email = TextEditingController(text: widget.profile['email'] ?? '');
  late final bio = TextEditingController(text: widget.profile['bio'] ?? '');
  late String avatar = widget.profile['avatar'] ?? '🚀';
  bool saving = false;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    bio.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => saving = true);
    try {
      await widget.onSave({
        'name': name.text.trim(),
        'email': email.text.trim(),
        'bio': bio.text.trim(),
        'avatar': avatar,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully 💜')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save profile')),
        );
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        child: ListView(padding: const EdgeInsets.all(22), children: [
          const Text('My Profile 💜',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF983DE4), Color(0xFF236EDB)],
              ),
            ),
            child: Column(children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.white24,
                child: Text(avatar, style: const TextStyle(fontSize: 43)),
              ),
              const SizedBox(height: 10),
              Text(widget.profile['name']?.isNotEmpty == true
                  ? 'Edit Your Profile'
                  : 'Create Your Profile'),
            ]),
          ),
          const SizedBox(height: 16),
          const Text('Choose your avatar'),
          Wrap(spacing: 7, children: [
            for (final emoji in ['🚀', '🌈', '🐼', '🔥', '⭐', '💜'])
              ChoiceChip(
                label: Text(emoji),
                selected: avatar == emoji,
                onSelected: (_) => setState(() => avatar = emoji),
              ),
          ]),
          const SizedBox(height: 12),
          TextFormField(
            controller: name,
            maxLength: 32,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (v) => v == null || v.trim().isEmpty
                ? 'Name is required'
                : null,
          ),
          TextFormField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (v) {
              final value = v?.trim() ?? '';
              return value.contains('@') && value.split('@').last.contains('.')
                  ? null
                  : 'Enter a valid email';
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: bio,
            maxLength: 100,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Short bio (optional)'),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: saving ? null : save,
            icon: const Icon(Icons.save_rounded),
            label: Text(saving ? 'Saving...' : 'Save Profile'),
          ),
        ]),
      );
}
