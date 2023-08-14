import 'package:flutter/material.dart';
import 'package:organizare_timp/pages/login_page.dart';
import 'package:organizare_timp/pages/register_page.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return LoginPage(
      onTap: togglePages,
    );
    }
    else {
    return RegisterPage(
      onTap: togglePages,
    );
  }
    
  }
}
