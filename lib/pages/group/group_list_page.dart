import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:organizare_timp/pages/group/group_view_page.dart';
import 'package:flutter/material.dart';

import '../../model/group.dart';


class GroupListPage extends StatefulWidget {
  GroupListPage({super.key});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  int selectedIndex = 0;

  var collection = FirebaseFirestore.instance.collection("groups");
  late List<Map<String, dynamic>> groups;

  void getGroupList() async {
    List<Map<String, dynamic>> tempList = [];
    var data = await collection.get();
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    
    for (var element in data.docs) {
      List<String> membersList = List<String>.from(element.data()['members']);
      if (membersList.contains(currentUserId)){
        tempList.add(element.data());
      }
    }

    setState(() {
      groups = tempList;
    });
  }
  @override
  Widget build(BuildContext context) {
    
    getGroupList();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: SafeArea(
          child: Center(
              child: groups.isNotEmpty
                  ? ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(width: 2)),
                            leading: const CircleAvatar(
                              child: Icon(Icons.group),
                            ),
                            title: Row(
                              children: [
                                Text(groups[index]["name"] ?? "Lipsa")
                              ],
                            ),
                            subtitle: Text(
                                groups[index]["description"].toString() ??
                                    "Lipsa"),
                            // onTap: () =>
                            //     Navigator.of(context).push(MaterialPageRoute(
                            //   builder: (context) => GroupViewingPage(
                            //       group: groups[index]),
                            // )),
                          ),
                        );
                      })
                  : Text("Nu exista grupuri"))),
    );
  }
}
