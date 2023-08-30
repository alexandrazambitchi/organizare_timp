import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:organizare_timp/model/user_model.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      firestore.collection('users').doc(userCredential.user!.uid).set(
          {'uid': userCredential.user!.uid, 'email': email},
          SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signUpWithEmailandPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      firestore.collection('users').doc(userCredential.user!.uid).set(
        {'uid': userCredential.user!.uid, 'email': email, 'name': name},
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'uid': userCredential.user!.uid,
      'email': googleUser.email,
      'name': googleUser.displayName
    }, SetOptions(merge: true));
    return userCredential;
  }

  Future<List<UserModel>> getUserList() async {
    List<UserModel> users = [];
    QuerySnapshot<Map<String, dynamic>> usersCollection =
        await firestore.collection('users').get();

    for (var element in usersCollection.docs) {
      UserModel tempUser = await getUserfromDB(element.id);
      users.add(tempUser);
    }
    return users;
  }

  Future<UserModel> getUserfromDB(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userDb =
        await firestore.collection('users').doc(userId).get();

    return UserModel(
      uid: userId,
      email: userDb['email'],
      name: userDb['name'],
    );
  }

  Future<List<UserModel>> getOtherUserList() async {
    String currentUserId = firebaseAuth.currentUser!.uid;
    List<UserModel> users = [];
    QuerySnapshot<Map<String, dynamic>> usersCollection =
        await firestore.collection('users').get();

    for (var element in usersCollection.docs) {
      if (element.id != currentUserId) {
        UserModel tempUser = await getUserfromDB(element.id);
        users.add(tempUser);
      }
    }
    return users;
  }

  Stream<QuerySnapshot> getGroups(String groupId) {
    final String currentUserId = firebaseAuth.currentUser!.uid;

    return firestore
        .collection('user_group')
        .doc(currentUserId)
        .collection('groups')
        .snapshots();
  }
}
