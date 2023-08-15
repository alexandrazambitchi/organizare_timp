import 'package:flutter/material.dart';
import 'package:organizare_timp/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:organizare_timp/pages/home_page.dart';
import 'package:organizare_timp/pages/init_page.dart';
import 'package:organizare_timp/pages/login_page.dart';
import 'package:organizare_timp/pages/register_page.dart';
import 'firebase_options.dart';
import 'pages/new_activity.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      routes: {
        '/initpage' : (context) => const InitPage(),
        '/login': (context) => LoginPage(), 
        '/register': (context) => RegisterPage(),
        '/homepage': (context) => HomePage(),
        '/newactivitypage': (context) => NewActivityPage(),

      },
    );
  }
}
