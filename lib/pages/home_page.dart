import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final user = FirebaseAuth.instance.currentUser!;
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
            icon: Icon(Icons.logout_sharp))
          ]
        ),
      body: Center(
        child: Text(
          "Logged in as ",
          style: TextStyle(fontSize: 20),
          )
          ),
    );
  }
}