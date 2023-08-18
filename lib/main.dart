import 'package:flutter/material.dart';
import 'package:organizare_timp/pages/group/group_edit_page.dart';
import 'package:organizare_timp/pages/root_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:organizare_timp/pages/home_page.dart';
import 'package:organizare_timp/pages/first_page.dart';
import 'package:organizare_timp/provider/activity_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/activity/activity_edit_page.dart';
import 'pages/authentification/login_page.dart';
import 'pages/authentification/register_page.dart';
import 'pages/group/group_join_page.dart';

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
  Widget build(BuildContext context) => ChangeNotifierProvider(create: (context) => ActivityProvider(),
  child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPage(),
      routes: {
        '/initpage' : (context) => const FirstPage(),
        '/login': (context) => LoginPage(), 
        '/register': (context) => RegisterPage(),
        '/homepage': (context) => HomePage(),
        '/activityeditpage': (context) => ActivityEditPage(),
        '/joingroup' : (context) => JoinGroupPage(),
        '/creategroup' : (context) => GroupEditPage(),

      },
    )
    );
     
}
