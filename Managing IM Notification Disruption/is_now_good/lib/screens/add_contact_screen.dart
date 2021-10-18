import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import '/components/rounded_button.dart';
import '/constants.dart';

import 'package:provider/provider.dart';
import '/model/user_details.dart';

final _firestore = FirebaseFirestore.instance;

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({Key? key}) : super(key: key);
  static const id = 'add_contact_screen';

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  String _contactsEmail = '';
  String _contactsName = '';
  String _contactsUID = '';
  String errorMessage = '';
  String chatID = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, //ONEDAY use the main app theme properly
        title: Text('Add Contact'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            textAlign: TextAlign.center,
            onChanged: (value) {
              _contactsEmail = value;
            },
            decoration: kTextFieldDecoration.copyWith(
              hintText: 'Enter the contact\'s email address.',
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          Consumer<UserDetails>(
            builder: (context, userDetails, child) {
              return RoundedButton(
                text: 'Add Contact',
                color: Colors.lightGreenAccent,
                onPressed: () async {
                  final snackBar = SnackBar(content: Text('Loading...'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  try {
                    //get their id
                    var users =
                        (await _firestore.collection('users').get()).docs;
                    QueryDocumentSnapshot<Map<String, dynamic>>? toAdd;
                    for (var user in users) {
                      if (_contactsEmail == user['email']) {
                        toAdd = user;
                        break;
                      }
                    }
                    if (toAdd == null) {
                      Timestamp now = Timestamp.now();
                      String s = (now.seconds % 60).toString();
                      List<String> dAndT = getFormattedDateAndTime(now);
                      String d = dAndT[0];
                      String t = dAndT[1];
                      errorMessage = 'Can\'t find user with that email'
                          '\n(${s} seconds past $t, $d)';
                    } else {
                      //TODO do I need to check if it's already added that chat?
                      // get our uids
                      _contactsName = toAdd.data()['fullname'];
                      _contactsUID = toAdd.id; //id is just uid
                      String nameA = '';
                      String nameB = '';
                      // compare uids
                      if (_contactsUID.compareTo(userDetails.uid) > 0) {
                        chatID = _contactsUID.toString() +
                            userDetails.uid.toString();
                        nameA = _contactsName;
                        nameB = userDetails.userFullName;
                      } else {
                        chatID = userDetails.uid.toString() +
                            _contactsUID.toString();
                        nameA = userDetails.userFullName;
                        nameB = _contactsName;
                      }
                      //add chats document with chatID and names
                      List<String> names = [
                        userDetails.userFullName,
                        _contactsName,
                      ];
                      names.sort();
                      chatID = '';
                      for (String name in names) {
                        chatID += name;
                      }
                      _firestore.collection('chats').doc(chatID).set({
                        'nameA': nameA,
                        'nameB': nameB,
                      });
                      //Seemed to be successful?
                      Navigator.pop(context);
                      final snackBar = SnackBar(
                        content: Text(
                          'Successfully added $_contactsName',
                        ),
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  } catch (e) {
                    print(e);
                    errorMessage = e.toString();
                  }
                },
              );
            },
          ),
          Center(
              child: Text(
            errorMessage,
            textAlign: TextAlign.center,
          )),
        ],
      ),
    );
  }
}
