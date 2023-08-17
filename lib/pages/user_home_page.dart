import 'package:firebase_auth/firebase_auth.dart';
import 'package:organizare_timp/pages/task_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

import '../model/activity_datasource.dart';
import '../provider/activity_provider.dart';

class UserHomePage extends StatefulWidget {
  UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int selectedIndex = 0;

  void signOutUser() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/initpage');
  }

  @override
  Widget build(BuildContext context) {
    final activities = Provider.of<ActivityProvider>(context).activities;
    return Scaffold(
      appBar: AppBar(
        actions: [
            IconButton(
            icon: const Icon(Icons.note_add_rounded),
            onPressed: () =>  Navigator.pushNamed(context, '/activityeditpage'),
            )
          ],
          
        ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                SfCalendar(
                  view: CalendarView.day,
                  firstDayOfWeek: 1,
                  dataSource: ActivityDataSource(activities),
                  onLongPress: (details) {
                    final provider = Provider.of<ActivityProvider>(context, listen: false);

                    provider.setDate(details.date!);

                    showModalBottomSheet(
                      context: context, 
                      builder: (context) => TasksWidget() );
                  },
                ),
              ]
            )
          )
        )
      ),
      
    );
  }

}
