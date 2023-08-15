import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

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
                  view: CalendarView.day,
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