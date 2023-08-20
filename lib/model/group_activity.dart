import 'package:syncfusion_flutter_calendar/calendar.dart';

class GroupActivity extends Appointment{
  String? groupId;
  String? priority;

  GroupActivity({
    subject, 
    startTime,
    endTime,
    notes,
    location, 
    recurrenceRule,
    isAllDay,
    this.groupId,
    this.priority,
  }) : super(
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
      'groupId': groupId,
      'activity_title': subject,
      'description': notes,
      'startTime': startTime,
      'endTime': endTime,
      'priority': priority,
      'location': location,
      'recurency': recurrenceRule,
      'isAllDay': isAllDay, 
    };
  }

}