import 'package:flutter/material.dart';
import '/components/rounded_button.dart';
import '/constants.dart';

import 'package:provider/provider.dart';
import '/model/user_details.dart';

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
                onPressed: () {
                  if (_contactsName.length > 0) {
                    userDetails.addContact(_contactsName);
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
