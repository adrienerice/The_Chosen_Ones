import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/contacts_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: WelcomeScreen.id,
      initialRoute: ContactsScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        // ChatScreen.id: (context) => ChatScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        // RegistrationScreen.id: (context) => RegistrationScreen(),
        ContactsScreen.id: (context) => ContactsScreen(),
      },
    );
  }
}
