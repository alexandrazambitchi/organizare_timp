import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/group.dart';

class GroupService extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addGroup(Group group) async {
    final String currentUserId = auth.currentUser!.uid;

    Group newGroup = Group(
      name: group.name,
      leader: group.leader,
      description: group.description,
      members: List<String>.from(group.members),
    );

    DocumentReference docReference =
        await firestore.collection("groups").add(newGroup.toMap());

    newGroup.id = docReference.id;

    await firestore
        .collection("groups")
        .doc(docReference.id)
        .set(newGroup.toMap(), SetOptions(merge: true));

    await firestore
        .collection('user_group')
        .doc(currentUserId)
        .collection('groups')
        .doc(docReference.id)
        .set(newGroup.toMap(), SetOptions(merge: true));

    if (newGroup.members.length > 1) {
      for (var member in newGroup.members) {
        await firestore
            .collection('user_group')
            .doc(member)
            .collection('groups')
            .doc(docReference.id)
            .set(newGroup.toMap());
      }
    }
  }

  Stream<QuerySnapshot> getGroups(String userId) {
    return firestore
        .collection('user_group')
        .doc(userId)
        .collection('groups')
        .snapshots();
  }

  Future<void> deleteGroup(String groupId) async {
    Group getGroup = await findGroup(groupId);

    await firestore.collection('groups').doc(groupId).delete();

    if (getGroup.members.isNotEmpty) {
      for (var member in getGroup.members) {
        await firestore
            .collection('user_group')
            .doc(member)
            .collection('groups')
            .doc(groupId)
            .delete();
      }
    }
  }

  Future<void> editGroup(String groupId, Group newGroup) async {
    newGroup.id = groupId;

    await firestore.collection('groups').doc(groupId).set(newGroup.toMap());

    for (var member in newGroup.members) {
      await firestore
          .collection('user_group')
          .doc(member)
          .collection('groups')
          .doc(groupId)
          .set(newGroup.toMap());
    }
  }

  Future<void> joinGroup(String groupId) async {
    final String currentUserId = auth.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> localGroup =
        await firestore.collection('groups').doc(groupId).get();

    Group getGroup = Group(
        id: localGroup["id"],
        name: localGroup["name"],
        leader: localGroup["leader"],
        description: localGroup["description"],
        members: List<String>.from(localGroup["members"]));

    getGroup.members.add(currentUserId);

    await firestore.collection('groups').doc(groupId).set(getGroup.toMap());

    for (var member in getGroup.members) {
      await firestore
          .collection('user_group')
          .doc(member)
          .collection('groups')
          .doc(groupId)
          .set(getGroup.toMap());
    }
  }

  Future<Group> findGroup(String groupId) async {
    DocumentSnapshot<Map<String, dynamic>> localGroup =
        await firestore.collection('groups').doc(groupId).get();

    return Group(
        id: localGroup["id"],
        name: localGroup["name"],
        leader: localGroup["leader"],
        description: localGroup["description"],
        members: List<String>.from(localGroup['members']));
  }

  Future<void> leaveGroup(String groupId) async {
    final String currentUserId = auth.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> localGroup =
        await firestore.collection('groups').doc(groupId).get();

    Group getGroup = Group(
        id: localGroup["id"],
        name: localGroup["name"],
        leader: localGroup["leader"],
        description: localGroup["description"],
        members: List<String>.from(localGroup["members"]));

    getGroup.members.remove(currentUserId);

    await firestore.collection('groups').doc(groupId).set(getGroup.toMap());

    await firestore
        .collection('user_group')
        .doc(currentUserId)
        .collection('groups')
        .doc(groupId)
        .delete();

    for (var member in getGroup.members) {
      await firestore
          .collection('user_group')
          .doc(member)
          .collection('groups')
          .doc(groupId)
          .set(getGroup.toMap());
    }
  }
}
