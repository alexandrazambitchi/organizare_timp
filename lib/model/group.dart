import 'package:organizare_timp/model/activity.dart';

class Group {
  String id;
  String name;
  String leader;
  String description;
  List<String> members;
  List<Activity> activities;

  Group({
    required this.id,
    required this.name,
    required this.leader, 
    required this.description,
    required this.members,
    required this.activities
  });

  // Group.fromDocumentSnapshot({required DocumentSnapshot doc}) {
  //   id = doc.documentID;
  //   name = doc.data["name"];
  //   leader = doc.data["leader"];
  //   description = doc.data["description"];
  //   members = List<String>.from(doc.data["members"]);
  //   activities = List<Activity>.from(doc.data["activities"]);
  // }
}