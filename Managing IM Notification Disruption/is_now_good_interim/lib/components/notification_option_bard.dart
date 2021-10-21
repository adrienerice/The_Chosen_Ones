import 'package:flutter/material.dart';
import 'package:is_now_good_exhibition/model/user_details.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class NotificationOptionBar extends StatefulWidget {
  const NotificationOptionBar({Key? key, this.onTappedExtra}) : super(key: key);
  final void Function()? onTappedExtra;

  @override
  _NotificationOptionBarState createState() => _NotificationOptionBarState();
}

class _NotificationOptionBarState extends State<NotificationOptionBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserDetails>(builder: (context, userDetails, child) {
      return BottomNavigationBar(
        currentIndex: userDetails.notifierIndex,
        onTap: (index) {
          setState(() {
            userDetails.updateNotifierIndex(index);
          });
          if (widget.onTappedExtra != null) {
            widget.onTappedExtra!();
          }
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        selectedIconTheme: IconThemeData(size: 45),
        items: [
          for (int i = 0; i < Notifier.labels.length; i++)
            BottomNavigationBarItem(
              backgroundColor: Notifier.colours[i],
              label: Notifier.labels[i],
              icon: Icon(Notifier.icons[i]),
            ),
        ],
      );
    });
  }
}
