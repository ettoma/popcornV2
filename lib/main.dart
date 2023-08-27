import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:popcorn_v2/global/watchlist_provider.dart';
import 'package:popcorn_v2/pages/login_page.dart';
import 'package:provider/provider.dart';

import 'firebase/firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WatchlistProvider()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Popcorn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(12, 19, 79, 1),
          background: const Color.fromRGBO(29, 38, 125, 1),
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
