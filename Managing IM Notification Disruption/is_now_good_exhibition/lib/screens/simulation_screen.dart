import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:is_now_good_exhibition/components/notification_option_bard.dart';
import 'package:is_now_good_exhibition/components/rounded_button.dart';
import 'package:is_now_good_exhibition/model/notification_api.dart';
import 'package:is_now_good_exhibition/model/user_details.dart';
import 'package:is_now_good_exhibition/screens/chat_screen.dart';
import 'package:is_now_good_exhibition/screens/contacts_screen.dart';
import 'package:provider/provider.dart';
import '../model/user_details.dart' as My;

import '../constants.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({Key? key}) : super(key: key);
  static String id = 'simulation_screen';

  @override
  _SimulationScreenState createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  String messageText = '';

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    //do something with payload.
    if (payload == "silent") {
      Navigator.pushNamed(context, ChatScreen.id, arguments: "Alice Mertone");
      return;
    }
    if (payload != null && payload != "") {
      Navigator.pushNamed(context, ChatScreen.id, arguments: payload);
      // Navigator.pushNamed(
      //   context,
      //   ResponseScreen.id,
      //   arguments: 'Alice Mertone, Where should we go for dinner?',
      // );
      showDialog(
        context: context,
        barrierDismissible: false, //User has to make a selection
        builder: (context) {
          String firstname = 'Alice';
          return AlertDialog(
            title: Text('$firstname wants to talk:'),
            content: Text(
              '"Where should we go for dinner?"',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            actions: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Respond:'),
                  ),
                  StatusBottomNavBar(),
                  Consumer<UserDetails>(
                    builder: (context, userDetails, child) => TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration.copyWith(
                          hintText:
                              'Reply (tap to change): \n"${userDetails.userFullName.split(" ")[0]}\'s status is \'${userDetails.status}\'..."'),
                    ),
                  ),
                  Consumer<UserDetails>(
                    builder: (context, userDetails, child) => TextButton(
                      onPressed: () {
                        String fn = userDetails.userFullName.split(" ")[0];
                        String st = userDetails.status;
                        if (messageText.length == 0) {
                          messageText = '$fn\'s status is "$st"';
                        }
                        String text =
                            messageText; //'$fn\'s status is "$st":\n$messageText';
                        My.Message newMessage = My.Message(
                          sender: userDetails.userFullName,
                          time: getNow(),
                          text: text,
                          colour: Status.colours[
                              Status.names.indexOf(userDetails.status)],
                        );
                        userDetails.sendMessage(newMessage, 'Alice Mertone');
                        Navigator.pop(context);
                      },
                      child: const Text('Send'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetails>(
      builder: (context, userDetails, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                RoundedButton(
                    text: 'Receive message notification',
                    color: Notifier.colours[userDetails.notifierIndex],
                    onPressed: () {
                      if (kIsWeb) {
                        // FlutterWebView
                      } else {
                        My.Message m = My.Message(
                          text: 'Where should we go for dinner?',
                          time: getNow(),
                          sender: 'Alice Mertone',
                        );
                        //['None', 'Silent', 'Normal', 'Is Now Good?'];
                        String notif =
                            Notifier.labels[userDetails.notifierIndex];

                        if (notif == 'None') {
                          m.colour = Notifier.colours[0];
                          m.text = "Here's a secret message for later";
                          //Do nothing
                        } else if (notif == 'Silent') {
                          m.colour = Notifier.colours[1];
                          _showNotificationWithNoSound();
                        } else if (notif == 'Normal') {
                          m.colour = Notifier.colours[2];
                          NotificationApi.showNotification(
                            title: 'Alice Mertone',
                            body: 'Where should we go for dinner?',
                            payload: 'Alice Mertone',
                          );
                        } else if (notif == 'Is Now Good?') {
                          m.colour = Notifier.colours[3];
                          NotificationApi.showNotification(
                            title: 'Is Now Good?',
                            body:
                                'Alice Mertone wants to talk. Tap to repsond.',
                            payload: 'Alice Mertone',
                          );
                        }
                        userDetails.sendMessage(m, 'Alice Mertone');
                      }
                    }),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  Notifier.colours[userDetails.notifierIndex],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Notification option',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    NotificationOptionBar(),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showNotificationWithNoSound() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('silent channel id', 'silent channel name',
          channelDescription: 'silent channel description',
          playSound: false,
          styleInformation: DefaultStyleInformation(true, true));
  const IOSNotificationDetails iOSPlatformChannelSpecifics =
      IOSNotificationDetails(presentSound: false);
  const MacOSNotificationDetails macOSPlatformChannelSpecifics =
      MacOSNotificationDetails(presentSound: false);
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
      macOS: macOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, '<b>silent</b> title', '<b>silent</b> body', platformChannelSpecifics,
      payload: "silent");
}
