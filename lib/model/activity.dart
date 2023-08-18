import 'package:flutter/material.dart';

class Activity{
  final String user;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String category;
  final String priority;
  final String location;
  final String recurency;
  final Color activityColor;
  final bool isAllDay;

  const Activity({
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

}