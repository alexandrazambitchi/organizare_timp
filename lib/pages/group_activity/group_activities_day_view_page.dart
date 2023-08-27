import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:organizare_timp/model/group_activity.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/pages/group/group_list_page.dart';
import 'package:organizare_timp/pages/group_activity/group_activity_view_page.dart';
import 'package:organizare_timp/services/group_activity_service.dart';

class GroupActivityDayViewPage extends StatefulWidget {
  final String groupId;

  const GroupActivityDayViewPage({
    Key? key,
    required this.groupId,
  }) : super(key: key);

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
      groupId: activities['groupId'],
      subject: activities['activity_title'],
      startTime: activities['startTime'].toDate(),
      endTime: activities['endTime'].toDate(),
      location: activities['location'],
      recurrenceRule: activities['recurency'],
      isAllDay: activities['isAllDay'],
      notes: activities['description'],
      priority: activities['priority'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Azi, ${DateFormat('d/M/y').format(DateTime.now())}'),
        backgroundColor: const Color.fromARGB(255, 102, 178, 255),
        leading: CloseButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => GroupListPage(),
          )),
        ),
        // actions: [
        //   IconButton(
        //       icon: const Icon(Icons.note_add_rounded),
        //       onPressed: () => Navigator.of(context).push(MaterialPageRoute(
        //             builder: (context) => GroupActivityEditPage(
        //               groupId: widget.groupId,
        //             ),
        //           ))),
        // ],
      ),
      body: groupActivityList(),
    );
  }

  Widget groupActivityList() {
    return StreamBuilder(
        stream: groupActivityService.getActivities(widget.groupId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text(
              'error',
              style: TextStyle(fontSize: 24),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(
              'loading...',
              style: TextStyle(fontSize: 24),
            );
          }
          List<Widget> itemsWidget = snapshot.data!.docs
              .map((doc) => activityItem(doc, doc.id))
              .toList();
          List<Widget> itemsWidgetList = [];
          for (var elem in itemsWidget) {
            if (elem.runtimeType == ListTile) {
              itemsWidgetList.add(elem);
            }
          }

          if (itemsWidgetList.isEmpty) {
            return const Text(
              'Nu exsita activitati azi',
              style: TextStyle(fontSize: 24),
            );
          }

          return ListView(
            children: itemsWidget,
          );
        });
  }

  Widget activityItem(DocumentSnapshot documentSnapshot, String objId) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    if (widget.groupId == data['groupId']) {
      final dateStartFormated =
          DateFormat('d/M/y').format(data['startTime'].toDate());
      final dateEndFormated =
          DateFormat('d/M/y HH:mm').format(data['endTime'].toDate());
      final dateEndFormat =
          DateFormat('d/M/y').format(data['endTime'].toDate());
      final now = DateFormat('d/M/y').format(DateTime.now());
      final priority = data['priority'];
      final Color activityIconColor;

      switch (priority) {
        case 'Mare':
          activityIconColor = Colors.redAccent;
          break;
        case 'Mediu':
          activityIconColor = Colors.orangeAccent;
          break;
        case 'Mica':
          activityIconColor = Colors.yellowAccent;
          break;
        default:
          activityIconColor = Colors.grey;
          break;
      }
      if ((dateStartFormated == now) || (dateEndFormat == now)) {
        return ListTile(
            iconColor: activityIconColor,
            title: Text(
              data['activity_title'],
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              '$dateEndFormated  Prioritate: $priority',
              style: const TextStyle(fontSize: 16),
            ),
            leading: const Icon(Icons.group),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GroupActivityViewingPage(
                    groupActivity: getActivityItem(data),
                    objId: objId,
                    groupId: data['groupId'],
                  ),
                )));
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }
}
