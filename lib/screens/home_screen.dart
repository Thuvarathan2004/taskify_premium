import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/todo_storage.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/task_list.dart';
import 'profile_screen.dart';
class HomeScreen extends StatefulWidget { const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> { final storage = TodoStorage();
  List<Todo> tasks = [];
  String filter = 'All', name = '', bio = '', avatar = '🚀';
  int tab = 0;
  @override
  void initState() { super.initState(); load(); }
  Future<void> load() async { try { final data = await storage.load();
      final profile = await storage.loadProfile();
      if (mounted) { setState(() { tasks = data; name = profile['name'] ?? '';
        bio = profile['bio'] ?? ''; avatar = profile['avatar'] ?? '🚀';
      }); }
    } catch (_) { message('Could not load saved data'); }
  }
  void message(String s) { if (mounted) { ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s))); }
  }
  Future<void> persist() async { try { await storage.save(tasks); }
    catch (_) { message('Could not save tasks'); }
  }
  Future<void> add() async {
    final title = await showModalBottomSheet<String>(context: context,
      isScrollControlled: true, showDragHandle: true,
      builder: (_) => const AddTaskSheet());
    if (!mounted || title == null) return;
    setState(() => tasks.insert(0,
      Todo(DateTime.now().microsecondsSinceEpoch.toString(), title)));
    persist();
  }
  void toggle(String id) { final i = tasks.indexWhere((t) => t.id == id);
    if (i < 0) return;
    setState(() => tasks[i] = tasks[i].toggle());
    persist();
  }
  void delete(String id) { setState(() => tasks.removeWhere((t) => t.id == id));
    persist();
  }
  void open(String section) => setState(() { tab = section == 'Stats' ? 2 : 1;
    filter = section == 'Stats' ? 'All' : section;
  });
  Future<void> saveProfile(String n, String b, String e) async {
    setState(() { name = n; bio = b; avatar = e; });
    try { await storage.saveProfile(n, b, e); }
    catch (_) { message('Could not save profile'); }
  }
  @override
  Widget build(BuildContext context) { final done = tasks.where((t) => t.done).length;
    final progress = tasks.isEmpty ? 0.0 : done / tasks.length;
    return Scaffold( body: SafeArea(child: tab == 0 ? dashboard(done, progress) :
        tab == 1 ? TaskList(tasks: tasks, filter: filter,
          onFilter: (v) => setState(() => filter = v),
          onToggle: toggle, onDelete: delete) :
        tab == 2 ? stats(done, progress) : ProfileScreen(
          key: ValueKey('$name|$bio|$avatar'),
          name: name, bio: bio, avatar: avatar, onSave: saveProfile)),
      floatingActionButton: tab == 3 ? null : FloatingActionButton(
        onPressed: add, backgroundColor: const Color(0xFFFF5FBC),
        child: const Icon(Icons.add, size: 30, color: Colors.white)),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF151A3C), selectedIndex: tab,
        indicatorColor: const Color(0xFF6F3DB5),
        onDestinationSelected: (v) => setState(() => tab = v), destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.task_alt), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.donut_large), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'), ]));
  }
  Widget dashboard(int done, double progress) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 85),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Taskify ✨', style: TextStyle(fontSize: 27,
          fontWeight: FontWeight.w900)), InkWell(onTap: () => setState(() => tab = 3),
          child: CircleAvatar(backgroundColor: const Color(0xFF8A4BDD),
            child: Text(avatar, style: const TextStyle(fontSize: 22)))), ]),
      const SizedBox(height: 24), Text('Hey, ${name.isEmpty ? 'superstar' : name}! 👋',
        style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
      const Text('Ready to make today amazing?', style: TextStyle(color: Colors.white70)),
      const SizedBox(height: 23), Container(padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(colors: [
            Color(0xFFAB3EDB), Color(0xFF375CF7)])),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$done / ${tasks.length} tasks completed',
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          LinearProgressIndicator(value: progress, minHeight: 9,
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFF54FFCF), backgroundColor: Colors.white30),
          const SizedBox(height: 8), const Text('Every step is a win 🌈'), ])),
      const SizedBox(height: 27), const Text('Explore your space', style: TextStyle(
        fontSize: 23, fontWeight: FontWeight.bold)), const SizedBox(height: 13),
      GridView.count(shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2,
        mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: .83, children: [
          card('All', 'All Tasks', tasks.length, 'all.jpg', const Color(0xFFA65CFF)),
          card('Pending', 'Pending', tasks.length - done, 'pending.jpg',
            const Color(0xFFFFA839)),
          card('Completed', 'Completed', done, 'completed.jpg', const Color(0xFF2FE3BD)),
          card('Stats', 'Your Stats', (progress * 100).round(), 'stats.jpg',
            const Color(0xFF4EBBFF), suffix: '%'), ]), ]));
  Widget card(String key, String label, int count, String picture, Color tint,
      {String suffix = ''}) => InkWell(onTap: () => open(key),
    borderRadius: BorderRadius.circular(23), child: ClipRRect(
      borderRadius: BorderRadius.circular(23),
      child: Stack(fit: StackFit.expand, children: [
        Image.asset('assets/images/$picture', fit: BoxFit.cover),
        DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [tint.withAlpha(90), const Color(0xE6000A20)]))),
        Padding(padding: const EdgeInsets.all(15), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(Icons.north_east_rounded, color: tint), const Spacer(),
            Text('$count$suffix', style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.w900)),
            Text(label, style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600)), ])), ])));
  Widget stats(int done, double progress) => Center(child: Column(
    mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('Your Progress 🌈', style: TextStyle(
        fontSize: 29, fontWeight: FontWeight.bold)), const SizedBox(height: 28),
      SizedBox(width: 185, height: 185, child: Stack( fit: StackFit.expand, children: [
          CircularProgressIndicator(value: progress, strokeWidth: 16,
            backgroundColor: const Color(0xFF303358), color: const Color(0xFF48EDC1)),
          Center(child: Text('${(progress * 100).round()}%',
            style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900))), ])),
      const SizedBox(height: 24), Text('$done completed • ${tasks.length - done} pending',
        style: const TextStyle(color: Colors.white70)), ]));
}
