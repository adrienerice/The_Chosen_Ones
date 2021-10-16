import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:load/load.dart';

import '/constants.dart';
import '/components/rounded_button.dart';
import 'package:is_now_good/screens/contacts_screen.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String errorMessage = '';
  late String _email;
  late String _password; //TODO hash and salt!

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    // TODO Check if logged in already and skip screen
    // TODO Check about session persistence between uses!!!!
    return LoadingProvider(
      themeData: LoadingThemeData(),
      child: Scaffold(
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
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  _password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password.',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                text: 'Log In',
                color: Colors.lightGreenAccent,
                onPressed: () async {
                  setState(() {
                    showLoadingDialog(); //idk if setstate is necessary
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: _email, password: _password);
                    if (user != null && user.user != null) {
                      //get users full name
                      String fullname = (await _firestore
                          .collection('users')
                          .doc(user.user!.uid)
                          .get())['fullname'];
                      Navigator.pushNamed(
                        context,
                        ContactsScreen.id,
                        arguments: [user.user!.uid, fullname],
                      );
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
              Text(errorMessage),
            ],
          ),
        ),
      ),
    );
  }
}
