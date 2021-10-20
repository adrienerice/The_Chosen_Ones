import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:provider/provider.dart';

import '/constants.dart';
import '/model/notification_api.dart';
import '/model/user_details.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late AudioPlayer audioPlayer;

class ContactsScreen extends StatefulWidget {
  ContactsScreen({Key? key}) : super(key: key);
  static const String id = 'contacts_screen';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotifications();
    audioPlayer = AudioPlayer();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    //TODO
    var info = {};
    if (payload != null) {
      info = json.decode(payload) as Map<dynamic, dynamic>;
    }
    int i = 0;
  }

  Future<Map<String, dynamic>> sendIsNowGood(String name,
      {self = false}) async {
    /***
                             * 
                             * 
                             * 
                             * 
                             * 




                             
                             */
    Map<String, dynamic> outgoing = {};
    outgoing["sent"] = false;
    TextEditingController c = TextEditingController();
    String msg = Notifier.notifs[0];
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ask $name "Is now good?"'),
          content: Text("Tap 'Yes' to ask $name to start a"
              " conversation or 'No' to cancel."),
          actions: [
            if (!self)
              TextField(
                controller: c,
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter a message (optional)'),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextButton(
                      child: const Text('No'),
                      onPressed: () {
                        outgoing["sent"] = false;
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        outgoing["sent"] = true;
                        msg = c.text;
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
    final snackBar = SnackBar(
      duration: const Duration(seconds: 3),
      content: Text('Getting $name\'s status...'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    await Future.delayed(Duration(seconds: 3));
    if (outgoing["sent"]) {
      Random rng = Random();
      String randomStatus = Status.names[rng.nextInt(Status.names.length)];
      String stat = (self)
          ? Provider.of<UserDetails>(context, listen: false).status
          : randomStatus;
      String notifChosen = Notifier.notifs[0];
      String previewSelected = "Yes";
      List<String> times = [
        "3 hours ago",
        '5 minutes ago',
        "1 day ago",
        "1 hour ago",
        "50 minutes ago",
      ];
      String time = times[rng.nextInt(times.length)];
      if (self) {
        String uploaded =
            Provider.of<UserDetails>(context, listen: false).uploaded;
        time = uploaded.substring(1, uploaded.length - 11);
      }
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16.0),
                children: [
                  TextSpan(text: '$name was '),
                  TextSpan(
                    text: stat,
                    style: TextStyle(
                      color: Status.colours[Status.names.indexOf(stat)],
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  TextSpan(text: ' $time'),
                ],
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatefulBuilder(builder: (context, setState) {
                  return Column(
                    children: [
                      Text("Send $name a notification:"),
                      for (String notif in Notifier.notifs)
                        RadioListTile<String>(
                          title: Text(notif),
                          value: notif,
                          groupValue: notifChosen,
                          onChanged: (var value) {
                            setState(() => notifChosen = value!);
                          },
                        ),
                      Text("Let $name preview the message?"),
                      for (String preview in ["Yes", "No"])
                        RadioListTile<String>(
                          title: Text(preview),
                          value: preview,
                          groupValue: previewSelected,
                          onChanged: (var value) {
                            setState(() => previewSelected = value!);
                          },
                        ),
                    ],
                  );
                }),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  outgoing["sent"] = false;
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  outgoing["sent"] = true;
                  outgoing["notif"] = notifChosen;
                  outgoing["preview"] =
                      (previewSelected == 'Yes') ? true : false;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      final snackBar = SnackBar(
        duration: const Duration(seconds: 3),
        content: Text('"Is Now Good?" has been sent to $name'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await Future.delayed(Duration(seconds: 3));
      final snackBar2 = SnackBar(
        duration: const Duration(seconds: 4),
        content: Text('[NOW WE WAIT FOR A REPSONSE...]'),
      );
      if (!self) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        await Future.delayed(Duration(seconds: 4));
      }
      randomStatus = Status.names[rng.nextInt(Status.names.length)];
      stat = (self)
          ? Provider.of<UserDetails>(context, listen: false).status
          : randomStatus;
      if (!self) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16.0),
                children: [
                  TextSpan(text: '$name has replied: '),
                  TextSpan(
                    text: stat,
                    style: TextStyle(
                      color: Status.colours[Status.names.indexOf(stat)],
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  outgoing["sent"] = true;
                  outgoing["notif"] = notifChosen;
                  outgoing["preview"] =
                      (previewSelected == 'Yes') ? true : false;
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        final snackBar = SnackBar(
          duration: const Duration(seconds: 3),
          content: Text('"Your response has been sent'),
        );
        if (self) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          await Future.delayed(Duration(seconds: 3));
        }
      }
    }
    return outgoing;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> contactNames = [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Consumer<UserDetails>(
          builder: (context, userDetails, child) {
            return Text(userDetails.userFullName);
          },
        ),
      ),
      body: Consumer<UserDetails>(
        builder: (context, userDetails, child) {
          Provider.of<UserDetails>(context).contactsSentMessage; //NECESSARY!
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    for (var contact in userDetails.contacts)
                      ListTile(
                        leading: Icon(Icons.person),
                        trailing: const CircleAvatar(
                          backgroundImage: ResizeImage(
                            AssetImage('images/logo.png'),
                            width: 40,
                            height: 40,
                          ),
                        ),
                        title: Text(
                          contact,
                          style: TextStyle(
                              //make it bold if the user sent a message
                              fontWeight: (userDetails.lastMessages[userDetails
                                          .contacts
                                          .indexOf(contact)] !=
                                      "")
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                        subtitle: Text(userDetails.lastMessages[
                            userDetails.contacts.indexOf(contact)]),
                        onTap: () async {
                          var cs =
                              Provider.of<UserDetails>(context, listen: false)
                                  .contacts;
                          if (Provider.of<UserDetails>(context, listen: false)
                                  .lastMessages[cs.indexOf(contact)] !=
                              "") {
                            //reply to contacts message
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Reply to $contact'),
                                    content: StatusBottomNavBar(),
                                    actions: [
                                      Expanded(
                                        child: TextButton(
                                          child: const Text('Send'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                });
                            //change last sent message from that contact
                            Provider.of<UserDetails>(context, listen: false)
                                .lastSentUpdate("", contact);
                          } else {
                            //send contact a message
                            await sendIsNowGood(contact);
                          }
                        },
                      ),
                    ListTile(
                      tileColor: Colors.grey[300],
                      leading: Icon(Icons.person),
                      trailing: const CircleAvatar(
                        backgroundImage: ResizeImage(
                          AssetImage('images/logo.png'),
                          width: 40,
                          height: 40,
                        ),
                      ),
                      title: Text(
                        userDetails.userFullName +
                            ' (for the purpose of simulation)',
                      ),
                      subtitle: const Text('send yourself a message'),
                      onTap: () async {
                        Map<String, dynamic> incoming = await sendIsNowGood(
                            userDetails.userFullName,
                            self: true);
                        if (incoming['sent'] == false) {
                          return;
                        }
                        Random rng = Random();
                        String sender = userDetails
                            .contacts[rng.nextInt(userDetails.contacts.length)];
                        List<String> messages = [
                          "Are you busy? I want to call",
                          "Let's have lunch, send me a text",
                          "Have you seen the new Spiderman trailer? I sent you the video on WhatsApp",
                          "How is the family?",
                          "I miss you...",
                          "I've got some hot gos about Bob but don't tell anyone.",
                        ];
                        String message = messages[rng.nextInt(messages.length)];

                        String notifOption = incoming['notif'];
                        bool preview = incoming['preview'];
                        if (!preview) {
                          message = '$sender wants to start a conversation.';
                        }
                        String title = 'Is Now Good? - $sender';
                        /***
                             * 
                             * 
                             * 
                             * 
                             * 





                             */

                        //update contacts screen
                        //if don't notify: don't send
                        //if on webt
                        //    if normal, play sound
                        //    show dialog and say it will be a notification on mobile
                        //else
                        //    if normal: play sound notifcaiton
                        //    if silent play silent notificaiton
                        //

                        //TODO Update CONTACTS SCREEN WITH BOLD and USUBTITLE
                        if (notifOption == Notifier.notifs[2]) {
                          //Dont notify
                          return;
                        }
                        if (kIsWeb) {
                          if (notifOption == Notifier.notifs[0]) {
                            //Normal
                            await audioPlayer.play('/sounds/alert.mp3',
                                isLocal: true);
                          }
                          await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(title),
                                    content: Text(message +
                                        "\n(This dialog box shows as a native notification on mobile)"),
                                  ));
                        } else {
                          if (notifOption == Notifier.notifs[0]) {
                            //Normal
                            NotificationApi.showNotification(
                              title: title,
                              body: message,
                              payload: json.encode(incoming),
                            );
                          } else {
                            //Silent
                            _showNotificationWithNoSound(
                                title, message, json.encode(incoming));
                          }
                        }
                        //change last sent message from that contact
                        Provider.of<UserDetails>(context, listen: false)
                            .lastSentUpdate(message, sender);
                        /***
                             * 
                             * 
                             * 
                             * 
                             * 




                             
                             */
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                tileColor: Status.getColourWithName(userDetails.status),
                enabled: false,
                title: Column(
                  children: [
                    const Text(
                      'My Status',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      '(set at ${userDetails.uploaded.substring(1, userDetails.uploaded.length - 11)})',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const StatusBottomNavBar(),
    );
  }
}

class StatusBottomNavBar extends StatefulWidget {
  const StatusBottomNavBar({Key? key}) : super(key: key);

  @override
  _StatusBottomNavBarState createState() => _StatusBottomNavBarState();
}

class _StatusBottomNavBarState extends State<StatusBottomNavBar> {
  // int statusIndex = 0; shouldn't be needed, replaced with userDetails.status

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetails>(
      builder: (context, userDetails, child) {
        return BottomNavigationBar(
          items: [
            for (var i = 0; i < Status.names.length; i++)
              BottomNavigationBarItem(
                label: Status.names[i],
                backgroundColor: Status.colours[i],
                icon: Icon(Status.icons[i]),
              ),
          ],
          showUnselectedLabels: true,
          currentIndex: Status.names.indexOf(userDetails.status),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black54,
          onTap: (index) {
            setState(() {
              userDetails.updateStatus(index);
            });
          },
        );
      },
    );
  }
}

Future<void> _showNotificationWithNoSound(
    String title, String body, String payload) async {
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
  await flutterLocalNotificationsPlugin
      .show(0, title, body, platformChannelSpecifics, payload: payload);
}
