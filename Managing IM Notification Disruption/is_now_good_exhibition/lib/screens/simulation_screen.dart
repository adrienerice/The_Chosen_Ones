import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:is_now_good_exhibition/components/notification_option_bard.dart';
import 'package:is_now_good_exhibition/components/rounded_button.dart';
import 'package:is_now_good_exhibition/model/notification_api.dart';
import 'package:is_now_good_exhibition/model/user_details.dart';
import 'package:is_now_good_exhibition/screens/chat_screen.dart';
import 'package:is_now_good_exhibition/screens/contacts_screen.dart';
import 'package:js/js_util.dart';
import 'package:provider/provider.dart';
import '../model/user_details.dart' as My;

import 'package:audioplayers/audioplayers.dart';

import '../constants.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:flutter_js/flutter_js.dart';
// import '../js.dart' as js if (dart.library.js)  '../js_web.dart';
import '../js_web.dart';

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

  // late JavascriptRuntime flutterJs;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotifications();
    // flutterJs = getJavascriptRuntime();
    audioPlayer = AudioPlayer();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    //do something with payload.
    if (payload == "silent") {
      Navigator.pushNamed(context, ChatScreen.id, arguments: "Alice Merton");
      return;
    }
    if (payload != null && payload != "") {
      Navigator.pushNamed(context, ChatScreen.id, arguments: payload);
      // Navigator.pushNamed(
      //   context,
      //   ResponseScreen.id,
      //   arguments: 'Alice Merton, Where should we go for dinner?',
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
                        userDetails.sendMessage(newMessage, 'Alice Merton');
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
                    text:
                        'Receive message notification\n(Sound may take a moment to load initially)',
                    color: Notifier.colours[userDetails.notifierIndex],
                    onPressed: () async {
                      My.Message m = My.Message(
                        text: 'Where should we go for dinner?',
                        time: getNow(),
                        sender: 'Alice Merton',
                      );
                      //['None', 'Silent', 'Normal', 'Is Now Good?'];
                      String notif = Notifier.labels[userDetails.notifierIndex];

                      if (notif == 'None') {
                        m.colour = Notifier.colours[0];
                        m.text = "Here's a secret message for later";
                        //Do nothing
                      } else if (notif == 'Silent') {
                        m.colour = Notifier.colours[1];
                        if (kIsWeb) {
                          // flutterJs.evaluate('Alert()');
                          //TODO
                          // js.evaluate('console.log("hello world!")');
                          eval(
                              "alert('Alice Merton: Where should we have dinner?')");
                        } else {
                          _showNotificationWithNoSound();
                        }
                      } else if (notif == 'Normal') {
                        m.colour = Notifier.colours[2];
                        if (kIsWeb) {
                          // TODO
                          // flutterJs.evaluate('Alert()');
                          //https://freesound.org/people/PearceWilsonKing/sounds/413691/
                          await audioPlayer.play('/sounds/alert.mp3',
                              isLocal: true);
                          eval('alert("Alice Merton: '
                              'Where should we have dinner?")');
                        } else {
                          NotificationApi.showNotification(
                            title: 'Alice Merton',
                            body: 'Where should we go for dinner?',
                            payload: 'Alice Merton',
                          );
                        }
                      } else if (notif == 'Is Now Good?') {
                        m.colour = Notifier.colours[3];
                        if (kIsWeb) {
                          // TODO
                          //https://freesound.org/people/PearceWilsonKing/sounds/413691/
                          await audioPlayer.play('/sounds/alert.mp3',
                              isLocal: true);
                          // await promiseToFuture(
                          eval(
                              'confirm("Alice Merton wants to talk. Tap to respond.")');
                          onClickedNotification("Alice Merton");
                        } else {
                          NotificationApi.showNotification(
                            title: 'Is Now Good?',
                            body: 'Alice Merton wants to talk. Tap to repsond.',
                            payload: 'Alice Merton',
                          );
                        }
                      }
                      userDetails.sendMessage(m, 'Alice Merton');
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
                              children: const [
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
