import 'package:flutter/material.dart';
import 'package:organizare_timp/pages/first_page.dart';
import 'package:organizare_timp/services/auth_service.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void signOutUser() {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const FirstPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: signOutUser, icon: const Icon(Icons.logout_sharp)),
        ],
      ),
      body: const Center(
        child: Text('settings'),
      ),
    );
  }
}
