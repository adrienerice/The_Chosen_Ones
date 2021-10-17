import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetails with ChangeNotifier {
  String uid = '';
  String userFullName = '';
  String userEmail = '';

  UserDetails() {
    updateUserInfo();
  }

  void updateUserInfo() async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;
    // User loggedInUser;
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // loggedInUser = user;

        var usersCollection = _firestore.collection('users');
        var userDocument = (await usersCollection.doc(user.uid).get());

        userFullName = userDocument['fullname'];
        userEmail = userDocument['email'];
        uid = user.uid;
        notifyListeners();
      } else {
        print("user was null");
      }
    } catch (e) {
      print("error in updateUserInfo()");
      print(e);
    }
  }
}
