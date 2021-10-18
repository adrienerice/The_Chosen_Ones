import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.green,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightGreenAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.grey),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.greenAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

List<String> getFormattedDateAndTime(Timestamp ts, {bool withSeconds = false}) {
  String test = ts.toDate().toString();
  String rawTime = ts.toDate().toString().substring(5, 16);

  //ONEDAY handle more gracefully
  // Get hour of day and check for AM or PM
  int? parsedHour = int.tryParse(rawTime.substring(6, 8));
  int hour = parsedHour != null ? parsedHour : 0;
  late String meridian;
  if (hour > 12) {
    hour -= 12;
    meridian = "pm";
  } else {
    meridian = 'am';
  }

  String seconds = ts.toDate().toString().substring(17, 19);
  String minutes = rawTime.substring(9);
  String date = rawTime.substring(0, 5);
  String day = date.substring(3);
  int? monthParsed = int.tryParse(date.substring(0, 2));
  int monthNum = monthParsed != null ? monthParsed : 0;
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  late String suffix;
  if (day.substring(1) == '1') {
    suffix = 'st';
  } else if (day.substring(1) == '2') {
    suffix = 'nd';
  } else if (day.substring(1) == '3') {
    suffix = 'rd';
  } else {
    suffix = 'th';
  }
  date = day + suffix + " " + months[monthNum - 1];
  String time = hour.toString() + ":" + minutes;
  if (withSeconds) {
    time += ":" + seconds;
  }
  time += meridian;
  return [date, time];
}
