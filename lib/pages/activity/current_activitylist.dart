import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/model/activity.dart';
import 'package:organizare_timp/model/group.dart';

class CurrentActivityList extends ChangeNotifier {

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Activity?>> getActivityList(String userId) async {
    List<Activity> activityList = [];
      try{
        DocumentSnapshot documentSnapshot = await firebaseFirestore.collection("users").doc(userId).get();
        Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
        activityList = List<Activity>.from(data['activities']);
        // data.forEach((key, value) { })
        // Activity retVal = Activity(
        //   title: title, 
        //   description: description, 
        //   startTime: startTime, 
        //   endTime: endTime, 
        //   category: category, 
        //   priority: priority, 
        //   recurency: recurency)

        return activityList;
      } catch(e){
        print(e);
      }
      return [];
  }

  void updateStateFromDatabase(String userId) async {
    try{
      //get group info
      List<Activity> currentUserActivities = await getActivityList(userId) as List<Activity>;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}