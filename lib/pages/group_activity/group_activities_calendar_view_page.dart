import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/model/group_activity.dart';
import 'package:organizare_timp/pages/group_activity/group_activity_edit_page.dart';
import 'package:organizare_timp/pages/group_activity/group_activity_view_page.dart';
import 'package:organizare_timp/services/group_activity_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/activity_datasource.dart';

class GroupActivityCalendarPage extends StatefulWidget {
  final String groupId;
  const GroupActivityCalendarPage({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  State<GroupActivityCalendarPage> createState() =>
      _GroupActivityCalendarPageState();
}

class _GroupActivityCalendarPageState extends State<GroupActivityCalendarPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<GroupActivity> activities = [];

  GroupActivityService activityService = GroupActivityService();

  @override
  void initState() {
    super.initState();
  }

  Color setActivityColor(String? priority) {
    Color activityColor = Colors.blue;
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

    return activityColor;
  }

  final CalendarController _controller = CalendarController();

  final Color _viewHeaderColor = const Color(0xFF03aa4f6);
  final Color _calendarColor = const Color(0xFF0bae5ff);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const Icon(Icons.note_add_rounded),
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupActivityEditPage(
                      groupId: widget.groupId,
                    ),
                  )))
        ],
      ),
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            groupActCalendar(),
          ])))),
    );
  }

  Widget groupActCalendar() {
    return StreamBuilder(
        stream: activityService.getActivities(widget.groupId),
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

  GroupActivity activityItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;

    return GroupActivity(
        groupId: widget.groupId,
        id: data['id'],
        subject: data['activity_title'],
        notes: data['description'],
        startTime: data['startTime'].toDate(),
        endTime: data['endTime'].toDate(),
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
          location: element.location,
          startTime: element.startTime,
          endTime: element.endTime,
          subject: element.subject,
          color: setActivityColor(element.priority),
          isAllDay: element.isAllDay,
          recurrenceRule: element.recurrenceRule));
    }

    return meetings;
  }

  void showDetails(Appointment appointment) async {
    final activity = GroupActivity(
      id: appointment.id,
      groupId: widget.groupId,
      subject: appointment.subject,
      startTime: appointment.startTime,
      endTime: appointment.endTime,
      notes: appointment.notes,
      location: appointment.location,
      recurrenceRule: appointment.recurrenceRule,
      isAllDay: appointment.isAllDay,
    );

    GroupActivity localAct = await activityService.getActivityfromDB(
        widget.groupId, activity.id.toString());
    activity.priority = localAct.priority;

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GroupActivityViewingPage(
        groupActivity: activity,
        groupId: activity.groupId.toString(),
        objId: activity.id.toString(),
      ),
    ));
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
