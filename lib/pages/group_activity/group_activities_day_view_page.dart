import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:organizare_timp/model/group_activity.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/pages/group_activity/group_activity_edit_page.dart';
import 'package:organizare_timp/pages/group_activity/group_activity_view_page.dart';
import 'package:organizare_timp/services/group_activity_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class GroupActivityDayViewPage extends StatefulWidget {
  final String groupId;

  const GroupActivityDayViewPage(
      {Key? key, required this.groupId,})
      : super(key: key);

  @override
  State<GroupActivityDayViewPage> createState() =>
      _GroupActivityDayViewPageState();
}

class _GroupActivityDayViewPageState extends State<GroupActivityDayViewPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final GroupActivityService groupActivityService = GroupActivityService();

  GroupActivity getActivityItem(Map<String, dynamic> activities) {
    return GroupActivity(
        groupId: activities["groupId"],
        subject: activities["subject"],
        startTime: activities["startTime"].toDate(),
        endTime: activities["endTime"].toDate(),
        location: activities["location"],
        recurrenceRule: activities["recurency"],
        isAllDay: activities["isAllDay"],
        notes: activities["notes"],
        priority: activities["priority"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.note_add_rounded),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupActivityEditPage(groupId: widget.groupId,),
                  ))),
        ],
      ),
      body: groupActivityList(),
    );
  }

  Widget groupActivityList() {
    return StreamBuilder(
        stream: groupActivityService.getActivities(widget.groupId),
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

    if (widget.groupId == data['groupId']) {
      // final dateStartFormated = DateFormat('d/M/y').format(data['startTime']);
      // final dateEndFormated = DateFormat('d/M/y').format(data['endTime']);
      // final now = DateFormat('d/M/y').format(DateTime.now());
      // if ((dateStartFormated == now) || (dateEndFormated == now)) {
        return ListTile(
            title: Text(data['activity_title']),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GroupActivityViewingPage(
                    groupActivity: getActivityItem(data),
                    objId: objId,
                    groupId: data['groupId'],
                  ),
                )));
      // } else {
      //   return const Text("Nu exista activitati");
      // }
    } else {
      return Container();
    }
  }
}
