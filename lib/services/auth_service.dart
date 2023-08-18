import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
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
        .set({'uid': userCredential.user!.uid, 
              'email': googleUser!.email,
              'name': googleUser!.displayName},
            SetOptions(merge: true));
    return userCredential;
  }
}
