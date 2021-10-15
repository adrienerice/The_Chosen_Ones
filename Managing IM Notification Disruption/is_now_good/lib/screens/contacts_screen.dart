// import '/screens/chat_screen.dart';
import '/model/notification_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);
  static const String id = 'contacts_screen';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<String> contactNames = [];

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotifications();
    contactNames = getContactNames();
  }

  List<String> getContactNames() {
    // TODO get from database
    return ['Andy Dwyer', 'Ron Swanson', 'Jeff Bezos'];
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    //do something with payload.
    // Navigator.pushNamed(context, ChatScreen.id, arguments: payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          NotificationApi.showNotification(
            title: 'Andrew Dwyer - Is Now Good?',
            body: 'How was your trip yesterday?',
            payload: 'Andrey Dwyer',
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
        itemCount: contactNames.length,
        itemBuilder: (context, index) {
          //TODO add 0 contacts case
          return TextButton(
            onPressed: () {
              // Navigator.pushNamed(
              //   context,
              //   ChatScreen.id,
              // );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: ResizeImage(
                  AssetImage('images/logo.png'),
                  width: 40,
                  height: 40,
                ),
              ),
              title: Text(contactNames[index]),
              trailing: Icon(Icons.check),
            ),
          );
        },
      ),
    );
  }
}
