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
            List<String> date_and_time = getFormattedDateAndTime(messageTime);
            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              date_and_time: date_and_time,
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
