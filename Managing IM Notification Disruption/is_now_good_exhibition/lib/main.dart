import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:is_now_good_exhibition/screens/login_screen.dart';

import 'package:provider/provider.dart';

import '/screens/contacts_screen.dart';
import '/model/user_details.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final Future<FirebaseApp> _initialisation = Firebase.initializeApp();
  final Future _initialisation = Future.delayed(Duration(seconds: 1));
  String initialRoute = ContactsScreen.id;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserDetails>(
      create: (_) => UserDetails(),
      child: MaterialApp(
        home: LoginScreen(),
        routes: {
          ContactsScreen.id: (context) => ContactsScreen(),
          LoginScreen.id: (context) => LoginScreen(),
        },
      ),
    );
  }
}
