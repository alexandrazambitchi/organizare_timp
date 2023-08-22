import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/group_activity.dart';

class GroupActivityService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addActivity(String groupId, GroupActivity groupActivity) async {
    GroupActivity newActivity = GroupActivity(
        groupId: groupId,
        subject: groupActivity.subject,
        startTime: groupActivity.startTime,
        endTime: groupActivity.endTime,
        notes: groupActivity.notes,
        location: groupActivity.location,
        recurrenceRule: groupActivity.recurrenceRule,
        isAllDay: groupActivity.isAllDay,
        priority: groupActivity.priority);

    DocumentReference docReference = await firestore
        .collection('group_activity')
        .doc(groupId)
        .collection('groupActivities')
        .add(newActivity.toMap());

    newActivity.id = docReference.id;

    await firestore
        .collection('group_activity')
        .doc(groupId)
        .collection('groupActivities')
        .doc(docReference.id)
        .set(newActivity.toMap());
  }

  Stream<QuerySnapshot> getActivities(String groupId) {
    return firestore
        .collection('group_activity')
        .doc(groupId)
        .collection('groupActivities')
        .orderBy('endTime', descending: false)
        .snapshots();
  }

  Future<void> deleteActivity(String groupId, String groupActivityId) async {
    await firestore
        .collection('group_activity')
        .doc(groupId)
        .collection('groupActivities')
        .doc(groupActivityId)
        .delete();
  }

  Future<void> editActivity(
      String groupId, String groupActivityId, GroupActivity newActivity) async {
    
    newActivity.id = groupActivityId;

    await firestore
        .collection('group_activity')
        .doc(groupId)
        .collection('groupActivities')
        .doc(groupActivityId)
        .set(newActivity.toMap());
  }

  Future<List<GroupActivity>> getActivitiesList(String currentGroupId) async {
    List<GroupActivity> actList = [];
    QuerySnapshot<Map<String, dynamic>> activities = await firestore
        .collection('group_activity')
        .doc(currentGroupId)
        .collection('groupActivities')
        .get();

    for (var element in activities.docs) {
      GroupActivity tempAct =
          await getActivityfromDB(currentGroupId, element.id);
      actList.add(tempAct);
    }
    return actList;
  }

  Future<GroupActivity> getActivityfromDB(
      String groupId, String activityId) async {
    DocumentSnapshot<Map<String, dynamic>> activityDb = await firestore
        .collection('group_activity')
        .doc(groupId)
        .collection('groupActivities')
        .doc(activityId)
        .get();

    GroupActivity act = GroupActivity(
        id: activityId,
        groupId: groupId,
        subject: activityDb['activity_title'],
        notes: activityDb['description'],
        startTime: activityDb['startTime'].toDate(),
        endTime: activityDb['endTime'].toDate(),
        priority: activityDb['priority'],
        location: activityDb['location'],
        recurrenceRule: activityDb['recurency'],
        isAllDay: activityDb['isAllDay']);
    return act;
  }
}
