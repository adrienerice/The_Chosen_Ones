import 'package:flutter/material.dart';
import 'package:load/load.dart';
import '/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String myName = '';

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
      var args = ModalRoute.of(context)!.settings.arguments as List<String>;
      contactName = args[0];
      chatID = args[1];
      myName = args[2];
    } else {
      contactName = 'problem';
      chatID = 'problem'; //ONEDAY handle more gracefully
      myName = 'problem';
    }

    // contactName = _auth.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //TODO move signout somewhere better
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text(contactName),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MessageStream(chatID: chatID, myName: myName),
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
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      if (messageText != "") {
                        messageTextController.clear();
                        String now = Timestamp.now().seconds.toString();
                        _firestore
                            .collection('chats')
                            .doc(chatID)
                            .collection('messages')
                            .doc(now)
                            .set(
                          {
                            'sender': myName,
                            'text': messageText,
                          },
                        );
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
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
  late final String myName;

  MessageStream({required this.chatID, required this.myName});

  String formatTime(String time) {
    String formatted = '';
    int? parsedHour = int.tryParse(time.substring(6, 8));
    //ONEDAY handle more gracefully
    int hour = parsedHour != null ? parsedHour : 0;
    late String meridian;
    if (hour > 12) {
      hour -= 12;
      meridian = "pm";
    } else {
      meridian = 'am';
    }
    String minutes = time.substring(9);
    String date = time.substring(0, 5);
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
    formatted = hour.toString() + ":" + minutes + meridian + "  (" + date + ")";
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestore
          .collection('chats')
          .doc(chatID)
          .collection('messages')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          showLoadingDialog();
          return Container();
        } else {
          hideLoadingDialog();
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

            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              time: formatTime(
                messageTime.toDate().toString().substring(5, 16),
              ),
              isMe: (myName == messageSender),
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
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });
  late final String sender;
  late final String text;
  late final time;
  late final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(
          //   '$sender',
          //   style: TextStyle(
          //     fontSize: 12.0,
          //     color: Colors.black54,
          //   ),
          // ),
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
            '$time',
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
