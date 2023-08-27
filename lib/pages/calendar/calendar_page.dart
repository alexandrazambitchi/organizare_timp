import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/services/activity_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/activity.dart';
import '../../model/activity_datasource.dart';
import '../activity/activity_edit_page.dart';
import '../activity/activity_view_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Activity> activities = [];

  ActivityService activityService = ActivityService();

  @override
  void initState() {
    super.initState();
  }

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

  final CalendarController _controller = CalendarController();

  final Color _viewHeaderColor = const Color(0xff03aa4f6);
  final Color _calendarColor = const Color(0xff0bae5ff);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.note_add_rounded),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ActivityEditPage(),
                  )))
        ],
      ),
      body: userActList(),
      // SafeArea(
      // child: Center(
      //     child: SingleChildScrollView(
      //         child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [

      // ])))
    );
  }

  Widget userActList() {
    return StreamBuilder(
        stream: activityService.getActivities(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading...');
          }
          activities =
              snapshot.data!.docs.map((doc) => activityItem(doc)).toList();
          getAppointments();
          return SfCalendar(
            view: CalendarView.month,
            firstDayOfWeek: 1,
            dataSource: ActivityDataSource(getAppointments()),
            allowedViews: const [
              CalendarView.day,
              CalendarView.week,
              CalendarView.workWeek,
              CalendarView.month,
              CalendarView.timelineDay,
              CalendarView.timelineWeek,
              CalendarView.timelineWorkWeek
            ],
            viewHeaderStyle: ViewHeaderStyle(backgroundColor: _viewHeaderColor),
            backgroundColor: _calendarColor,
            controller: _controller,
            initialDisplayDate: DateTime.now(),
            selectionDecoration:
                BoxDecoration(color: Colors.pinkAccent.withOpacity(0.4)),
            onLongPress: (details) {
              if (details.appointments == null) return;

              final appointment = details.appointments!.first;

              showDetails(appointment);
            },
            onTap: calendarTapped,
            monthViewSettings: const MonthViewSettings(
                navigationDirection: MonthNavigationDirection.vertical),
          );
        });
  }

  Activity activityItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    return Activity(
        id: data['id'],
        user: auth.currentUser!.uid,
        subject: data['activity_title'],
        notes: data['description'],
        startTime: data['startTime'].toDate(),
        endTime: data['endTime'].toDate(),
        category: data['category'],
        priority: data['priority'],
        location: data['location'],
        recurrenceRule: data['recurency'],
        isAllDay: data['isAllDay']);
  }

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    for (var element in activities) {
      meetings.add(Appointment(
        id: element.id,
        startTime: element.startTime,
        endTime: element.endTime,
        subject: element.subject,
        recurrenceRule: element.recurrenceRule,
        location: element.location,
        notes: element.notes,
        isAllDay: element.isAllDay,
        color: setActivityColor(element.category, element.priority),
      ));
    }

    return meetings;
  }

  void showDetails(Appointment appointment) async {
    final activity = Activity(
        user: auth.currentUser!.uid,
        id: appointment.id,
        subject: appointment.subject,
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        notes: appointment.notes,
        location: appointment.location,
        recurrenceRule: appointment.recurrenceRule,
        isAllDay: appointment.isAllDay,
        activityColor: appointment.color);

    Activity localAct =
        await activityService.getActivityfromDB(activity.id.toString());
    activity.category = localAct.category;
    activity.priority = localAct.priority;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ActivityViewingPage(
        activity: activity,
        objId: activity.id.toString(),
      ),
    ));
    // return ActivityViewingPage(activity: activity, objId: activity.id.toString());
  }

  void appointmentToActivity(
      String activityId, Appointment appointment, Activity activity) async {
    Activity localAct = await activityService.getActivityfromDB(activityId);
    activity.category = localAct.category;
    activity.priority = localAct.priority;
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    } else if (_controller.view == CalendarView.day) {
      _controller.view = CalendarView.month;
    }
  }
}
