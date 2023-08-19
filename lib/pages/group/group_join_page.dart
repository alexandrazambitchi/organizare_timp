import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/button.dart';
import '../../services/group_service.dart';

class JoinGroupPage extends StatefulWidget {

  final String? objId;

  const JoinGroupPage({
    Key? key,
    this.objId
  }) : super(key: key);

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final groupIdController = TextEditingController();


  void joinGroup() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final GroupService groupService = GroupService();



    // groupService.joinGroup(groupIdController.text, );
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
