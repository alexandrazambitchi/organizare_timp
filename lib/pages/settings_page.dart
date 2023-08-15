import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void signOutUser() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/initpage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signOutUser, 
            icon: Icon(Icons.logout_sharp)
          ),
            // IconButton(
            // icon: Icon(Icons.note_add_rounded),
            // onPressed: () =>  Navigator.pushNamed(context, '/newactivitypage'),
            // )
          ],
          
        ),
      body: Center(
        child: Text('settings'),
      ),
    );
  }
}