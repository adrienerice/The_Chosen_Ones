import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:load/load.dart';

import 'dart:math';

import '/screens/loading_screen.dart';
import '/screens/chat_screen.dart';
import '/screens/add_contact_screen.dart';
import '/model/notification_api.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ContactsScreen extends StatefulWidget {
  ContactsScreen({Key? key}) : super(key: key);
  static const String id = 'contacts_screen';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  late String _fullname;
  late String myUID;
  late String myEmail;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotifications();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print("User logged in: " + loggedInUser!.email.toString());
        var userDocument =
            (await _firestore.collection('users').doc(user.uid).get());
        _fullname = userDocument['fullname'];
        myEmail = userDocument['email'];
        myUID = user.uid;
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
    List<dynamic> contactNames = [];
    List<dynamic> chatIDs = [];

    Widget addContactsHint = const Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          'Use the plus button to add a contact',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _firestore.collection('users').doc(loggedInUser!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //hide loading dialog to solve global key issue
          //(caused by using show without hide)
          hideLoadingDialog();
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
              title: Text('Contacts for $_fullname'),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    child: Expanded(
                      child: Center(
                        child: Text(
                          'Your Email Address:\n' + myEmail,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                  ),
                  TextButton(
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Tap here to log out.'),
                    ),
                    onPressed: () {
                      _auth.signOut();
                      print(' ----------------- LOGGED OUT ----------------- ');
                    },
                  ),
                ],
              ),
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
                        children: [addContactsHint],
                      );
                    } else {
                      hideLoadingDialog();
                      var chats = snapshot.data!.docs;
                      if (chats.length == 0) {
                        print('CHATS IS ZERO LENGTH!!!!!!!!!');
                      }
                      Random rng = Random();
                      print('================= ' + rng.nextInt(100).toString());
                      for (var chat in chats) {
                        //ONEDAY this doesn't seem secure! Firestore rules are hard :(
                        print(chat.data().toString() + _fullname);
                        //check if the chat id contains my uid
                        //(which it should if I'm in it)
                        print('\n\n');
                        print('chatIDS\t\t\t\t' + chatIDs.toString());
                        print('contactNames\t\t' + contactNames.toString());
                        print('chat.id.contains(myUID) == ' +
                            chat.id.contains(myUID).toString());
                        if (chat.id.contains(myUID)) {
                          chatIDs.add(chat.id);
                          //check if the name has already been added
                          print('!contactNames.contains(chat[\'nameB\']) ' +
                              (!contactNames.contains(chat['nameB']))
                                  .toString());
                          print('!contactNames.contains(chat[\'nameA\']) ' +
                              (!contactNames.contains(chat['nameA']))
                                  .toString());
                          if (!contactNames.contains(chat['nameB']) &&
                              !contactNames.contains(chat['nameA'])) {
                            //add the name that isn't my _fullname
                            if (chat['nameA'] == _fullname) {
                              contactNames.add(chat['nameB']);
                            } else if (chat['nameB'] == _fullname) {
                              contactNames.add(chat['nameA']);
                            }
                          }
                        }
                        print('contactNames\t\t' + contactNames.toString());
                      }
                      print('=================');
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
                        contacts.add(addContactsHint);
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
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
