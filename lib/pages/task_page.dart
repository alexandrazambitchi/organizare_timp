import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organizare_timp/model/activity_datasource.dart';
import 'package:organizare_timp/provider/activity_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({super.key});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context);
    final selectedActivities = provider.activitiesOfSelectedDate;
    if(selectedActivities.isEmpty) {
      return const Center(
        child: Text(
          'Nu exista activitati',
          style: TextStyle(color: Colors.black, fontSize: 24)
        ),
      );
    }

    return SfCalendar(
        view: CalendarView.timelineDay,
        dataSource: ActivityDataSource(provider.activities),
        initialDisplayDate: provider.selectedDate,
        appointmentBuilder: appointmentBuiler,
        headerHeight: 0,
        headerDateFormat: DateFormat.DAY+DateFormat.ABBR_MONTH,
        todayHighlightColor: Colors.black,
        selectionDecoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.4)),
        // onTap: (details) {
        //   if(details.appointments == null) return;

        //   final activity = details.appointments!.first;

        //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ActivityViewingPage(activity: activity),)
        //   );
        // },
      );
  }

  Widget appointmentBuiler(
    BuildContext context,
    CalendarAppointmentDetails details
  ) {
    final activity = details.appointments.first;

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: activity.activityColor,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Center(
        child: Text(
          activity.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}