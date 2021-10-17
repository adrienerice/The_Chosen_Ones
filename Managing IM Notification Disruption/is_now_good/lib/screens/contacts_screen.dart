import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:load/load.dart';

import '/screens/chat_screen.dart';
import '/screens/add_contact_screen.dart';
import '/model/notification_api.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);
  static const String id = 'contacts_screen';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  String _fullname = "";
  String myUID = '';
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotifications();
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

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    //do something with payload.
    Navigator.pushNamed(context, ChatScreen.id, arguments: payload);
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context) != null) {
      List<String> d =
          ModalRoute.of(context)!.settings.arguments as List<String>;
      myUID = d[0];
      _fullname = d[1];
    }
    //ONEDAY if more auth methods added,
    //this will need to be updated because not everyone will have an email.
    // getContactNames();
    //TODO db thing
    // var users = _firestore.collection('users').snapshots();
    // currentUserName = users;

    List<dynamic> contactNames = [];
    List<dynamic> chatIDs = [];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          Navigator.pushNamed(
            context,
            AddContactScreen.id,
            arguments: [myUID, _fullname],
          );
          /** TODO THIS IS WHERE THE NOTIFICATION THING IS IT'S HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE 
          NotificationApi.showNotification(
            title: 'Andrew Dwyer',
            body: 'How was your trip yesterday?',
            payload: 'you@you.you', //TODO add contact username here
          );*/
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: null, //removes the back button so it cant be closed out of
        actions: [
          TextButton(
            onPressed: () {
              //TODO add side screen showing more info/log out
            },
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
        title: Text('⚡️ Contacts'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _firestore.collection('chats').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                showLoadingDialog();
                return Column(
                  children: [
                    Text('Press the plus button to add a contact'),
                  ],
                );
              } else {
                hideLoadingDialog();
                var chats = snapshot.data!.docs;
                for (var chat in chats) {
                  //ONEDAY this doesn't seem secure! Firestore rules are hard :(
                  chatIDs.add(chat.id);
                  print(chat.data());
                  if (!contactNames.contains(['nameB']) &&
                      !contactNames.contains(['nameA'])) {
                    if (chat['nameA'] == _fullname) {
                      contactNames.add(chat['nameB']);
                    } else if (chat['nameB'] == _fullname) {
                      contactNames.add(chat['nameA']);
                    }
                  }
                }

                List<Widget> contacts = [];
                for (int i = 0; i < contactNames.length; i++) {
                  contacts.add(
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ChatScreen.id,
                          arguments: [
                            contactNames[i] as String,
                            chatIDs[i] as String,
                            _fullname
                          ],
                          // ONEDAY break this stuff out into model.
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: ResizeImage(
                            AssetImage('images/logo.png'),
                            width: 40,
                            height: 40,
                          ),
                        ),
                        title: Text(
                          contactNames[i].toString(),
                        ),
                        // trailing: Icon(Icons.check),
                      ),
                    ),
                  );
                }
                if (contactNames.length == 0) {
                  contacts.add(
                    Text('Use the plus button to add a contact'),
                  );
                }

                return Expanded(
                  child: ListView(
                    children: contacts,
                    // padding: EdgeInsets.symmetric(
                    //   horizontal: 10.0,
                    //   vertical: 20.0,
                    //   ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
