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
    'Alice Mert-None': [
      Message(
        time: getNow(),
        sender: 'Joe Swanson',
        text: 'Hi',
        // colour: Notifier.colours[2],
      ),
      Message(
        time: getNow(),
        sender: 'Alice Mert-None',
        text: 'Hi',
        // colour: Notifier.colours[0],
      ),
    ],
    'BusyBob Odenkirk': [
      Message(
        time: getNow(),
        sender: 'BusyBob Odenkirk',
        text: 'I\'m very busy',
        // colour: Notifier.colours[1],
      ),
    ],
    'Maybe Funke': [
      Message(
        time: getNow(),
        sender: 'Maybe Funke',
        text: 'I can talk.. Maybe.',
        // colour: Notifier.colours[2],
      ),
    ],
    'Free-Frank Woodley': [
      Message(
        time: getNow(),
        sender: 'Free-Frank Woodley',
        text: 'Cause I\'m FREE!',
        // colour: Notifier.colours[3],
      ),
      Message(
        time: getNow(),
        sender: 'Free-Frank Woodley',
        text: 'Call me William Wallace',
        // colour: Notifier.colours[3],
      ),
    ],
  };
  List<String> contacts = [
    'Alice Mert-None',
    'BusyBob Odenkirk',
    'Maybe Funke',
    'Free-Frank Woodley',
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
