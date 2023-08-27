import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/model/user_model.dart';
import 'package:organizare_timp/pages/group/group_list_page.dart';
import 'package:organizare_timp/services/auth_service.dart';
import 'package:organizare_timp/services/group_service.dart';

import '../../components/button.dart';
import '../../components/multiselect.dart';
import '../../model/group.dart';

class GroupEditPage extends StatefulWidget {
  final Group? group;
  final String? objId;

  const GroupEditPage({Key? key, this.group, this.objId}) : super(key: key);

  @override
  State<GroupEditPage> createState() => _GroupEditPageState();
}

class _GroupEditPageState extends State<GroupEditPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final groupNameController = TextEditingController();
  final descriptionController = TextEditingController();
  List<UserModel> selectedUsers = [];

  AuthService authService = AuthService();

  void showMultiSelect() async {
    final List<UserModel> possibleUsers = await authService.getOtherUserList();

    // ignore: use_build_context_synchronously
    final List<UserModel>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelect(
            users: possibleUsers,
            alreadySelected: selectedUsers,
          );
        });

    if (results != null) {
      setState(() {
        selectedUsers = results;
      });
    }
  }

  void getCurrentMembers() async {
    List<UserModel> otherUsers = await authService.getOtherUserList();
    List<String> tempMembersList = widget.group!.members;
    for (var user in otherUsers) {
      if (tempMembersList.contains(user.uid)) {
        selectedUsers.add(user);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.group != null) {
      final group = widget.group!;

      groupNameController.text = group.name;
      descriptionController.text = group.description!;
      getCurrentMembers();
      debugPrint(selectedUsers.length.toString());
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

    if (selectedUsers.isNotEmpty) {
      newGroup.members.addAll(selectedUsers.map((e) => e.uid).toList());
    }

    if (isEditing) {
      final objId = widget.objId!;
      if (selectedUsers.isEmpty) {
        List<String>? oldMembers = widget.group?.members;
        newGroup.members = oldMembers!;
      }
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
          leading: const CloseButton(),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 25,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                      ElevatedButton(
                          onPressed: showMultiSelect,
                          child: const Text('Adauga utilizatori')),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text('Utilizatori selectati: '),
                      showAddedUsers(),
                      const SizedBox(
                        width: 200,
                      ),
                    ])),
                Button(
                  text: "Salveaza grup",
                  onTap: saveGroup,
                )
              ],
            )
          ],
        ));
  }

  Widget showAddedUsers() {
    // getCurrentMembers();

    if (selectedUsers.isEmpty) {
      return const Text("Nu a fost selectat niciun utilizator");
    }
    getCurrentMembers();
    return Wrap(
      children: selectedUsers.map((e) => Chip(label: Text(e.name))).toList(),
    );
  }
}
