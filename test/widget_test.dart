import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:taskify_premium/main.dart';
import 'package:taskify_premium/models/todo.dart';
import 'package:taskify_premium/screens/home_screen.dart';
import 'package:taskify_premium/screens/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('Old saved tasks migrate safely to new status model', () {
    final oldPending = Todo.fromJson({'id': '1', 'title': 'Study', 'done': false});
    final oldDone = Todo.fromJson({'id': '2', 'title': 'Work', 'done': true});
    expect(oldPending.status, 'Pending');
    expect(oldDone.status, 'Approved');
    expect(oldPending.title, 'Study');
  });

  test('New tasks keep ID, date, name and status when saved', () {
    const task = Todo(id: '42', name: 'Rathan', title: 'Homework',
        description: 'Learn Flutter widgets', dueDate: '2026-10-16', status: 'Pending');
    final restored = Todo.fromJson(jsonDecode(jsonEncode(task.toJson())));
    expect(restored.id, task.id);
    expect(restored.name, task.name);
    expect(restored.description, task.description);
    expect(restored.dueDate, task.dueDate);
    expect(restored.status, task.status);
  });

  testWidgets('Splash shows dashboard after five seconds', (tester) async {
    await tester.pumpWidget(const TaskifyApp());
    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
