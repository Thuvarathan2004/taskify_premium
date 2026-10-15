import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskify_premium/main.dart';
import 'package:taskify_premium/screens/home_screen.dart';
import 'package:taskify_premium/screens/splash_screen.dart';
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Splash moves to dashboard after 5 seconds', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const TaskifyApp());
    expect(find.byType(SplashScreen), findsOneWidget);
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
