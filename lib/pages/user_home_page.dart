import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:organizare_timp/model/activity.dart';
import 'package:organizare_timp/pages/activity/activity_edit_page.dart';
import 'package:flutter/material.dart';

import '../services/activity_service.dart';
import 'activity/activity_view_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final ActivityService activityService = ActivityService();

  Activity getActivityItem(Map<String, dynamic> activities) {
    return Activity(
        user: activities["user"],
        title: activities["activity_title"],
        description: activities["description"],
        startTime: activities["startTime"].toDate(),
        endTime: activities["endTime"].toDate(),
        category: activities["category"],
        priority: activities["priority"],
        location: activities["location"],
        recurency: activities["recurency"],
        isAllDay: activities["isAllDay"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.note_add_rounded),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ActivityEditPage(),
                  ))),
        ],
      ),
      body: userActivityList(),
    );
  }

  Widget userActivityList() {
    return StreamBuilder(
        stream: activityService.getActivities(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading...');
          }
          return ListView(
            children: snapshot.data!.docs
                .map((doc) => activityItem(doc, doc.id))
                .toList(),
          );
        });
  }

  Widget activityItem(DocumentSnapshot documentSnapshot, String objId) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    if (auth.currentUser!.uid == data['user']) {
      if (data.isNotEmpty) {
        return ListTile(
            title: Text(data['activity_title']),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ActivityViewingPage(
                    activity: getActivityItem(data),
                    objId: objId,
                  ),
                )));
      } else {
        return const Text("Nu exista activitati");
      }
    } else {
      return Container();
    }
  }
}
