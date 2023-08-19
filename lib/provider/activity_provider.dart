import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/activity.dart';

class ActivityProvider extends ChangeNotifier{

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // final List<Activity> activityList = [];

  // List<Activity> get activities => activityList;

  // DateTime _selectedDate = DateTime.now();

  // DateTime get selectedDate => _selectedDate;

  // void setDate(DateTime date) => _selectedDate = date;

  // List<Activity> get activitiesOfSelectedDate => activityList;

  // void getActivitiesFromDataBase(String userId) async {
    
  //   var collection = FirebaseFirestore.instance.collection("users");
  
  //   List<Activity> tempList = [];
  //   Map<String, dynamic> tempElem;
  //   var data = await collection.get();

  //   for (var element in data.docs) {
  //     tempElem = element.data();
  //     if(tempElem["user"] == userId){
  //       addActivity(
  //         Activity(
  //           user: userId,
  //           title: tempElem["activity_title"], 
  //           description: tempElem["description"], 
  //           startTime: tempElem["startTime"], 
  //           endTime: tempElem["endTime"], 
  //           category: tempElem["category"], 
  //           priority: tempElem["priority"], 
  //           location: tempElem["location"],
  //           recurency: tempElem["recurency"]));
  //     }
  //   }
  // }

  Future<void> addActivity(Activity activity) async {
    final String currentUserId = auth.currentUser!.uid;

    Activity newActivity = Activity(user: currentUserId, 
                                    title: activity.title, 
                                    description: activity.description, 
                                    startTime: activity.startTime, 
                                    endTime: activity.endTime, 
                                    category: activity.category, 
                                    priority: activity.priority, 
                                    location: activity.location, 
                                    recurency: activity.recurency,);

    await firestore.collection('user_activity').doc(currentUserId).collection('activities').add(newActivity.toMap());

    // notifyListeners();
  }

  Stream<QuerySnapshot> getActivities(String userId){
    return firestore.collection('user_activity').doc(userId).collection('activities').orderBy('endTime', descending: false).snapshots();
  }

  // void deleteActivity(Activity activity) {
  //   activityList.remove(activity);

  //   notifyListeners();
  // }

  // void editActivity(Activity newActivity, Activity oldActivity){
  //   final index = activityList.indexOf(oldActivity);

  //   activityList[index] = newActivity;

  //   notifyListeners();
  // }
}