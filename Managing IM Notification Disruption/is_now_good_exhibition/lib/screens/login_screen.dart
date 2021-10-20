import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:is_now_good_exhibition/model/user_details.dart';
import 'package:provider/provider.dart';

import '/constants.dart';
import '/components/rounded_button.dart';
import '/screens/contacts_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name = '';
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
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  ' Is Now Good?',
                  textAlign: TextAlign.center,
                  //'${controller.value.toInt()}%',
                  textStyle: const TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  speed: const Duration(milliseconds: 150),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                name = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter Me Myself',
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              text: 'Log In',
              color: Colors.lightGreenAccent,
              onPressed: () {
                if (name.length == 0) {
                  name = "User Name";
                }
                Provider.of<UserDetails>(context, listen: false)
                    .updateUserName(name);
                Navigator.pushNamed(context, ContactsScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
