import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:mybuilding/models/usermodel.dart';

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  MyUser? userFromFirebaseUser(auth.User? user) {
    return user != null
        ? MyUser(
            uid: user.uid,
            email: user.email,
          )
        : null;
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(userFromFirebaseUser);
  }

  Future registerWithEmailAndPassword({required String login, required String password, required String name, required String type}) async {
    try {
      auth.User? user = (await _auth.createUserWithEmailAndPassword(email: "$login@gmail.com", password: password)).user;

      await FirebaseFirestore.instance
          .collection("allusers")
          .doc(user!.uid)
          .set({'uid': user.uid, 'name': name, 'type': type, 'login': login, 'password': password, 'firmauid': '', 'obyektlar': []});
      return userFromFirebaseUser(user);
    } catch (e) {
      return e;
    }
  }

  Future signInWithEmailAndPassword({required String login, required String password}) async {
    try {
      auth.User? user = (await _auth.signInWithEmailAndPassword(email: "$login@gmail.com", password: password)).user;
      return userFromFirebaseUser(user);
    } catch (e) {
      return e;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return e;
    }
  }
}
