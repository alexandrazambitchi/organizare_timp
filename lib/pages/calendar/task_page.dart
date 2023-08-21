import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizare_timp/model/activity_datasource.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/activity.dart';
import '../../services/activity_service.dart';
import '../activity/activity_view_page.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  Color setActivityColor(String? category, String? priority) {
    Color activityColor = Colors.blue;
    switch (category) {
      case 'Serviciu':
        switch (priority) {
          case 'Important':
            activityColor = Colors.amber.shade600;
            break;
          case 'Mediu':
            activityColor = Colors.amber.shade300;
            break;
          case 'Scazut':
            activityColor = Colors.amber.shade100;
            break;
        }
        break;
      case 'Casa':
        switch (priority) {
          case 'Important':
            activityColor = Colors.teal.shade600;
            break;
          case 'Mediu':
            activityColor = Colors.teal.shade300;
            break;
          case 'Scazut':
            activityColor = Colors.teal.shade100;
            break;
        }
        break;
      case 'Personal':
        switch (priority) {
          case 'Important':
            activityColor = Colors.indigo.shade500;
            break;
          case 'Mediu':
            activityColor = Colors.indigo.shade300;
            break;
          case 'Scazut':
            activityColor = Colors.indigo.shade100;
            break;
        }
        break;
      case 'Timp liber':
        switch (priority) {
          case 'Important':
            activityColor = Colors.purple.shade600;
            break;
          case 'Mediu':
            activityColor = Colors.purple.shade300;
            break;
          case 'Scazut':
            activityColor = Colors.purple.shade100;
            break;
        }
        break;
    }

    return activityColor;
  }

  List<Activity> activities = [];

  ActivityService activityService = ActivityService();

  void getAct() async {
    activities = await activityService.getActivitiesList();
  }

  List<Appointment> getAppointments() {
    getAct();
    List<Appointment> meetings = <Appointment>[];

    for (var element in activities) {
      meetings.add(Appointment(
        startTime: element.startTime,
        endTime: element.endTime,
        subject: element.title,
        color: setActivityColor(element.category, element.priority),
      ));
    }

    return meetings;
  }

  List<Appointment> get meetings => meetings;

  @override
  Widget build(BuildContext context) {
    getAct();
    final selectedActivities = activityService.activitiesOfSelectedDate;

    if (selectedActivities.isEmpty) {
      return const Center(
        child: Text('Nu exista activitati',
            style: TextStyle(color: Colors.black, fontSize: 24)),
      );
    }

    return SfCalendar(
      view: CalendarView.timelineDay,
      dataSource: ActivityDataSource(meetings),
      initialDisplayDate: activityService.selectedDate,
      appointmentBuilder: appointmentBuiler,
      headerHeight: 0,
      headerDateFormat: DateFormat.DAY + DateFormat.ABBR_MONTH,
      todayHighlightColor: Colors.black,
      selectionDecoration:
          BoxDecoration(color: Colors.pinkAccent.withOpacity(0.4)),
      onTap: (details) {
        if (details.appointments == null) return;

        final activity = details.appointments!.first;

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ActivityViewingPage(
            activity: activity,
            objId: activity.id,
          ),
        ));
      },
    );
  }

  Widget appointmentBuiler(
      BuildContext context, CalendarAppointmentDetails details) {
    final activity = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
          color: activity.activityColor,
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Text(
          activity.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
