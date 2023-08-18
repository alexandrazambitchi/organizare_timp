import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/button.dart';
import '../../model/activity.dart';

class NewGroupPage extends StatefulWidget {
  const NewGroupPage({super.key});

  @override
  State<NewGroupPage> createState() => _NewGroupPageState();
}

class _NewGroupPageState extends State<NewGroupPage> {
  final groupNameController = TextEditingController();
  final descriptionController = TextEditingController();

  void saveGroup() async {
    List<String>? members = [];
    List<Activity> activities = [];
    List<String> groups = [];

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      members.add(firebaseAuth.currentUser!.uid);
      DocumentReference docReference = await firestore.collection("groups").add({
        'name': groupNameController.text,
        'leader': firebaseAuth.currentUser!.uid,
        'description': descriptionController.text,
        'members': members,
        'activities': activities
      });
      
      groups.add(docReference.id);
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
                      controller: groupNameController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.group),
                          hintText: "Numele grupului"),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.group),
                          hintText: "Descrierea grupului"),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Button(
                      text: "Salveaza grup",
                      onTap: saveGroup,
                    )
                  ]
                ))
          ],
        ));
  }
}
