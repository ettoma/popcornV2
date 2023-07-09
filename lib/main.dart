import 'package:flutter/material.dart';
import 'package:popcorn_v2/pages/page_switch.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Popcorn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(12, 19, 79, 1),
          background: const Color.fromRGBO(29, 38, 125, 1),
        ),
        useMaterial3: true,
      ),
      home: const PageSwitch(),
    );
  }
}
