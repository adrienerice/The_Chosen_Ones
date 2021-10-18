import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:is_now_good_exhibition/components/my_flutter_app_icons.dart';

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

List<String> getFormattedDateAndTime(DateTime ts, {bool withSeconds = false}) {
  String rawTime = ts.toString().substring(5, 20);

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

  String seconds = rawTime.substring(12, 14);
  String minutes = rawTime.substring(9, 11);
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

String getNow() {
  return getFormattedDateAndTime(DateTime.now())[1];
}

class Notifier {
  static List<IconData> icons = [
    FontAwesomeIcons.ghost,
    Icons.volume_off,
    Icons.volume_up,
    CustomIcons.isNowGood,
  ];
  static List<Color> colours = [
    Colors.grey,
    Colors.blueGrey,
    Colors.blue,
    Colors.green,
  ];
  static int defaultLabelIndex = 2;
  static List<String> labels = ['None', 'Silent', 'Normal', 'Is Now Good?'];
}
