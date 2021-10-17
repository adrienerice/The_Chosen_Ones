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
        _fullname = (await _firestore
            .collection('users')
            .doc(user.uid)
            .get())['fullname'];
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

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _firestore.collection('users').doc(loggedInUser!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
              leading:
                  null, //removes the back button so it cant be closed out of
              actions: [
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    //TODO add side screen showing more info/log out
                  },
                ),
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    _auth.signOut();
                    print(' ----------------- LOGGED OUT ----------------- ');
                  },
                ),
              ],
              title: Text('⚡️ Contacts for $_fullname'),
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
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
