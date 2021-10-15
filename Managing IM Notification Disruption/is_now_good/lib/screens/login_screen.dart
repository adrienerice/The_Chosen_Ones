import 'package:flutter/material.dart';
import '/constants.dart';
import '/components/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _auth = FirebaseAuth.instance;
  bool _showSpinner = false;
  late String _email;
  late String _password; //TODO hash and salt!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              color: Colors.lightBlueAccent,
              onPressed: () async {
                setState(() {
                  _showSpinner = true;
                });
                try {
                  // final user = await _auth.signInWithEmailAndPassword(
                  //     email: _email, password: _password);
                  // if (user != null) {
                  //   Navigator.pushNamed(context, ChatScreen.id);
                  // }
                } catch (e) {
                  //TODO catch bad login deets
                  print(e);
                }
                setState(() {
                  _showSpinner = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
