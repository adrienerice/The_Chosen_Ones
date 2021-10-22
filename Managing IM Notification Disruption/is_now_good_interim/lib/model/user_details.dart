import 'dart:async';

import 'package:flutter/material.dart';
import 'package:async/async.dart';

import '../constants.dart';

class Message {
  late String time;
  late String date;
  late String sender;
  late String text;
  late Color colour;

  static const Color defaultColour = Colors.blue;

  Message({
    required this.time,
    required this.sender,
    required this.text,
    this.colour = Message.defaultColour,
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
    'Alice Mertone': [
      Message(
        time: getNow(),
        sender: 'Joe Swanson',
        text: 'Hi',
        // colour: Notifier.colours[2],
      ),
      Message(
        time: getNow(),
        sender: 'Alice Mertone',
        text: 'Hi',
        // colour: Notifier.colours[0],
      ),
    ],
    'Bob Odenkirk': [
      Message(
        time: getNow(),
        sender: 'Bob Odenkirk',
        text: 'I\'m very busy',
        // colour: Notifier.colours[1],
      ),
    ],
    'May Beacom': [
      Message(
        time: getNow(),
        sender: 'May Beacom',
        text: 'I can talk.. Maybe.',
        // colour: Notifier.colours[2],
      ),
    ],
    'Frank Woodley': [
      Message(
        time: getNow(),
        sender: 'Frank Woodley',
        text: 'Cause I\'m FREE!',
        // colour: Notifier.colours[3],
      ),
      Message(
        time: getNow(),
        sender: 'Frank Woodley',
        text: 'Call me William Wallace',
        // colour: Notifier.colours[3],
      ),
    ],
  };
  List<String> contacts = [
    'Alice Mertone',
    'Bob Odenkirk',
    'May Beacom',
    'Frank Woodley',
  ];

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

  void sendMessage(Message message, String contact) {
    messages[contact]!.insert(0, message);
    notifyListeners();
  }

  void updateNotifierIndex(int index) {
    notifierIndex = index;
    notifyListeners();
  }
}

class Status {
  static List<String> names = ['N/A', 'Busy', 'Maybe', 'Free'];
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