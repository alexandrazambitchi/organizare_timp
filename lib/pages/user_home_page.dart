import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

import '../model/activity_datasource.dart';
import '../provider/activity_provider.dart';
import 'activity/activity_view_page.dart';
import 'calendar/task_page.dart';

class UserHomePage extends StatefulWidget {
  UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int selectedIndex = 0;

  var collection = FirebaseFirestore.instance.collection("users");
  late List<Map<String, dynamic>> activities;

  void getActivityList() async {
    List<Map<String, dynamic>> tempList = [];
    var data = await collection.get();

    data.docs.forEach((element) {
      if (element.data()["user"] != FirebaseAuth.instance.currentUser!.uid) {
        tempList.add(element.data());
      }
    });

    setState(() {
      activities = tempList;
    });
  }

  void signOutUser() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/initpage');
  }

  @override
  Widget build(BuildContext context) {
    final activities = Provider.of<ActivityProvider>(context).activities;
    getActivityList();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.note_add_rounded),
            onPressed: () => Navigator.pushNamed(context, '/activityeditpage'),
          ),
        ],
      ),
      body: SafeArea(
          child: Center(
              child: activities.isNotEmpty
                  ? ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(width: 2)),
                            leading: const CircleAvatar(
                              child: Icon(Icons.local_activity),
                            ),
                            tileColor: activities[index].activityColor,
                            title: Row(
                              children: [
                                Text(activities[index].title ?? "Lipsa")
                              ],
                            ),
                            subtitle: Text(
                                activities[index].endTime.toString() ??
                                    "Lipsa"),
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ActivityViewingPage(
                                  activity: activities[index]),
                            )),
                          ),
                        );
                      })
                  : Text("Nu exista activitati"))),
    );
  }
}
