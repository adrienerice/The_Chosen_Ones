import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:is_now_good/model/user_details.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import '/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_now_good/components/my_flutter_app_icons.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser; //ONEDAY move to Provider

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

/*
IS this just to make it better or to make it work for your needs? 
TODO move messages stream into new file? provider?
TODO contacts list screen
TODO add contact

 */

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String messageText = "";
  //the emails of current user and user to chat with, sorted
  String chatID = '';
  String contactName = '⚡️Chat';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print("User logged in: " + loggedInUser!.email.toString());
      } else {
        print("user was null");
      }
    } catch (e) {
      print("error in getCurrentUser()");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context) != null) {
      var contact = ModalRoute.of(context)!.settings.arguments as List<String>;
      chatID = contact[0];
      // List<String> a = [contact[1], userD];
      contactName = contact[1];
    } else {
      contactName = 'problem';
      chatID = 'problem'; //ONEDAY handle more gracefully
    }

    // contactName = _auth.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: null,
        title: Text(contactName),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Consumer<UserDetails>(
              builder: (context, userDetails, child) {
                chatID = '';
                var names = [contactName, userDetails.userFullName];
                names.sort();
                for (var name in names) {
                  chatID += name;
                }
                return MessageStream(chatID: chatID);
              },
            ),
            NotificationOptionBar(),
            // Container(
            //   decoration: kMessageContainerDecoration, //TODO alter decoration
            //   child: ListTile(
            //     tileColor: Colors.green,
            //     onTap: () {
            //       //ask for status
            //     },
            // trailing: const CircleAvatar(
            //   backgroundImage: ResizeImage(
            //     AssetImage('images/logo.png'),
            //     width: 40,
            //     height: 40,
            //   ),
            // ),
            //   ),
            // ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  Consumer<UserDetails>(
                    builder: (context, userDetails, child) {
                      return TextButton(
                        onPressed: () {
                          //TODO tell user about status of recipient before send
                          //TODO let user choose notification for recipient
                          //TODO Notifications!
                          if (messageText != "") {
                            messageTextController.clear();
                            String now = Timestamp.now().seconds.toString();
                            chatID = '';
                            var names = [contactName, userDetails.userFullName];
                            names.sort();
                            for (var name in names) {
                              chatID += name;
                            }
                            _firestore
                                .collection('chats')
                                .doc(chatID)
                                .collection('messages')
                                .doc(now)
                                .set(
                              {
                                'sender': userDetails.userFullName,
                                'text': messageText,
                                'audio_notification': true, //TODO ask user
                                'visual_notification': true,
                              },
                            );
                          }
                        },
                        child: Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  late final String chatID;

  MessageStream({required this.chatID});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetails>(
      builder: (context, userDetails, child) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore
              .collection('chats')
              .doc(chatID)
              .collection('messages')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              final snackBar = SnackBar(content: Text('Loading...'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return Container();
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              final reverseMessages = snapshot.data!.docs;
              final messages = [];
              for (var message in reverseMessages.reversed) {
                messages.add(message);
                //ONEDAY there seems to be no better way of doing this in Dart :0
              }
              List<MessageBubble> messageBubbles = [];
              for (var message in messages) {
                final data = message.data();
                final messageText = message.data()['text'];
                final messageSender = message.data()['sender'];
                int? seconds = int.tryParse(message.id);
                late final Timestamp messageTime;
                if (seconds != null) {
                  messageTime = Timestamp(seconds, 0);
                } else {
                  messageTime = Timestamp(0, 0); //ONEDAY handle more gracefully
                }
                List<String> date_and_time =
                    getFormattedDateAndTime(messageTime);
                final messageBubble = MessageBubble(
                  text: messageText,
                  sender: messageSender,
                  date_and_time: date_and_time,
                  isMe: (userDetails.userFullName == messageSender),
                );

                messageBubbles.add(messageBubble);
              }

              return Expanded(
                child: ListView(
                  reverse: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 20.0,
                  ),
                  children: messageBubbles,
                ),
              );
            }
          },
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.sender,
    required this.text,
    required this.date_and_time,
    required this.isMe,
  });
  late final String sender;
  late final String text;
  late final List<String> date_and_time;
  late final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            date_and_time[0],
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
              topRight: isMe ? Radius.zero : Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              topLeft: isMe ? Radius.circular(30.0) : Radius.zero,
            ),
            color: isMe ? Colors.green[800] : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                '$text',
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          Text(
            date_and_time[1],
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationOptionBar extends StatefulWidget {
  const NotificationOptionBar({Key? key}) : super(key: key);

  @override
  _NotificationOptionBarState createState() => _NotificationOptionBarState();
}

class _NotificationOptionBarState extends State<NotificationOptionBar> {
  int currentIndex = Notification.defaultLabelIndex;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.black54,
      items: [
        for (int i = 0; i < Notification.labels.length; i++)
          BottomNavigationBarItem(
            backgroundColor: Notification.colours[i],
            label: Notification.labels[i],
            icon: Icon(Notification.icons[i]),
          ),
      ],
    );
  }
}

class Notification {
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