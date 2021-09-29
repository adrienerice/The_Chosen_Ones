import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);
  static const String id = 'contacts_screen';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {}, //TODO add side screen showing more info/log out
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
        title: Text('⚡️ Contacts'),
      ),
      body: ListView.builder(
        itemCount: 12,
        itemBuilder: (context, index) {
          //TODO add 0 contacts case
          return TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                ChatScreen.id,
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: ResizeImage(
                  AssetImage('images/logo.png'),
                  width: 40,
                  height: 40,
                ),
              ),
              title: Text('Contact Name'),
              trailing: Icon(Icons.check),
            ),
          );
        },
      ),
    );
  }
}
