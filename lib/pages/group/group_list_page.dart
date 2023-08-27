import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:organizare_timp/pages/group/group_view_page.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/pages/home_page.dart';
import 'package:organizare_timp/services/group_service.dart';

import '../../model/group.dart';
import 'group_edit_page.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final GroupService groupService = GroupService();

  Group getGroupItem(Map<String, dynamic> groups) {
    return Group(
        id: groups["id"],
        name: groups["name"],
        leader: groups["leader"],
        description: groups["description"],
        members: List<String>.from(groups["members"]));
  }

  int selectedIndex = 0;

  var collection = FirebaseFirestore.instance.collection("groups");
  late List<Map<String, dynamic>> groups;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista grupurilor mele'),
        leading: BackButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const HomePage(),
          )),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const GroupEditPage(),
            )),
          )
        ],
      ),
      body: userGroupsList(),
    );
  }

  Widget userGroupsList() {
    return StreamBuilder(
        stream: groupService.getGroups(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading...');
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) => groupItem(doc)).toList(),
          );
        });
  }

  Widget groupItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    return ListTile(
        leading: const Icon(Icons.group),
        title: Text(data['name'], style: const TextStyle(fontSize: 20)),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => GroupViewingPage(
                group: getGroupItem(data),
                objId: data['id'],
              ),
            )));
  }
}
