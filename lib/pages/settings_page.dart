import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/components/button.dart';
import 'package:organizare_timp/model/user_model.dart';
import 'package:organizare_timp/pages/first_page.dart';
import 'package:organizare_timp/services/auth_service.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  void signOutUser() {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const FirstPage()));
  }

  UserModel getUser(Map<String, dynamic> user) {
    return UserModel(
      uid: user['uid'],
      email: user['email'],
      name: user['name'],
    );
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
        body: Column(
          children: [
            showUserInfo(),
            Button(onTap: signOutUser, text: "Delogare"),
          ],
        ));
  }

  Widget showUserInfo() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading...');
          }
          return Column(
            children: snapshot.data!.docs
                .map<Widget>((doc) => userlistitem(doc))
                .toList(),
          );
        });
  }

  Widget userlistitem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    if (auth.currentUser!.uid == data['uid']) {
      UserModel user = getUser(data);
      return Column(
        children: [Text(user.name), Text(user.email)],
      );
    } else {
      return Container();
    }
  }
}
