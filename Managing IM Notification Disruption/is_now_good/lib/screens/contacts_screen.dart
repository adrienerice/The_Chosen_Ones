import '/screens/chat_screen.dart';
import '/model/notification_api.dart';
import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);
  static const String id = 'contacts_screen';

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<String> contactNames = [];
  String currentUserEmail = "";

  @override
  void initState() {
    super.initState();
    NotificationApi.init();
    listenNotifications();
  }

  List<String> getContactNames() {
    // TODO get from database
    List<String> contacts = ['Andy Dwyer', 'Ron Swanson', 'Jeff Bezos'];
    // TODO Sort contacts by most recent message (unless they are retrieved like that automatically)
    contacts.sort();

    return contacts;
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String? payload) {
    //do something with payload.
    Navigator.pushNamed(context, ChatScreen.id, arguments: payload);
  }

  @override
  Widget build(BuildContext context) {
    // From the user ID passed in from route, get all the chats.
    currentUserEmail = ModalRoute.of(context)!.settings.arguments as String;
    contactNames = getContactNames();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          NotificationApi.showNotification(
            title: 'Andrew Dwyer',
            body: 'How was your trip yesterday?',
            payload: 'you@you.you', //TODO add contact username here
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
              Navigator.pushNamed(
                context,
                ChatScreen.id,
                //TODO rpelace with email of actual user tapped on
                //TODO change to list of lists, each list with email then name
                arguments: ['alice@alice.alice', currentUserEmail],
                // should one day also break this stuff out into model.
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
              title: Text(contactNames[index]),
              trailing: Icon(Icons.check),
            ),
          );
        },
      ),
    );
  }
}
