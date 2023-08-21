import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/pages/group/group_list_page.dart';
import 'package:organizare_timp/pages/group/group_page.dart';
import 'package:organizare_timp/services/group_service.dart';

import '../../components/button.dart';
import '../../model/group.dart';

class GroupEditPage extends StatefulWidget {
  final Group? group;
  final String? objId;

  const GroupEditPage({Key? key, this.group, this.objId}) : super(key: key);

  @override
  State<GroupEditPage> createState() => _GroupEditPageState();
}

class _GroupEditPageState extends State<GroupEditPage> {
  final groupNameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.group != null) {
      final group = widget.group!;

      groupNameController.text = group.name;
      descriptionController.text = group.description!;
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void saveGroup() async {
    final isEditing = widget.group != null;

    final newGroup = Group(
        name: groupNameController.text,
        leader: firebaseAuth.currentUser!.uid,
        description: descriptionController.text,
        members: [firebaseAuth.currentUser!.uid]);

    final GroupService groupService = GroupService();

    if (isEditing) {
      final objId = widget.objId!;
      List<String>? oldMembers = widget.group?.members;
      newGroup.members = oldMembers!;
      groupService.editGroup(objId, newGroup);
    } else {
      groupService.addGroup(newGroup);
    }

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GroupListPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: CloseButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupPage(),
                  ))),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 25,
            ),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
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
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.group),
                        hintText: "Descrierea grupului"),
                  ),
                  Button(
                    text: "Salveaza grup",
                    onTap: saveGroup,
                  )
                ]))
          ],
        ));
  }
}
