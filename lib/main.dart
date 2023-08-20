import 'package:flutter/material.dart';
import 'package:organizare_timp/pages/root_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:organizare_timp/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RootPage(),
      ));
}
