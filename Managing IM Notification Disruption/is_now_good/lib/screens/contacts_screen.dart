import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:load/load.dart';

import '/screens/chat_screen.dart';
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
  //ONEDAY idk how to make this work with strings instead of dynamic:
  String currentUserName = "";
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
    //ONEDAY if more auth methods added, this will need to be updated because not everyone will have an email.
    // getContactNames();
    //TODO db thing
    // var users = _firestore.collection('users').snapshots();
    // currentUserName = users;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          NotificationApi.showNotification(
            title: 'Andrew Dwyer',
            body: 'How was your trip yesterday?',
            payload: 'you@you.you', //TODO add contact username here
          );
        },
      ),
      appBar: AppBar(
        leading: null, //removes the back button so it cant be closed out of
        actions: [
          TextButton(
            onPressed: () {}, //TODO add side screen showing more info/log out
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
          ContactsStream(),
        ],
      ),
    );
  }
}

class ContactsStream extends StatelessWidget {
  const ContactsStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> contactsNames = [];
    List<dynamic> contactEmails = [];
    List<dynamic> chatID = [];
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _firestore
          .collection('users')
          .snapshots() /*.where(
        (snapshot) {
          //this bs didn't work ffs
          var users = snapshot.docs;
          for (var user in users) {
            String email = user.data()['email'];
            if (email == loggedInUser!.email) {
              return true;
            }
            // //List<dynamic> emails = user.data()['contacts']['emails'];
            // bool emailIsIn = emails.contains(loggedInUser!.email);
            // return emailIsIn;
          }
          return false;
        },
      )*/
      ,
      builder: (context, snapshot) {
        List<Contact> contacts = [];
        if (!snapshot.hasData) {
          showLoadingDialog();
          return Column(
            children: [
              Text('Press the plus button to add a contact'),
            ],
          );
        } else {
          hideLoadingDialog();
          var users = snapshot.data!.docs;
          int plsBe1 = users.length;
          for (var user in users) {
            //}.docs) {
            //If the email found is the current users, this their contacts list
            //ONEDAY make contact class to separate out logic properly
            //ONEDAY this doesn't seem secure! Firestore rules are hard :(
            if (user['email'] == loggedInUser!.email) {
              contactEmails = user['contacts']['emails'];
              contactsNames = user['contacts']['names'];
              break;
            }
          }

          for (var i = 0; i < contactEmails.length; i++) {
            contacts.add(
              Contact(
                name: contactsNames[i],
                email: contactEmails[i],
                userEmail: loggedInUser!.email!,
              ),
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
    );
  }
}

class Contact extends StatelessWidget {
  // const Contact({ Key? key }) : super(key: key);
  late String name;
  late String email;
  late String userEmail;

  Contact({
    required this.name,
    required this.email,
    required this.userEmail,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        List<String> chatID = [email, userEmail];
        chatID.sort();
        Navigator.pushNamed(
          context,
          ChatScreen.id,
          //TODO rpelace with email of actual user tapped on
          //TODO change to list of lists, each list with email then name
          arguments: [name, chatID],
          // should one day also break this stuff out into model.
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
        title: Text(name),
        // trailing: Icon(Icons.check),
      ),
    );
  }
}
