import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/pages/group/group_view_page.dart';

import '../../components/button.dart';
import '../../model/activity.dart';
import '../../model/group.dart';

class GroupEditPage extends StatefulWidget {
  final Group? group;

  const GroupEditPage({
    Key? key,
    this.group,
  }) : super(key: key);

  @override
  State<GroupEditPage> createState() => _GroupEditPageState();
}

class _GroupEditPageState extends State<GroupEditPage> {
  final groupNameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.group != null){
      final group = widget.group!;

      groupNameController.text = group.name;
      descriptionController.text = group.description;
    }
  }

  void saveGroup() async {
    List<String>? members = [];
    List<Activity> activities = [];
    List<String> groups = [];

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final isEditing = widget.group != null;

    try {
      members.add(firebaseAuth.currentUser!.uid);
      DocumentReference docReference = await firestore.collection("groups").add({
        'name': groupNameController.text,
        'leader': firebaseAuth.currentUser!.uid,
        'description': descriptionController.text,
        'members': members,
        'activities': activities
      });

      Group newGroup = Group(
        id: docReference.id, 
        name: groupNameController.text, 
        leader: firebaseAuth.currentUser!.uid, 
        description: descriptionController.text, 
        members: members, 
        activities: activities);
      
      
      groups.add(docReference.id);
      await firestore.collection("users").doc(firebaseAuth.currentUser!.uid).update({
        'groups' : FieldValue.arrayUnion(groups)
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => GroupViewingPage(group: newGroup)));
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
