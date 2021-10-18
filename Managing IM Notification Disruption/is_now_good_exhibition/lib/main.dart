import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '/screens/add_contact_screen.dart';
import '/screens/welcome_screen.dart';
import '/screens/login_screen.dart';
import '/screens/contacts_screen.dart';
import '/screens/chat_screen.dart';
import '/screens/registration_screen.dart';

import '/model/user_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialisation = Firebase.initializeApp();
  String initialRoute = WelcomeScreen.id;
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
          return ChangeNotifierProvider<UserDetails>(
            create: (_) => UserDetails(),
            child: MaterialApp(
              home: AuthStreamBuilder(),
              routes: {
                WelcomeScreen.id: (context) => WelcomeScreen(),
                ChatScreen.id: (context) => ChatScreen(),
                LoginScreen.id: (context) => LoginScreen(),
                RegistrationScreen.id: (context) => RegistrationScreen(),
                ContactsScreen.id: (context) => ContactsScreen(),
                AddContactScreen.id: (context) => AddContactScreen(),
              },
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialisation to complete.
        return const MaterialApp();
      },
    );
  }
}

class AuthStreamBuilder extends StatefulWidget {
  const AuthStreamBuilder({Key? key}) : super(key: key);

  @override
  State<AuthStreamBuilder> createState() => _AuthStreamBuilderState();
}

class _AuthStreamBuilderState extends State<AuthStreamBuilder> {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        print(' ------------------- AUTH CHANGE --------------------- ');
        User? user = snapshot.data;
        if (user != null) {
          print(' ------------------ LOG IN ----------------------- ');
          print(user.email.toString());
          print(' ----------------------------------------- ');
          return ContactsScreen();
        } else {
          print(' -------------------- WELCOME --------------------- ');
          return WelcomeScreen();
        }
      },
    );
  }
}
