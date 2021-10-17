import 'package:flutter/material.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';

import '/model/user_details.dart';

import '/screens/loading_screen.dart';
import '/screens/chat_screen.dart';
import '/screens/add_contact_screen.dart';
import '/model/notification_api.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ContactsScreen extends StatefulWidget {
  ContactsScreen({Key? key}) : super(key: key);
  static const String id = 'contacts_screen';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotifications();
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          Navigator.pushNamed(context, AddContactScreen.id);
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
        title: Consumer<UserDetails>(builder: (context, userDetails, child) {
          return Text('Contacts for ${userDetails.userFullName}');
        }),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Expanded(
                child: Center(
                  child: Consumer<UserDetails>(
                    //ONEDAY figure out how to use 'child' properly
                    builder: (context, userDetails, child) {
                      return Text(
                        'Your Email Address:\n' + userDetails.userEmail,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                      );
                    },
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
      bottomNavigationBar: StatusBottomNavBar(),
      body: Consumer<UserDetails>(
        builder: (context, userDetails, child) {
          return Column(
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
                    Random rng = Random();
                    for (var chat in chats) {
                      //ONEDAY this doesn't seem secure! Firestore rules are hard :(
                      //check if the chat id contains my uid
                      //(which it should if I'm in it)
                      if (chat.id.contains(userDetails.uid)) {
                        chatIDs.add(chat.id);
                        //check if the name has already been added
                        if (!contactNames.contains(chat['nameB']) &&
                            !contactNames.contains(chat['nameA'])) {
                          //add the name that isn't my _fullname
                          if (chat['nameA'] == userDetails.userFullName) {
                            contactNames.add(chat['nameB']);
                          } else if (chat['nameB'] ==
                              userDetails.userFullName) {
                            contactNames.add(chat['nameA']);
                          }
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
                              arguments: chatIDs[i] as String,
                            );
                          },
                          child: ListTile(
                            leading: const CircleAvatar(
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
                    if (contactNames.isEmpty) {
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
          );
        },
      ),
    );
  }
}

class CustomFutureBuilder extends StatefulWidget {
  const CustomFutureBuilder({Key? key}) : super(key: key);

  @override
  _CustomFutureBuilderState createState() => _CustomFutureBuilderState();
}

class _CustomFutureBuilderState extends State<CustomFutureBuilder> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _firestore.collection('users').doc(loggedInUser!.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          //hide loading dialog to solve global key issue
          //(caused by using show without hide)
          hideLoadingDialog();
          return Container();
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}

class StatusBottomNavBar extends StatefulWidget {
  const StatusBottomNavBar({Key? key}) : super(key: key);

  @override
  _StatusBottomNavBarState createState() => _StatusBottomNavBarState();
}

class _StatusBottomNavBarState extends State<StatusBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    int statusIndex = 0;
    List<String> statuses = ['none', 'busy', 'maybe', 'free'];
    List<IconData> statusIcons = [
      Icons.circle_outlined,
      Icons.do_not_disturb_on_outlined,
      Icons.contact_support,
      Icons.done,
    ];
    List<Color> statusColours = [
      Colors.blueGrey,
      Colors.red,
      Colors.amber,
      Colors.green,
    ];

    return BottomNavigationBar(
      items: [
        for (var i = 0; i < statuses.length; i++)
          BottomNavigationBarItem(
            label: statuses[i],
            backgroundColor: statusColours[i],
            icon: Icon(statusIcons[i]),
          ),
      ],
      currentIndex: statusIndex,
      selectedItemColor: Colors.black54,
      onTap: (index) {
        setState(() {
          statusIndex = index;
          //TODO update database with status
        });
      },
    );
  }
}
