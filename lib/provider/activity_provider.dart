import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/activity.dart';

class ActivityProvider extends ChangeNotifier{
  final List<Activity> activityList = [];

  List<Activity> get activities => activityList;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Activity> get activitiesOfSelectedDate => activityList;

  void getActivitiesFromDataBase(String userId) async {
    
    var collection = FirebaseFirestore.instance.collection("users");
  
    List<Activity> tempList = [];
    Map<String, dynamic> tempElem;
    var data = await collection.get();

    for (var element in data.docs) {
      tempElem = element.data();
      if(tempElem["user"] == userId){
        addActivity(
          Activity(
            user: userId,
            title: tempElem["activity_title"], 
            description: tempElem["description"], 
            startTime: tempElem["startTime"], 
            endTime: tempElem["endTime"], 
            category: tempElem["category"], 
            priority: tempElem["priority"], 
            recurency: tempElem["recurency"]));
      }
    }
  }

  void addActivity(Activity activity) {
    activityList.add(activity);

    notifyListeners();
  }

  void deleteActivity(Activity activity) {
    activityList.remove(activity);

    notifyListeners();
  }

  void editActivity(Activity newActivity, Activity oldActivity){
    final index = activityList.indexOf(oldActivity);

    activityList[index] = newActivity;

    notifyListeners();
  }
}