import 'package:organizare_timp/model/activity.dart';

class Group {
  String name;
  String leader;
  String? description;

  Group({
    required this.name,
    required this.leader, 
    this.description,
  });

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'description': description,
      'leader': leader,
    };
  }

}