import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Activity extends Appointment{
  String user;
  String? category;
  String? priority;
  Color activityColor;

  Activity({
    id,
    subject, 
    startTime,
    endTime,
    notes,
    location, 
    recurrenceRule,
    isAllDay,
    required this.user,
    this.category,
    this.priority,
    this.activityColor = Colors.blue,
  }) : super(
    id: id,
    subject: subject,
    startTime: startTime,
    endTime: endTime,
    notes: notes,
    location: location,
    recurrenceRule: recurrenceRule,
    isAllDay: isAllDay,
  );

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'user': user,
      'activity_title': subject,
      'description': notes,
      'startTime': startTime,
      'endTime': endTime,
      'category': category,
      'priority': priority,
      'location': location,
      'recurency': recurrenceRule,
      'isAllDay': isAllDay, 
    };
  }

}