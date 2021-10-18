import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:is_now_good_exhibition/components/notification_option_bard.dart';
import 'package:provider/provider.dart';
import '/model/user_details.dart';
import '/constants.dart';
import '/components/my_flutter_app_icons.dart';

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
  String messageText = "";
  //the emails of current user and user to chat with, sorted
  String contactName = '⚡️Chat';

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context) != null) {
      contactName = ModalRoute.of(context)!.settings.arguments as String;
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
                return Expanded(
                  child: SizedBox(
                    height: 200.0,
                    child: ListView(
                      reverse: true,
                      children: [
                        for (var message in userDetails.messages[contactName]!)
                          MessageBubble(
                            sender: message.sender,
                            text: message.text,
                            time: message.time,
                            isMe: (message.sender == userDetails.userFullName),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Consumer<UserDetails>(
              builder: (context, userDetails, child) {
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Notifier.colours[userDetails.notifierIndex],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Notify ${contactName.split(" ")[0]}',
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
                );
              },
            ),
            NotificationOptionBar(),
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
                          if (messageText != "") {
                            messageTextController.clear();
                            String now =
                                getFormattedDateAndTime(DateTime.now())[1];
                            userDetails.sendMessage(
                                Message(
                                    text: messageText,
                                    time: now,
                                    sender: userDetails.userFullName),
                                contactName);
                          }
                        },
                        child: const Text(
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

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
  });
  late final String sender;
  late final String text;
  late final String time;
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
            time,
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
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
