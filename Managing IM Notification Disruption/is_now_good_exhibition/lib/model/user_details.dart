import 'dart:async';

import 'package:flutter/material.dart';
import 'package:async/async.dart';

import '../constants.dart';

class Message {
  late String time;
  late String date;
  late String sender;
  late String text;

  Message({
    required this.time,
    required this.sender,
    required this.text,
  });
}

class UserDetails with ChangeNotifier {
  bool clickedNotification = false;
  int notifierIndex = Notifier.defaultLabelIndex;
  String userFullName = 'Joe Swanson';
  String status = Status.defaultStatus;
  late String uploaded;
  //ONEDAY let users choose their 'last updated [x] mins ago specificity
  int minuteSpecificityMax = 30;
  int minuteSpecificityMin = 5;
  Map<String, List<Message>> messages = {
    'Alice Merton': [
      Message(time: getNow(), sender: 'User Name', text: 'Hi'),
      Message(time: getNow(), sender: 'Alice Merton', text: 'Hi'),
    ],
    'Bob Odenkirk': [
      Message(time: getNow(), sender: 'Bob Odenkirk', text: 'Hey there'),
    ],
    'Charlie Chaplin': [],
  };
  List<String> contacts = ['Alice Merton', 'Bob Odenkirk', 'Charlie Chaplin'];

  UserDetails() {
    uploaded = getFormattedDateAndTime(
      DateTime.now(),
      withSeconds: true,
    ).reversed.toString();
  }

  void addContact(String contactName) {
    contacts.add(contactName);
    notifyListeners();
  }

  void updateStatus(int index) {
    status = Status.names[index];
    uploaded = getFormattedDateAndTime(
      DateTime.now(),
      withSeconds: true,
    ).reversed.toString();
    notifyListeners();
  }

  void sendMessage(Message message, String recipient) {
    messages[recipient]!.insert(0, message);
    notifyListeners();
  }

  void updateNotifierIndex(int index) {
    notifierIndex = index;
    notifyListeners();
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
