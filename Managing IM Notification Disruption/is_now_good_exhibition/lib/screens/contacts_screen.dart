import 'package:flutter/material.dart';
import 'package:is_now_good_exhibition/screens/simulation_screen.dart';
import 'dart:math';

import '/constants.dart';
import 'package:provider/provider.dart';

import '/model/user_details.dart';

import '/screens/chat_screen.dart';
import '/screens/add_contact_screen.dart';

class ContactsScreen extends StatefulWidget {
  ContactsScreen({Key? key}) : super(key: key);
  static const String id = 'contacts_screen';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
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
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Consumer<UserDetails>(
          builder: (context, userDetails, child) {
            return Text('${userDetails.userFullName}\'s Contacts');
          },
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, AddContactScreen.id);
              /** TODO THIS IS WHERE THE NOTIFICATION THING IS IT'S HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE LOOK HERE 
              NotificationApi.showNotification(
                title: 'Andrew Dwyer',
                body: 'How was your trip yesterday?',
                payload: 'you@you.you', //TODO add contact username here
              );*/
            },
            icon: Icon(Icons.add, color: Colors.white),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                child: Consumer<UserDetails>(
                  //ONEDAY figure out how to use 'child' properly
                  builder: (context, userDetails, child) {
                    return const Text(
                      'Your Email Address:\nuser@name.com',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            TextButton(
              child: ListTile(
                leading: Icon(Icons.table_rows_outlined),
                title: Text('View simulation page'),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(SimulationScreen.id);
              },
            ),
          ],
        ),
      ),
      body: Consumer<UserDetails>(
        builder: (context, userDetails, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    for (var contact in userDetails.contacts)
                      ListTile(
                        leading: Icon(Icons.person),
                        /*const CircleAvatar(
                          backgroundImage: ResizeImage(
                            AssetImage('images/logo.png'),
                            width: 40,
                            height: 40,
                          ),
                        ),*/
                        title: Text(
                          contact,
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, ChatScreen.id,
                              arguments: contact);
                        },
                        // trailing: Icon(Icons.check),
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
      bottomNavigationBar: StatusBottomNavBar(),
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
