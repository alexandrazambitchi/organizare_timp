import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ActivityDataSource extends CalendarDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ActivityDataSource(List<Appointment> source) {
    appointments = source;
  }
}
