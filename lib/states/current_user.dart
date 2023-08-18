import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CurrentUser extends ChangeNotifier {
  late String userId;
  late String email;

  String get getUid => userId;
  String get getEmail => email;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> signUpUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);

      if(userCredential.user != null){
        return true;
      }
    } catch(e) {
      print(e);
    }
    return false;
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);

      if(userCredential.user != null){
        userId = userCredential.user!.uid;
        email = userCredential.user!.email!;
        return true;
      }
    } catch(e) {
      print(e);
    }
    return false;
  }
}