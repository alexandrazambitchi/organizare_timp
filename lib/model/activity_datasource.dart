import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'activity.dart';

class ActivityDataSource extends CalendarDataSource {
  ActivityDataSource(List<Activity> appointments) {
    this.appointments = appointments;
  }

  Activity getActivity(int index) => appointments![index] as Activity;

  @override
  DateTime getStartTime(int index) => getActivity(index).startTime;

  @override
  DateTime getEndTime(int index) => getActivity(index).endTime;

  // @override
  // String getSubject(int index) => getActivity(index).subject;

  @override
  Color getColor(int index) => getActivity(index).activityColor;

  @override
  bool isAllDay(int index) => getActivity(index).isAllDay;

  // String getCategory(int index) => getActivity(index).category;


}