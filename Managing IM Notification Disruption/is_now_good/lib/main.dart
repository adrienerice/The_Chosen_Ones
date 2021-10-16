import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:load/load.dart';

import 'package:firebase_core/firebase_core.dart';

import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/registration_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialisation = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialisation,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                    'Something went wrong! The database can\'t be accessed.\nWhoops!'),
              ),
            ),
          );
        }

        // Once comlpete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            initialRoute: WelcomeScreen.id,
            // initialRoute: ContactsScreen.id,
            routes: {
              WelcomeScreen.id: (context) => WelcomeScreen(),
              ChatScreen.id: (context) => ChatScreen(),
              LoginScreen.id: (context) => LoginScreen(),
              RegistrationScreen.id: (context) => RegistrationScreen(),
              ContactsScreen.id: (context) => ContactsScreen(),
            },
          );
        }

        // Otherwise, show something whilst waiting for initialisation to complete.
        return const LoadingScreen();
      },
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Show loading once, after widget has loaded. May not be necessary.
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        showLoadingDialog();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingProvider(
      themeData: LoadingThemeData(),
      child: MaterialApp(
        home: Scaffold(
          body: Container(),
        ),
      ),
    );
  }
}
