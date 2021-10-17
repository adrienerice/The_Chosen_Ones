import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import '/components/rounded_button.dart';
import '/constants.dart';

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
  String myUID = '';
  String myName = '';
  String chatID = '';

  @override
  Widget build(BuildContext context) {
    List<String> details =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    myUID = details[0];
    myName = details[1];

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
          RoundedButton(
            text: 'Add Contact',
            color: Colors.lightGreenAccent,
            onPressed: () async {
              setState(() {
                showLoadingDialog(); //idk if setstate is necessary
              });
              try {
                //get their id
                var users = (await _firestore.collection('users').get()).docs;
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
                  errorMessage =
                      'Can\'t find user with that email\n(${s} seconds past $t, $d)';
                } else {
                  //TODO do I need to check if it's already added that chat?
                  // get our uids
                  _contactsName = toAdd.data()['fullname'];
                  _contactsUID = toAdd.id; //id is just uid
                  String nameA = '';
                  String nameB = '';
                  // compare uids
                  if (_contactsUID.compareTo(myUID) > 0) {
                    chatID = _contactsUID.toString() + myUID.toString();
                    nameA = _contactsName;
                    nameB = myName;
                  } else {
                    chatID = myUID.toString() + _contactsUID.toString();
                    nameA = myName;
                    nameB = _contactsName;
                  }
                  //add chats document with chatID and names
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
                //TODO catch bad login deets
                print(e);
                errorMessage = e.toString();
              }
              setState(() {
                hideLoadingDialog(); //idk if setstate is necessary
              });
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

/**
 * //Check if the email is in the users list
                var users = (await _firestore.collection('users').get()).docs;
                bool foundIt = false;
                for (var user in users) {
                  var userEmail = user['email'];
                  var userName = user['fullname'];
                  if (userEmail == _contactsEmail) {
                    foundIt = true;
                    // if it is, add it to both user's contacts.
                    var potatoes = myUID;
                    var a = await _firestore.collection('users');
                    var b = a.doc(potatoes);
                    b.update(
                      // _firestore.collection('users').doc(potatoes).update(
                      {
                        'contacts': {
                          'emails': FieldValue.arrayUnion([userEmail]),
                          'names': FieldValue.arrayUnion([userName]),
                        },
                      },
                    );
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
                    break;
                  }
                }
                if (!foundIt) {
                  errorMessage = 'Couldn\'t find user with the address';
                }
 */