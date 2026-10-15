import 'package:flutter/material.dart';
import 'home_screen.dart';
class SplashScreen extends StatefulWidget { const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> { bool show = false;
  @override
  void initState() { super.initState();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) { setState(() => show = true); }
    });
    Future.delayed(const Duration(seconds: 5), () { if (mounted) {
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    });
  }
  @override
  Widget build(BuildContext context) => Scaffold(body: Container(
    decoration: const BoxDecoration(image: DecorationImage(
      image: AssetImage('assets/images/all.jpg'), fit: BoxFit.cover)),
    child: Container(decoration: const BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Color(0x88081939), Color(0xEE100C39)])),
      child: SafeArea(child: Column(children: [ const Spacer(),
        AnimatedScale(scale: show ? 1 : .55, duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutBack, child: const Icon(Icons.auto_awesome_rounded,
            size: 92, color: Color(0xFFFFC0ED))), AnimatedOpacity(opacity: show ? 1 : 0,
          duration: const Duration(milliseconds: 1200), child: const Column(children: [
            Text('Taskify ✨', style: TextStyle(fontSize: 44,
              fontWeight: FontWeight.w900)), Text('Dream • Plan • Achieve',
              style: TextStyle(color: Colors.white70)), ])),
        const Spacer(), const Text('Preparing your space…'), const SizedBox(height: 15),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 55),
          child: TweenAnimationBuilder<double>(tween: Tween(begin: 0, end: 1),
            duration: const Duration(seconds: 5), builder: (_, value, __) =>
              LinearProgressIndicator(value: value, minHeight: 7,
                color: const Color(0xFFFF77B7)))), const SizedBox(height: 36), ]))), ));
}
