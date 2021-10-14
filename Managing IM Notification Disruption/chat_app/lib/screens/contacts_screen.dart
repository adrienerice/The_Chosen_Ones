import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/model/notification_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);
  static const String id = 'contacts_screen';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    //do something with payload.
    print(payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          NotificationApi.showNotification(
            title: 'Example Title',
            body: 'This is body text Bob Loblaw',
          );
        },
      ),
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
