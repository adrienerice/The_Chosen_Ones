import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:is_now_good_exhibition/components/notification_option_bard.dart';
import 'package:is_now_good_exhibition/screens/contacts_screen.dart';
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
    } else {
      contactName = "Alice Mert-None";
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
            Expanded(
              child: SizedBox(
                height: 200.0,
                child: ListView(
                  reverse: true,
                  children: [
                    for (var message in Provider.of<UserDetails>(context)
                        .messages[contactName]!)
                      MessageBubble(
                        message: message,
                        isMe: (message.sender ==
                            Provider.of<UserDetails>(context).userFullName),
                        colour: message.colour,
                      ),
                  ],
                ),
              ),
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
                        child: const Text(
                          'Send',
                          style: kSendButtonTextStyle,
                        ),
                        onPressed: () {
                          if (messageText == "") {
                            return;
                          }
                          showDialog(
                            context: context,
                            barrierDismissible:
                                false, //User has to make a selection
                            builder: (context) {
                              int statusIndex =
                                  userDetails.contacts.indexOf(contactName);
                              String contactStatus = Status.names[statusIndex];
                              return AlertDialog(
                                title: Text(
                                  '$contactName has status "$contactStatus"',
                                  style: TextStyle(
                                    color: Status.colours[statusIndex],
                                  ),
                                ),
                                content: const Text(
                                  'Would you like to change your notification option?',
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                actions: [
                                  Column(
                                    children: [
                                      NotificationOptionBar(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              //TODO Update color of message
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ).then((val) {
                            messageTextController.clear();
                            String now =
                                getFormattedDateAndTime(DateTime.now())[1];
                            userDetails.sendMessage(
                                Message(
                                  text: messageText,
                                  time: now,
                                  sender: userDetails.userFullName,
                                  colour: Notifier
                                      .colours[userDetails.notifierIndex],
                                ),
                                contactName);
                          });
                        },
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
    required this.message,
    required this.isMe,
    required this.colour,
  });
  late final Message message;
  late final bool isMe;
  late final Color colour;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.time,
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
            color: colour, // isMe ? Colors.green[800] : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 20.0,
              ),
              child: Text(
                message.text,
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
