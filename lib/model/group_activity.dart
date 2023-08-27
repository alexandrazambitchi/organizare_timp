import 'package:syncfusion_flutter_calendar/calendar.dart';

class GroupActivity extends Appointment {
  String? groupId;
  String? priority;

  GroupActivity({
    id,
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
          id: id,
          subject: subject,
          startTime: startTime,
          endTime: endTime,
          notes: notes,
          location: location,
          recurrenceRule: recurrenceRule,
          isAllDay: isAllDay,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
