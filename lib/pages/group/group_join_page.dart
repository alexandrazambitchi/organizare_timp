import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/button.dart';

class JoinGroupPage extends StatefulWidget {
  const JoinGroupPage({super.key});

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final groupIdController = TextEditingController();

  void joinGroup() async {
    List<String>? members = [];
    List<String> groups = [];

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      members.add(firebaseAuth.currentUser!.uid);
      await firestore.collection("groups").doc(groupIdController.text).update({
        'members' : FieldValue.arrayUnion(members)
      });
      
      groups.add(groupIdController.text);
      await firestore.collection("users").doc(firebaseAuth.currentUser!.uid).update({
        'groups' : FieldValue.arrayUnion(groups)
      });

       Navigator.of(context).pop();
    } catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 25,
            ),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: groupIdController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.group),
                          hintText: "Codul de acces pe grup"),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Button(
                      text: "Intra in grup",
                      onTap: joinGroup,
                    )
                  ]
                ))
          ],
        ));
  }
}
