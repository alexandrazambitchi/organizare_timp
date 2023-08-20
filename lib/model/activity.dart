import 'package:flutter/material.dart';

class Activity{
  String user;
  String title;
  String? description;
  DateTime startTime;
  DateTime endTime;
  String? category;
  String? priority;
  String? location;
  String? recurency;
  Color activityColor;
  bool isAllDay;

  Activity({
    required this.user,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.category,
    required this.priority,
    required this.location,
    required this.recurency,
    this.activityColor = Colors.blue,
    this.isAllDay = false
  });

  Map<String, dynamic> toMap(){
    return {
      'user': user,
      'activity_title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'category': category,
      'priority': priority,
      'location': location,
      'recurency': recurency,
      'isAllDay': isAllDay, 
    };
  }

}