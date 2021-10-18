import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../constants.dart';

class UserDetails with ChangeNotifier {
  String uid = '';
  String userFullName = '';
  String userEmail = '';
  String status = Status.defaultStatus;
  String? inProgressStatus; //for preventing spam calls to db
  Timestamp? statusUpdateAt;
  //ONEDAY let users choose their 'last updated [x] mins ago specificity
  int minuteSpecificityMax = 30;
  int minuteSpecificityMin = 5;
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
        var usersCollection = _firestore.collection('users');
        var userDocument = (await usersCollection.doc(user.uid).get());

        userFullName = userDocument['fullname'];
        userEmail = userDocument['email'];
        uid = user.uid;

        var statusCollection = _firestore.collection('statuses');
        var statusDoc = (await statusCollection.doc(user.uid).get());
        status = statusDoc['status'];
        statusUpdateAt = statusDoc['time'];

        notifyListeners();
      } else {
        print("user was null");
      }
    } catch (e) {
      print("error in updateUserInfo()");
      print(e);
    }
  }

  String getLastUpdated() {
    //TODO CHANGE TO CONTACT, NOT CURRENT USER
    if (statusUpdateAt == null) {
      return 'loading...';
    }

    //same prefix for each option
    String capStatus = status[0].toUpperCase() + status.substring(1);
    String lastUpdated = "$userFullName: '$capStatus', ";

    int diff = Timestamp.now().seconds - statusUpdateAt!.seconds;
    int minutes = diff ~/ 60;
    int hours = minutes ~/ 60;

    if (minutes < minuteSpecificityMax) {
      lastUpdated += "within the last $minuteSpecificityMin minutes";
    } else if (minutes < minuteSpecificityMax) {
      lastUpdated += "$minutes mins ago";
    } else {
      if (hours > 0) {
        String s = (hours == 1) ? '' : 's';
        lastUpdated += "more than $hours hour${s} ago";
      } else {
        lastUpdated += "within the last hour";
      }
    }
    return lastUpdated;
  }

  void updateStatus(int statusIndex) async {
    //TODO Check this doesn't cause problems for UI to be out of sync with db
    //update the ui to show changes quickly
    status = Status.names[statusIndex];
    notifyListeners();

    // Check if there is an existing status update
    if (statusWait != null) {
      // Don't replace an exisiting update with the same status
      if (inProgressStatus == status) {
        print('Already updating with that status.');
        return;
      }

      // Cancel existing update for the previous (not newest selected) status
      statusWait!.cancel();
      // This update is now in progres
      inProgressStatus = status;
    }

    //setup our 'waiting' future
    int secondsToWait = 3;
    statusWait = CancelableOperation.fromFuture(
      Future.delayed(Duration(seconds: secondsToWait)),
      onCancel: () {
        print('Cancelled status update.');
      },
    );

    // Hurry up and wait
    print('Waiting before updating status (${secondsToWait}s)');
    statusWait!.value.then((value) {
      print('Updating status');
      statusUpdateAt = Timestamp.now();
      notifyListeners();
      _firestore.collection('statuses').doc(uid).set({
        'status': status,
        'time': statusUpdateAt,
        'name': userFullName,
      });
      // Finished updating status
      inProgressStatus = null;
    });
  }
}

class Status {
  static List<String> names = ['none', 'busy', 'maybe', 'free'];
  static String defaultStatus = names[0];
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
