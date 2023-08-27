import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
        subject: activities["activity_title"],
        notes: activities["description"],
        startTime: activities["startTime"].toDate(),
        endTime: activities["endTime"].toDate(),
        category: activities["category"],
        priority: activities["priority"],
        location: activities["location"],
        recurrenceRule: activities["recurency"],
        isAllDay: activities["isAllDay"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(75, 102, 178, 255),
        appBar: AppBar(
          title: Text('Azi, ${DateFormat('d/M/y').format(DateTime.now())}'),
          backgroundColor: const Color.fromARGB(255, 102, 178, 255),
          actions: [
            IconButton(
                icon: const Icon(Icons.note_add_rounded),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ActivityEditPage(),
                    ))),
          ],
        ),
        body: userActivityList());
  }

  Widget userActivityList() {
    return StreamBuilder(
        stream: activityService.getActivities(auth.currentUser!.uid),
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

    if (auth.currentUser!.uid == data['user']) {
      final dateEndFormated =
          DateFormat('d/M/y HH:mm').format(data['endTime'].toDate());
      final dateEndFormat =
          DateFormat('d/M/y').format(data['endTime'].toDate());
      final now = DateFormat('d/M/y').format(DateTime.now());
      final category = data['category'];
      final priority = data['priority'];
      final Icon activityIcon;
      final Color activityIconColor;

      switch (category) {
        case 'Serviciu':
          activityIcon = const Icon(Icons.work);
          break;
        case 'Casa':
          activityIcon = const Icon(Icons.home);
          break;
        case 'Personal':
          activityIcon = const Icon(Icons.person);
          break;
        case 'Timp liber':
          activityIcon = const Icon(Icons.more_time);
          break;
        default:
          activityIcon = const Icon(Icons.category);
          break;
      }

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
          activityIconColor = Colors.white;
          break;
      }

      if (dateEndFormat == now) {
        return ListTile(
            iconColor: activityIconColor,
            title: Text(
              data['activity_title'],
              style: const TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              '$dateEndFormated  Categorie: $category Prioritate: $priority',
              style: const TextStyle(fontSize: 16),
            ),
            isThreeLine: true,
            leading: activityIcon,
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ActivityViewingPage(
                    activity: getActivityItem(data),
                    objId: objId,
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
