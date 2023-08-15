import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
            IconButton(
              icon: const Icon(Icons.note_add_rounded),
              onPressed: () =>  Navigator.pushNamed(context, '/newactivitypage'),
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
                  dataSource: MeetingDataSource(getAppointments()),
                ),
              ]
            )
          )
        )
      ),
      
    );
  }
}

List<Appointment> getAppointments() {
  List<Appointment> meetings = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);

  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Appointment(startTime: startTime, endTime: endTime, subject: 'Conference', color: Colors.blue));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource{
  MeetingDataSource(List<Appointment> source){
    appointments = source;
  }
}