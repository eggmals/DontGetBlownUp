import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const DontGetBlownUpApp());
}

class DontGetBlownUpApp extends StatelessWidget {
  const DontGetBlownUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Don't Get Blown Up",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MenuScreen(),
    );
  }
}