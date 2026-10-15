import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_storage.dart';
import '../widgets/task_list.dart';
import 'profile_screen.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = TodoStorage();
  List<Todo> tasks = [];
  Map<String, String> profile = {};
  String filter = 'All';
  int tab = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final savedTasks = await storage.load();
      final savedProfile = await storage.loadProfile();
      if (mounted) {
        setState(() {
          tasks = savedTasks;
          profile = savedProfile;
        });
      }
    } catch (_) {
      message('Could not load saved data');
    }
  }

  void message(String value) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  Future<void> persist() async {
    try {
      await storage.save(tasks);
    } catch (_) {
      message('Could not save tasks');
    }
  }

  Future<void> saveProfile(Map<String, String> value) async {
    await storage.saveProfile(value);
    if (mounted) setState(() => profile = value);
  }

  Future<void> openForm([Todo? existing]) async {
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormScreen(
          initial: existing,
          defaultName: profile['name'] ?? '',
        ),
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      final index = tasks.indexWhere((task) => task.id == result.id);
      if (index == -1) {
        tasks.insert(0, result);
      } else {
        tasks[index] = result;
      }
      tab = 1; // Sir's flow: Save -> To-Do List page.
      filter = 'All';
    });
    await persist();
    message(existing == null ? 'Task added!' : 'Task updated!');
  }

  void approve(Todo task) {
    final index = tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    setState(() {
      tasks[index] = task.copyWith(
        status: task.status == 'Approved' ? 'Pending' : 'Approved',
      );
    });
    persist();
  }

  Future<void> delete(Todo task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete this task?'),
        content: Text(task.title),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep')),
          TextButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.redAccent))),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() => tasks.removeWhere((item) => item.id == task.id));
    await persist();
    message('Task deleted');
  }

  void openSection(String section) => setState(() {
        tab = 1;
        filter = section;
      });

  void notifications() {
    final waiting = tasks.where((t) => t.status == 'Todo' || t.status == 'Pending').toList();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Task Notifications 🔔',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 14),
            if (waiting.isEmpty)
              const Text('Nothing pending right now 🎉')
            else
              SizedBox(
                height: 230,
                child: ListView.builder(
                  itemCount: waiting.length,
                  itemBuilder: (_, i) => ListTile(
                    leading: const Icon(Icons.notifications_active_outlined,
                        color: Colors.orangeAccent),
                    title: Text(waiting[i].title),
                    subtitle: Text('Status: ${waiting[i].status} • Due: '
                        '${waiting[i].dueDate.isEmpty ? 'Not set' : waiting[i].dueDate}'),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final approved = tasks.where((t) => t.status == 'Approved').length;
    final progress = tasks.isEmpty ? 0.0 : approved / tasks.length;
    return Scaffold(
      body: SafeArea(
        child: tab == 0
            ? dashboard(approved, progress)
            : tab == 1
                ? TaskList(
                    tasks: tasks,
                    filter: filter,
                    onFilter: (value) => setState(() => filter = value),
                    onEdit: (task) => openForm(task),
                    onDelete: delete,
                    onApprove: approve,
                  )
                : tab == 2
                    ? stats(approved, progress)
                    : ProfileScreen(
                        key: ValueKey(profile.toString()),
                        profile: profile,
                        onSave: saveProfile,
                      ),
      ),
      floatingActionButton: tab == 3
          ? null
          : FloatingActionButton.extended(
              backgroundColor: const Color(0xFFFF60B9),
              foregroundColor: Colors.white,
              onPressed: openForm,
              icon: const Icon(Icons.add),
              label: const Text('Add To-Do'),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        backgroundColor: const Color(0xFF151A3C),
        indicatorColor: const Color(0xFF6F3DB5),
        onDestinationSelected: (index) => setState(() => tab = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'List'),
          NavigationDestination(icon: Icon(Icons.donut_large), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget dashboard(int approved, double progress) {
    final pending = tasks.where((t) => t.status == 'Pending').length;
    final cancelled = tasks.where((t) => t.status == 'Cancelled').length;
    final waiting = tasks.where((t) => t.status == 'Todo' || t.status == 'Pending').length;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 100), children: [
      Row(children: [
        const Expanded(child: Text('Taskify ✨',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900))),
        IconButton(
          onPressed: notifications,
          tooltip: 'Task notifications',
          icon: Badge(
            isLabelVisible: waiting > 0,
            label: Text('$waiting'),
            child: const Icon(Icons.notifications_outlined),
          ),
        ),
        InkWell(
          onTap: () => setState(() => tab = 3),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF8A4BDD),
            child: Text(profile['avatar'] ?? '🚀'),
          ),
        ),
      ]),
      const SizedBox(height: 20),
      Text('Hi, ${profile['name']?.isNotEmpty == true ? profile['name'] : 'superstar'}! 👋',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
      if (profile['email']?.isNotEmpty == true)
        Text(profile['email']!, style: const TextStyle(color: Colors.white70)),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(colors: [Color(0xFFAB3EDB), Color(0xFF375CF7)]),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$approved / ${tasks.length} tasks approved',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 14),
          LinearProgressIndicator(value: progress, minHeight: 8,
              color: const Color(0xFF54FFCF), backgroundColor: Colors.white30),
          const SizedBox(height: 8),
          const Text('Dream • Plan • Achieve 🌈'),
        ]),
      ),
      const SizedBox(height: 22),
      const Text('Your To-Do Dashboard',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: .91,
        children: [
          card('All', 'Total To-Do', tasks.length, 'all.jpg', const Color(0xFF5BAEFF)),
          card('Pending', 'Pending', pending, 'pending.jpg', const Color(0xFFFFAE4C)),
          card('Approved', 'Approved', approved, 'completed.jpg', const Color(0xFF42E8AD)),
          card('Cancelled', 'Cancelled', cancelled, 'stats.jpg', const Color(0xFFFF6D8F)),
        ],
      ),
      const SizedBox(height: 19),
      FilledButton.icon(
        onPressed: openForm,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Add New To-Do'),
      ),
    ]);
  }

  Widget card(String section, String label, int count, String image, Color tint) =>
      InkWell(
        onTap: () => openSection(section),
        borderRadius: BorderRadius.circular(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(fit: StackFit.expand, children: [
            Image.asset('assets/images/$image', fit: BoxFit.cover),
            DecoratedBox(decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [tint.withAlpha(130), const Color(0xEF07122F)],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.north_east, color: tint),
                const Spacer(),
                Text('$count', style: const TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w900)),
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ),
          ]),
        ),
      );

  Widget stats(int approved, double progress) => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('Your Progress 🌈',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 28),
          SizedBox(
            height: 180,
            width: 180,
            child: Stack(fit: StackFit.expand, children: [
              CircularProgressIndicator(value: progress, strokeWidth: 16,
                color: const Color(0xFF42E8AD),
                backgroundColor: const Color(0xFF303358)),
              Center(child: Text('${(progress * 100).round()}%',
                  style: const TextStyle(fontSize: 39, fontWeight: FontWeight.w900))),
            ]),
          ),
          const SizedBox(height: 20),
          Text('$approved approved of ${tasks.length} tasks'),
        ]),
      );
}
