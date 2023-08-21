import 'package:flutter/material.dart';
import 'package:organizare_timp/model/group_activity.dart';
import 'package:organizare_timp/services/group_activity_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/activity_datasource.dart';
import '../activity/activity_edit_page.dart';

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
  @override
  void initState() {
    getAct();
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

  List<GroupActivity> activities = [];

  GroupActivityService activityService = GroupActivityService();

  void getAct() async {
    activities = await activityService.getActivitiesList(widget.groupId);
  }

  List<Appointment> getAppointments() {
    getAct();
    List<Appointment> meetings = <Appointment>[];

    for (var element in activities) {
      meetings.add(Appointment(
        startTime: element.startTime,
        endTime: element.endTime,
        subject: element.subject,
        color: setActivityColor(element.priority),
      ));
    }

    return meetings;
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
                    builder: (context) => ActivityEditPage(),
                  )))
        ],
      ),
      body: SafeArea(
          child: Center(
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            buildAct(),
            SfCalendar(
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
              viewHeaderStyle:
                  ViewHeaderStyle(backgroundColor: _viewHeaderColor),
              backgroundColor: _calendarColor,
              controller: _controller,
              initialDisplayDate: DateTime.now(),
              selectionDecoration:
                  BoxDecoration(color: Colors.pinkAccent.withOpacity(0.4)),
              // onTap: (details) {

              //   final appointment = details.appointments!.first;

              //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivityViewingPage(activity: activity, objId: activity.id,),)
              //   );
              // },
              onTap: calendarTapped,
              monthViewSettings: const MonthViewSettings(
                  navigationDirection: MonthNavigationDirection.vertical),
            ),
          ])))),
    );
  }

  Widget buildAct() {
    getAct();
    return Container();
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    }
  }
}
