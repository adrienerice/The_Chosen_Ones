import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:is_now_good/model/user_details.dart';

import 'package:load/load.dart';

import '/components/rounded_button.dart';
import '/constants.dart';
import '/screens/contacts_screen.dart';

final _firestore = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String _email = "";
  String _password = "";
  String _fullname = "";
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    return LoadingProvider(
      themeData: LoadingThemeData(
        backgroundColor: Colors.blue,
      ),
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
                  _fullname = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your full name',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
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
                color: Colors.greenAccent,
                onPressed: () async {
                  showLoadingDialog();
                  if (_fullname.length == 0) {
                    errorText = 'Please enter your full name';
                    return;
                  }
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                      email: _email,
                      password: _password,
                    );
                    if (newUser.user != null) {
                      User user = newUser.user!;
                      _firestore.collection('users').doc(user.uid).set({
                        'email': _email,
                        'fullname': _fullname,
                      });
                      //ONEDAY this could probably be just made defaults in
                      // userDetails and only added to db on first statusUpdate
                      _firestore.collection('statuses').doc(user.uid).set({
                        'name': _fullname,
                        'status': Status.defaultStatus,
                        'time': Timestamp.now(),
                      });
                      // Navigator.pushNamed(context, ContactsScreen.id);
                      print(' ----------------- REGISTERED ----------------- ');
                    }
                  } catch (e) {
                    setState(() {
                      //ONEDAY handle this more gracefully
                      errorText = e.toString();
                    });
                  }
                  hideLoadingDialog();
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
