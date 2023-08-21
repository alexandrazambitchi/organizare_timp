import 'package:flutter/material.dart';
import 'package:organizare_timp/services/activity_service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../model/activity.dart';
import '../../model/activity_datasource.dart';
import '../activity/activity_edit_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    getAct();
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


// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }
