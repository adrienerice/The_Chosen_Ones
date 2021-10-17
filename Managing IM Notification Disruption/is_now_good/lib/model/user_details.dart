import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class UserDetails with ChangeNotifier {
  String uid = '';
  String userFullName = '';
  String userEmail = '';
  String status = Status.names[0]; //deault is 'none'
  // Future<Null>? statusUpdatingNow = null;
  CancelableOperation? statusWait = null;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  UserDetails() {
    updateUserInfo();
  }

  void updateUserInfo() async {
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

  void updateStatus(int statusIndex) async {
    //TODO Check this doesn't cause problems for UI to be out of sync with db
    //If the status is the same as the old one, don't notifyListeners() or alter
    bool statusSame = status == Status.names[statusIndex];
    if (!statusSame) {
      status = Status.names[statusIndex];
      notifyListeners();

      //If there is an existing status update, cancel it
      //e.g. free -> busy -> free within seconds: don't do anything.
      if (statusWait != null) {
        statusWait!.cancel();
      }
      //setup our 'waiting' future
      int secondsToWait = 5;
      statusWait = CancelableOperation.fromFuture(
        Future.delayed(Duration(seconds: secondsToWait)),
        onCancel: () {
          print('Cancelled status update.');
        },
      );
      //only go ahead with waiting to update if the new status is different

      print('Waiting before updating status (${secondsToWait}s)');
      statusWait!.value.then((value) {
        print('Updating status');

        _firestore.collection('statuses').doc(uid).set({'status': status});
      });
    } else {
      print("Didn't bother waiting to change status"
          " because it's same as old one.");
      if (statusWait != null) {
        statusWait!.cancel();
      }
    }
  }
}

class Status {
  static List<String> names = ['none', 'busy', 'maybe', 'free'];
  static List<IconData> icons = [
    Icons.circle_outlined,
    Icons.do_not_disturb_on_outlined,
    Icons.contact_support,
    Icons.done,
  ];
  static List<Color> colours = [
    Colors.grey,
    Colors.red,
    Colors.orange,
    Colors.green,
  ];

  static Color getColourWithName(String name) {
    return colours[names.indexOf(name)];
  }
}
