import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // final user = FirebaseAuth.instance.currentUser!;

  void signOutUser() {
    FirebaseAuth.instance.signOut();
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