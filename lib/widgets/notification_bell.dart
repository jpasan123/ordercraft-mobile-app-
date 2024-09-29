import 'package:flutter/material.dart';

class NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.notifications),
      onPressed: () {
        // Implement notification handling
      },
    );
  }
}
