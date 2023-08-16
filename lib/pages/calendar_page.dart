import 'package:flutter/material.dart';
import 'package:organizare_timp/provider/activity_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../model/activity_datasource.dart';
import 'task_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  

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
                  view: CalendarView.month,
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