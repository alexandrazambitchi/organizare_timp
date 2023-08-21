import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/activity.dart';

class ActivityService extends ChangeNotifier{

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  }

  Stream<QuerySnapshot> getActivities(String userId){
    return firestore.collection('user_activity').doc(userId).collection('activities').orderBy('endTime', descending: false).snapshots();
  }
  
  Future<void> deleteActivity(String activityId) async {
    final String currentUserId = auth.currentUser!.uid;

    await firestore.collection('user_activity').doc(currentUserId).collection('activities').doc(activityId).delete();
  }

  Future<void> editActivity(String activityId, Activity newActivity) async {
    final String currentUserId = auth.currentUser!.uid;

    await firestore.collection('user_activity').doc(currentUserId).collection('activities').doc(activityId).set(newActivity.toMap(), SetOptions(merge: true));
  }
}