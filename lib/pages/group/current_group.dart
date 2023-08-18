import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:organizare_timp/model/activity.dart';
import 'package:organizare_timp/model/group.dart';

class CurrentGroup extends ChangeNotifier {

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<Group?> getGroupInfo(String groupId) async {
      try{
        DocumentSnapshot documentSnapshot = await firebaseFirestore.collection("groups").doc(groupId).get();
        Map<String, dynamic> data = documentSnapshot.data()! as Map<String, dynamic>;
        Group retVal = Group(
          id: groupId, 
          name: data['name'], 
          leader: data['leader'], 
          description: data['description'], 
          members: List<String>.from(data['members']), 
          activities: List<Activity>.from(data['activities'])
        );

        return retVal;
      } catch(e){
        print(e);
      }
      return null;
  }

  void updateStateFromDatabase(String groupId) async {
    try{
      //get group info
      Group currentGroup = await getGroupInfo(groupId) as Group;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}