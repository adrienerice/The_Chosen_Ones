import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:is_now_good/screens/contacts_screen.dart';

import 'package:load/load.dart';

import '/components/rounded_button.dart';
import '/constants.dart';
import '/screens/chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String _email = "";
  String _password = "";
  String _name = "";
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return LoadingProvider(
      themeData: LoadingThemeData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  _email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                'Email doesn\'t have to be real.'
                '\nAs long as it is in the form xxx@xxx.xxx',
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  _name = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  //TODO salt and hash?
                  _password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text('Password must be at least 6 characters long'),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                text: 'Register',
                color: Colors.blueAccent,
                onPressed: () async {
                  setState(() {
                    showLoadingDialog(); //idk if this needs call to setState
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                      email: _email,
                      password: _password,
                    );
                    if (newUser != null && newUser.user != null) {
                      // newUser.user!.updateDisplayName(_name);
                      // _auth.currentUser!.updateDisplayName(_name);
                      // print('REGISTERED ' + newUser.user!.uid);
                      // _auth.
                      //TODO add name and email to users(email, name, contacts(emails in array))
                      Navigator.pushNamed(
                        context,
                        ContactsScreen.id,
                        arguments: _email,
                      );
                    }
                  } catch (e) {
                    //TODO deal with new user exceptions
                    print(e);
                    setState(() {
                      errorText = e.toString();
                    });
                  }
                  setState(() {
                    hideLoadingDialog(); //idk if this needs call to setState
                  });
                },
              ),
              Text(errorText),
            ],
          ),
        ),
      ),
    );
  }
}
