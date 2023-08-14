import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final user = FirebaseAuth.instance.currentUser!;
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
      body: build_userlist()
    );
  }

  Widget build_userlist() {
    return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasError) {
          return const Text('error');
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading...');
        }
        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => userlistitem(doc)).toList(),
        );
      }
    );
  }
 
  Widget userlistitem(DocumentSnapshot documentSnapshot){
    Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;

    if(_firebaseAuth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
      );
    }
    else {
      return Container();
    }

  }

}